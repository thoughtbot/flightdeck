resource "helm_release" "base" {
  chart      = var.base_chart_name
  name       = "istio-base"
  namespace  = var.k8s_namespace
  repository = var.base_chart_repository
  values     = var.base_chart_values
  version    = coalesce(var.istio_version, file("${path.module}/VERSION"))
}

resource "helm_release" "discovery" {
  chart      = var.discovery_chart_name
  name       = "istio-discovery"
  namespace  = var.k8s_namespace
  repository = var.discovery_chart_repository
  values     = concat(local.discovery_chart_values, var.discovery_chart_values)
  version    = coalesce(var.istio_version, file("${path.module}/VERSION"))

  depends_on = [helm_release.base]
}

locals {
  discovery_chart_values = [
    yamlencode({
      global = {
        istioNamespace = var.k8s_namespace
        proxy = {
          # Ensure istio-proxy starts before other containers
          holdApplicationUntilProxyStarts = true
        }
      }
    })
  ]
}
