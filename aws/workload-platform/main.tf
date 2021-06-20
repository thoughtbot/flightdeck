module "common_platform" {
  source = "../../common/workload-platform"

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

  admin_roles       = var.admin_roles
  aws_tags          = var.aws_tags
  cluster_full_name = module.cluster_name.full
  custom_roles      = var.custom_roles
  domain_filters    = var.domain_filters
  k8s_namespace     = var.k8s_namespace
  node_roles        = var.node_roles
}
