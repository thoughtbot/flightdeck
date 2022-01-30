resource "helm_release" "ingress_config" {
  chart     = "${path.module}/chart"
  name      = var.name
  namespace = var.k8s_namespace
  values    = local.chart_values
}

locals {
  chart_values = [yamlencode({
    certificate = merge(
      {
        domains = var.domain_names
      },
      (
        var.issuer == null ?
        {} :
        { issuer = yamldecode(var.issuer) }
      )
    )
  })]
}
