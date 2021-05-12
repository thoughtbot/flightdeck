module "ops_cluster" {
  source = "../../common/operations-cluster"

  argocd_values       = concat(local.argocd_values, var.argocd_values)
  cert_manager_values = concat(local.cert_manager_values, var.cert_manager_values)
  external_dns_values = concat(local.external_dns_values, var.external_dns_values)
  host                = var.host
}

module "argocd_service_account_role" {
  source = "../argocd-service-account-role"

  aws_namespace = var.aws_namespace
  aws_tags      = var.aws_tags
  k8s_namespace = var.k8s_namespace
  oidc_issuer   = var.oidc_issuer
}

module "dns_service_account_role" {
  source = "../dns-service-account-role"

  aws_namespace = var.aws_namespace
  aws_tags      = var.aws_tags
  k8s_namespace = var.k8s_namespace
  oidc_issuer   = var.oidc_issuer
}

module "cluster_autoscaler_service_account_role" {
  source = "../cluster-autoscaler-service-account-role"

  aws_namespace = var.aws_namespace
  aws_tags      = var.aws_tags
  k8s_namespace = var.k8s_namespace
  oidc_issuer   = var.oidc_issuer
}

locals {
  argocd_values = [
    yamlencode({
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = module.argocd_service_account_role.arn
        }
      }
    })
  ]

  cert_manager_values = [
    yamlencode({
      securityContext = {
        # https://github.com/jetstack/cert-manager/issues/2147
        fsGroup = 1001
      }
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = module.dns_service_account_role.arn
        }
      }
    })
  ]

  external_dns_values = [
    yamlencode({
      aws = {
        region = data.aws_region.current.name
      }
      domainFilters = var.domain_filters
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = module.dns_service_account_role.arn
        }
      }
    })
  ]
}

data "aws_region" "current" {}
