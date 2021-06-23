resource "aws_ssm_parameter" "secret" {
  type  = "SecureString"
  name  = join("/", concat(["", "flightdeck", var.name, "secret"]))
  value = jsonencode(var.secret_data)
}

resource "aws_ssm_parameter" "policies" {
  type  = "String"
  name  = join("/", concat(["", "flightdeck", var.name, "policies"]))
  value = jsonencode(var.policies)
}
