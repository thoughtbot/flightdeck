resource "helm_release" "this" {
  chart      = var.chart_name
  name       = var.name
  namespace  = var.k8s_namespace
  repository = var.chart_repository
  values     = concat(local.chart_values, var.chart_values)
  version    = var.chart_version
}

locals {
  chart_values = [
    yamlencode({
      fullnameOverride = var.name

      # Ensure fluent-bit is able to run on each node
      priorityClassName = "system-node-critical"
    }),
    templatefile("${path.module}/filters.yaml", {
      annotations = var.enable_kubernetes_annotations ? "On" : "Off"
      labels      = var.enable_kubernetes_labels ? "On" : "Off"
    })
  ]
}
