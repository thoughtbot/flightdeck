resource "helm_release" "ui" {
  chart     = "${path.module}/chart"
  name      = var.name
  namespace = var.k8s_namespace
  values    = var.chart_values
}
