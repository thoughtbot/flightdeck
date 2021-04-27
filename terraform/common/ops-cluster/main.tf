resource "kubernetes_namespace" "flightdeck" {
  metadata {
    name = var.k8s_namespace

    labels = {
      "istio-injection" = "enabled"
    }
  }
}

module "dex_secret" {
  source = "../../common/dex-secret"

  clients       = ["argocd"]
  k8s_namespace = kubernetes_namespace.flightdeck.metadata[0].name
}

module "argocd_secret" {
  source = "../../common/argocd-secret"

  host          = var.host
  k8s_namespace = kubernetes_namespace.flightdeck.metadata[0].name

  extra_secrets = {
    "oidc.dex.clientID"     = "argocd"
    "oidc.dex.clientSecret" = module.dex_secret.client_secrets.argocd
  }
}
