resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" : module.role.arn
    }
  }
}

module "role" {
  source = "git@github.com:thoughtbot/flightdeck.git//aws/service-account-role?ref=f97a961"

  name             = var.name
  namespace        = ["serviceaccount", var.cluster_name, var.namespace]
  oidc_issuer      = data.aws_ssm_parameter.oidc_issuer.value
  service_accounts = ["${var.namespace}:${var.name}"]
  tags             = var.tags
}

data "aws_ssm_parameter" "oidc_issuer" {
  name = join("/", concat(["", "flightdeck", var.cluster_name, "oidc_issuer"]))
}
