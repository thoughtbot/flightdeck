resource "helm_release" "ingress_config" {
  chart     = "${path.module}/chart"
  name      = var.name
  namespace = var.k8s_namespace
  values    = local.chart_values
}

locals {
  chart_values = [yamlencode({
    certificate = {
      domains = var.domain_names

      issuer = {
        email = var.certificate_email
        acme  = { solvers = yamldecode(var.certificate_solvers) }
      }
    }

    gateway = {
      domains = var.domain_names
    }
  })]
}
