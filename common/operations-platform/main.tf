module "workload_platform" {
  source = "../workload-platform"

  cert_manager_values         = var.cert_manager_values
  cert_manager_version        = var.cert_manager_version
  cluster_autoscaler_values   = var.cluster_autoscaler_values
  cluster_autoscaler_version  = var.cluster_autoscaler_version
  external_dns_values         = var.external_dns_values
  external_dns_version        = var.external_dns_version
  flightdeck_namespace        = var.flightdeck_namespace
  istio_ingress_values        = var.istio_ingress_values
  istio_namespace             = var.istio_namespace
  istio_version               = var.istio_version
  prometheus_operator_values  = var.prometheus_operator_values
  prometheus_operator_version = var.prometheus_operator_version
}

module "dex" {
  source = "../../common/dex"

  chart_values  = concat(local.dex_values, var.dex_values)
  extra_secrets = var.dex_extra_secrets
  k8s_namespace = module.workload_platform.flightdeck_namespace

  static_clients = {
    argocd = {
      name         = "ArgoCD"
      redirectURIs = ["https://${var.host}/argocd/auth/callback"]
    }
  }

  depends_on = [module.workload_platform]
}

module "argocd" {
  source = "../../common/argocd"

  chart_values        = concat(local.argocd_values, var.argocd_values)
  chart_version       = var.argocd_version
  github_repositories = var.argocd_github_repositories
  host                = var.host
  k8s_namespace       = module.workload_platform.flightdeck_namespace
  kustomize_versions  = var.kustomize_versions
  policy              = var.argocd_policy

  extra_secrets = {
    "oidc.dex.clientID"     = "argocd"
    "oidc.dex.clientSecret" = module.dex.client_secrets.argocd
  }

  depends_on = [module.workload_platform]
}

module "ui" {
  source = "../../common/ui"

  chart_values  = concat(local.ui_values, var.ui_values)
  k8s_namespace = module.workload_platform.flightdeck_namespace

  depends_on = [module.workload_platform]
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
      certificate = {
        issuer = {
          acme = {
            email   = var.certificate_email
            solvers = yamldecode(var.certificate_solvers)
          }
        }
      }
      ingress = {
        host = var.host
      }
    })
  ]
}
