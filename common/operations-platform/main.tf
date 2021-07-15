module "workload_platform" {
  source = "../workload-platform"

  cert_manager_values         = var.cert_manager_values
  cert_manager_version        = var.cert_manager_version
  certificate_email           = var.certificate_email
  certificate_solvers         = var.certificate_solvers
  cluster_autoscaler_values   = var.cluster_autoscaler_values
  cluster_autoscaler_version  = var.cluster_autoscaler_version
  domain_names                = concat(var.domain_names, [var.host])
  external_dns_values         = var.external_dns_values
  external_dns_version        = var.external_dns_version
  flightdeck_namespace        = var.flightdeck_namespace
  fluent_bit_values           = var.fluent_bit_values
  fluent_bit_version          = var.fluent_bit_version
  istio_ingress_values        = var.istio_ingress_values
  istio_namespace             = var.istio_namespace
  istio_version               = var.istio_version
  prometheus_adapter_values   = var.prometheus_adapter_values
  prometheus_adapter_version  = var.prometheus_adapter_version
  prometheus_operator_values  = var.prometheus_operator_values
  prometheus_operator_version = var.prometheus_operator_version
}

module "dex" {
  source = "../../common/dex"

  chart_values  = concat(local.dex_values, var.dex_values)
  extra_secrets = var.dex_extra_secrets
  k8s_namespace = module.workload_platform.flightdeck_namespace

  static_clients = {}

  depends_on = [module.workload_platform]
}

module "ui" {
  source = "../../common/ui"

  chart_values  = concat(local.ui_values, var.ui_values)
  k8s_namespace = module.workload_platform.flightdeck_namespace

  depends_on = [module.workload_platform]
}

locals {
  dex_values = [
    yamlencode({
      issuer = {
        host = var.host
        path = "/dex"
      }
    })
  ]

  ui_values = [
    yamlencode({
      ingress = {
        host = var.host
      }
    })
  ]
}
