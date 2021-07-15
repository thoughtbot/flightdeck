module "common_platform" {
  source = "../../common/operations-platform"

  certificate_email         = var.certificate_email
  certificate_solvers       = module.workload_values.certificate_solvers
  dex_extra_secrets         = var.dex_extra_secrets
  dex_values                = var.dex_values
  domain_names              = var.domain_names
  host                      = var.host
  prometheus_adapter_values = var.prometheus_adapter_values

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

  fluent_bit_values = concat(
    module.workload_values.fluent_bit_values,
    var.fluent_bit_values
  )

  prometheus_operator_values = concat(
    module.workload_values.prometheus_operator_values,
    var.prometheus_operator_values
  )
}

module "cluster_name" {
  source = "../cluster-name"

  name      = var.cluster_name
  namespace = var.aws_namespace
}

module "workload_values" {
  source = "../workload-values"

  admin_roles            = var.admin_roles
  aws_tags               = var.aws_tags
  cluster_full_name      = module.cluster_name.full
  custom_roles           = var.custom_roles
  hosted_zones           = var.hosted_zones
  k8s_namespace          = var.k8s_namespace
  logs_retention_in_days = var.logs_retention_in_days
  node_roles             = var.node_roles
}
