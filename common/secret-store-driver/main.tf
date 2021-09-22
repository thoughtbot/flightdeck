resource "helm_release" "this" {
  chart      = coalesce(var.chart_name, local.chart_defaults.chart)
  name       = var.name
  namespace  = var.k8s_namespace
  repository = coalesce(var.chart_repository, local.chart_defaults.repository)
  values     = concat(local.chart_values, var.chart_values)
  version    = coalesce(var.chart_version, local.chart_defaults.version)
}

locals {
  chart_defaults = jsondecode(file("${path.module}/chart.json"))

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
