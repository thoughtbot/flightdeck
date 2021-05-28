resource "helm_release" "istio_ingress" {
  chart     = "${var.chart_path}/gateways/istio-ingress"
  name      = var.name
  namespace = var.k8s_namespace
  values    = concat(local.chart_values, var.chart_values)
  version   = var.istio_version
}

locals {
  chart_values = [
    yamlencode({
      gateways = {
        istio-ingressgateway = {
          name = "flightdeck-ingressgateway"
          labels = {
            istio = "flightdeck"
          }
        }
      }
      global = {
        istioNamespace = var.istio_namespace
      }
    })
  ]
}
