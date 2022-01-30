resource "helm_release" "this" {
  chart     = "${path.module}/chart"
  name      = var.name
  namespace = var.k8s_namespace
  values    = concat([local.chart_values], var.chart_values)
}

locals {
  chart_values = yamlencode({
    version = local.version
  })

  version = sha1(join("", [
    for file in fileset(path.module, "chart/templates/*") :
    filesha1("${path.module}/${file}")
  ]))
}
