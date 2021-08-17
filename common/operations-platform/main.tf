module "dex" {
  source = "../../common/dex"

  chart_values  = concat(local.dex_values, var.dex_values)
  extra_secrets = var.dex_extra_secrets
  k8s_namespace = var.flightdeck_namespace

  static_clients = {}
}

module "ui" {
  source = "../../common/ui"

  chart_values  = concat(local.ui_values, var.ui_values)
  k8s_namespace = var.flightdeck_namespace
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
