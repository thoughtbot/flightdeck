module "common_platform" {
  source = "../../common/workload-platform"

  cert_manager_values = concat(
    module.workload_values.cert_manager_values,
    var.cert_manager_values
  )

  cluster_autoscaler_values = concat(
    module.workload_values.cluster_autoscaler_values,
    var.cluster_autoscaler_values
  )

  external_dns_values = concat(
    module.workload_values.external_dns_values,
    var.external_dns_values
  )

  prometheus_operator_values = concat(
    module.workload_values.prometheus_operator_values,
    var.prometheus_operator_values
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

  argocd_service_account_role_arn = local.operations_config.argocd_service_account_role_arn
  aws_namespace                   = var.aws_namespace
  cluster_name                    = var.cluster_name
}

module "auth_config_map" {
  source = "../auth-config-map"

  admin_roles   = concat(local.admin_roles, var.admin_roles)
  aws_namespace = var.aws_namespace
  aws_tags      = var.aws_tags
  cluster_name  = var.cluster_name
  custom_roles  = var.custom_roles
  node_roles    = concat(local.node_roles, var.node_roles)
}

data "aws_s3_bucket_object" "operations_config" {
  bucket = var.config_bucket
  key    = "operations.json"
}

resource "aws_s3_bucket_object" "cluster_config" {
  bucket       = var.config_bucket
  content_type = "application/json"
  key          = "workload-clusters/${local.name}.json"
  content      = module.argocd_cluster_config.json
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
  name        = join("-", concat(var.aws_namespace, [var.cluster_name]))
  node_roles  = [data.aws_ssm_parameter.node_role_arn.value]

  operations_config = jsondecode(
    data.aws_s3_bucket_object.operations_config.body
  )
}
