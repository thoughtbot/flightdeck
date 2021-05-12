module "workload_cluster" {
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

  aws_namespace = var.aws_namespace
  aws_tags      = var.aws_tags
  k8s_namespace = var.k8s_namespace
  oidc_issuer   = var.oidc_issuer
}
