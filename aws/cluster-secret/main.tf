resource "kubernetes_secret" "this" {
  metadata {
    name      = join("-", [var.kind, var.name])
    namespace = var.namespace
  }

  data = jsondecode(data.aws_ssm_parameter.this.value)
}

data "aws_ssm_parameter" "this" {
  name = join("/", ["", "flightdeck", var.kind, var.name, "secret"])
}
