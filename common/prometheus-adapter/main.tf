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
      prometheus = {
        port = 9090
        url  = "http://kube-prometheus-stack-prometheus.${var.k8s_namespace}.svc"
      }

      rules = yamldecode(file("${path.module}/rules.yaml"))
    })
  ]
}
