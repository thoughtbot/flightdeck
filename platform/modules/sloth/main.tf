resource "helm_release" "sloth" {
  chart      = var.chart_name
  name       = var.name
  namespace  = var.k8s_namespace
  repository = var.chart_repository
  version    = var.sloth_version
}
