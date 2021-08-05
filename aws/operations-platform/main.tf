module "common_platform" {
  source = "../../common/operations-platform"

  certificate_issuer        = var.certificate_issuer
  dex_extra_secrets         = var.dex_extra_secrets
  dex_values                = var.dex_values
  domain_names              = var.domain_names
  external_dns_enabled      = var.external_dns_enabled
  host                      = var.host
  pagerduty_routing_key     = module.workload_values.pagerduty_routing_key
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

  istio_ingress_values = concat(
    module.workload_values.istio_ingress_values,
    var.istio_ingress_values
  )

  prometheus_operator_values = concat(
    module.workload_values.prometheus_operator_values,
    var.prometheus_operator_values
  )
}

module "aws_load_balancer_controller" {
  source = "../load-balancer-controller"

  aws_namespace     = [module.cluster_name.full]
  aws_tags          = var.aws_tags
  chart_values      = var.aws_load_balancer_controller_values
  chart_version     = var.aws_load_balancer_controller_version
  cluster_full_name = module.cluster_name.full
  k8s_namespace     = var.k8s_namespace
  oidc_issuer       = module.workload_values.oidc_issuer
  vpc_cidr_block    = module.network.vpc.cidr_block

  depends_on = [module.common_platform]
}

module "cluster_name" {
  source = "../cluster-name"

  name      = var.cluster_name
  namespace = var.aws_namespace
}

module "network" {
  source = "../network-data"

  network_tags = module.cluster_name.shared_tags
  private_tags = module.cluster_name.private_tags
  public_tags  = module.cluster_name.public_tags
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
  pagerduty_parameter    = var.pagerduty_parameter
}
