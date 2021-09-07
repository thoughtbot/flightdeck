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
      linux = {
        # The driver must run on each node for secrets to be loaded
        priorityClassName = "system-node-critical"
      }

      enableSecretRotation = true
      syncSecret = {
        enabled = true
      }
    })
  ]
}
