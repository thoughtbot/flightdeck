resource "helm_release" "this" {
  chart     = "${path.module}/chart"
  name      = var.name
  namespace = var.k8s_namespace
  values    = concat([local.chart_values], var.chart_values)
}

locals {
  chart_values = yamlencode({
  })
}
