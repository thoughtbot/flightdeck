resource "helm_release" "base" {
  chart      = var.base_chart_name
  name       = "${var.name}-base"
  namespace  = var.k8s_namespace
  repository = "${var.chart_repository}?ref=${var.chart_version}&sparse=0"
  values     = var.base_chart_values
}

resource "helm_release" "discovery" {
  chart      = var.discovery_chart_name
  name       = "${var.name}-discovery"
  namespace  = var.k8s_namespace
  repository = "${var.chart_repository}/istio-control?ref=${var.chart_version}&sparse=0"
  values     = concat(local.discovery_chart_values, var.discovery_chart_values)

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
  repository = "${var.chart_repository}?ref=${var.chart_version}&sparse=0"
}
