module "common_platform" {
  source = "../../common/workload-platform"

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

module "argocd_cluster_config" {
  source = "../argocd-cluster-config"

  argocd_service_account_role_arn = var.argocd_service_account_role_arn
  aws_namespace                   = var.aws_namespace
  cluster_name                    = var.cluster_name
}

module "auth_config_map" {
  source = "../auth-config-map"

  admin_roles  = concat(local.admin_roles, var.admin_roles)
  custom_roles = var.custom_roles
  node_roles   = concat(local.node_roles, var.node_roles)
}

data "aws_ssm_parameter" "node_role_arn" {
  name = join("/", concat(
    [""],
    var.aws_namespace,
    ["clusters", var.cluster_name, "node_role_arn"]
  ))
}

locals {
  admin_roles = [module.argocd_cluster_config.argocd_role_arn]
  node_roles  = [data.aws_ssm_parameter.node_role_arn.value]
}
