module "common_platform" {
  source = "../../common/operations-platform"

  argocd_github_repositories = var.argocd_github_repositories
  argocd_policy              = var.argocd_policy
  argocd_values              = concat(local.argocd_values, var.argocd_values)
  certificate_email          = var.certificate_email
  certificate_solvers        = local.certificate_solvers
  dex_extra_secrets          = var.dex_extra_secrets
  dex_values                 = var.dex_values
  host                       = var.host

  cert_manager_values = concat(
    module.workload_values.cert_manager_values,
    var.cert_manager_values
  )

  external_dns_values = concat(
    module.workload_values.external_dns_values,
    var.external_dns_values
  )
}

module "workload_values" {
  source = "../workload-values"

  aws_namespace  = var.aws_namespace
  aws_tags       = var.aws_tags
  cluster_name   = var.cluster_name
  domain_filters = var.domain_filters
  k8s_namespace  = var.k8s_namespace
}

module "argocd_service_account_role" {
  source = "../argocd-service-account-role"

  aws_namespace   = var.aws_namespace
  aws_tags        = var.aws_tags
  cluster_configs = var.cluster_configs
  k8s_namespace   = var.k8s_namespace
  oidc_issuer     = module.workload_values.oidc_issuer
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

  certificate_solvers = yamlencode([
    {
      dns01 = {
        route53 = {
          region = data.aws_region.current.name
        }
      }
      selector = {
        dnsZones = var.domain_filters
      }
    }
  ])
}

data "aws_region" "current" {}
