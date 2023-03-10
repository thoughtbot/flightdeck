resource "kubernetes_manifest" "certificate" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"

    metadata = {
      name      = "flightdeck"
      namespace = var.k8s_namespace
    }

    spec = {
      dnsNames    = var.domain_names
      duration    = "2160h"
      isCA        = false
      renewBefore = "360h"
      secretName  = "flightdeck-tls"
      subject     = { organizations = ["flightdeck"] }
      usages      = ["server auth", "client auth"]

      issuerRef = {
        kind = local.issuer.kind
        name = local.issuer.name
      }

      privateKey = {
        algorithm = "RSA"
        encoding  = "PKCS1"
        size      = 2048
      }
    }
  }
}

resource "kubernetes_manifest" "gateway" {
  manifest = {
    apiVersion = "networking.istio.io/v1alpha3"
    kind       = "Gateway"

    metadata = {
      name      = "flightdeck"
      namespace = var.k8s_namespace
    }

    spec = {
      selector = {
        istio = "flightdeck-ingressgateway"
      }

      servers = [
        {
          hosts = ["*"]

          port = {
            name     = "http"
            number   = 80
            protocol = "HTTP"
          }

          tls = {
            httpsRedirect = true
          }
        },
        {
          hosts = ["*"]
          port = {
            name     = "https"
            number   = 443
            protocol = "HTTPS"
          }
          tls = {
            credentialName = "flightdeck-tls"
            mode           = "SIMPLE"
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "issuer" {
  count = try(local.issuer.create, true) ? 1 : 0

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Issuer"

    metadata = {
      name      = local.issuer.name
      namespace = var.k8s_namespace
    }

    spec = yamlencode(local.issuer.spec)
  }
}

locals {
  issuer = (
    var.issuer == null ?
    {
      name = "flightdeck"
      spec = {
        selfSigned = {}
      }
    } :
    yamldecode(var.issuer)
  )
}
