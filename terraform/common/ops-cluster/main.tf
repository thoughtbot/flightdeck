resource "kubernetes_namespace" "istio" {
  metadata {
    name = var.istio_namespace
  }
}

module "istio" {
  source = "../../common/istio"

  chart_version = var.istio_version
  k8s_namespace = kubernetes_namespace.istio.metadata[0].name
}

resource "kubernetes_namespace" "flightdeck" {
  metadata {
    name = var.flightdeck_namespace

    labels = {
      "istio-injection" = "enabled"
    }
  }

  depends_on = [module.istio]
}

module "cert_manager" {
  source = "../../common/cert-manager"

  chart_values  = var.cert_manager_values
  chart_version = var.cert_manager_version
  k8s_namespace = kubernetes_namespace.flightdeck.metadata[0].name
}

module "dex" {
  source = "../../common/dex"

  chart_values  = concat(local.dex_values, var.dex_values)
  k8s_namespace = kubernetes_namespace.flightdeck.metadata[0].name

  static_clients = {
    argocd = {
      name         = "ArgoCD"
      redirectURIs = ["https://${var.host}/argocd/auth/callback"]
    }
  }
}

module "external_dns" {
  source = "../../common/external-dns"

  chart_values  = var.external_dns_values
  chart_version = var.external_dns_version
  k8s_namespace = kubernetes_namespace.flightdeck.metadata[0].name
}

module "istio_ingress" {
  source = "../../common/istio-ingress"

  chart_values  = var.istio_ingress_values
  chart_version = var.istio_version
  k8s_namespace = kubernetes_namespace.flightdeck.metadata[0].name
}

module "argocd" {
  source = "../../common/argocd"

  chart_values  = concat(local.argocd_values, var.argocd_values)
  chart_version = var.argocd_version
  host          = var.host
  k8s_namespace = kubernetes_namespace.flightdeck.metadata[0].name

  extra_secrets = {
    "oidc.dex.clientID"     = "argocd"
    "oidc.dex.clientSecret" = module.dex.client_secrets.argocd
  }
}

module "ui" {
  source = "../../common/ui"

  chart_values  = concat(local.ui_values, var.ui_values)
  k8s_namespace = kubernetes_namespace.flightdeck.metadata[0].name

  depends_on = [
    module.istio_ingress,
    module.cert_manager
  ]
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
