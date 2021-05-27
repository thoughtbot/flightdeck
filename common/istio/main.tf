resource "helm_release" "base" {
  chart     = "${var.chart_path}/base"
  name      = "istio-base"
  namespace = var.k8s_namespace
  values    = var.base_chart_values
}

resource "helm_release" "discovery" {
  chart     = "${var.chart_path}/istio-control/istio-discovery"
  name      = "istio-discovery"
  namespace = var.k8s_namespace
  values    = concat(local.discovery_chart_values, var.discovery_chart_values)

  depends_on = [helm_release.base]
}

locals {
  discovery_chart_values = [
    yamlencode({
      global = {
        istioNamespace = var.k8s_namespace
      }
    })
  ]
}
