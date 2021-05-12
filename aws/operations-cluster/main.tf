module "operations_cluster" {
  source = "../../common/operations-cluster"

  argocd_values = concat(local.argocd_values, var.argocd_values)
  host          = var.host

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
  domain_filters = var.domain_filters
  k8s_namespace  = var.k8s_namespace
  oidc_issuer    = var.oidc_issuer
}

module "argocd_service_account_role" {
  source = "../argocd-service-account-role"

  aws_namespace     = var.aws_namespace
  aws_tags          = var.aws_tags
  cluster_role_arns = var.cluster_role_arns
  k8s_namespace     = var.k8s_namespace
  oidc_issuer       = var.oidc_issuer
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
}
