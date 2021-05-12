module "workload_cluster" {
  source = "../workload-platform"

  cert_manager_values  = var.cert_manager_values
  cert_manager_version = var.cert_manager_version
  external_dns_values  = var.external_dns_values
  external_dns_version = var.external_dns_version
  flightdeck_namespace = var.flightdeck_namespace
  istio_ingress_values = var.istio_ingress_values
  istio_namespace      = var.istio_namespace
  istio_version        = var.istio_version
}

module "dex" {
  source = "../../common/dex"

  chart_values  = concat(local.dex_values, var.dex_values)
  k8s_namespace = module.workload_cluster.flightdeck_namespace

  static_clients = {
    argocd = {
      name         = "ArgoCD"
      redirectURIs = ["https://${var.host}/argocd/auth/callback"]
    }
  }

  depends_on = [module.workload_cluster]
}

module "argocd" {
  source = "../../common/argocd"

  chart_values  = concat(local.argocd_values, var.argocd_values)
  chart_version = var.argocd_version
  host          = var.host
  k8s_namespace = module.workload_cluster.flightdeck_namespace

  extra_secrets = {
    "oidc.dex.clientID"     = "argocd"
    "oidc.dex.clientSecret" = module.dex.client_secrets.argocd
  }

  depends_on = [module.workload_cluster]
}

module "ui" {
  source = "../../common/ui"

  chart_values  = concat(local.ui_values, var.ui_values)
  k8s_namespace = module.workload_cluster.flightdeck_namespace

  depends_on = [module.workload_cluster]
}

locals {
  argocd_values = [
    yamlencode({
      server = {
        config = {
          "oidc.config" = yamlencode(local.argocd_oidc_config)
          "url"         = "https://${var.host}/argocd"
        }
      }
    })
  ]

  argocd_oidc_config = {
    clientID     = "$oidc.dex.clientID"
    clientSecret = "$oidc.dex.clientSecret"
    issuer       = "https://${var.host}/dex"
    name         = "Flightdeck"
  }

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
