resource "helm_release" "istio_ingress" {
  chart      = var.chart_name
  name       = var.name
  namespace  = var.k8s_namespace
  repository = "${var.chart_repository}?ref=${var.chart_version}&sparse=0"
  values     = concat(local.chart_values, var.chart_values)
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
