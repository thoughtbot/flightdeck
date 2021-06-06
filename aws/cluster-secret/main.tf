resource "kubernetes_secret" "this" {
  metadata {
    name      = join("-", [var.kind, var.name])
    namespace = var.namespace
  }

  data = jsondecode(data.aws_ssm_parameter.secret.value)
}

resource "aws_iam_policy_attachment" "this" {
  for_each = local.attachments

  name       = each.value.name
  policy_arn = each.value.policy_arn
}

data "aws_ssm_parameter" "secret" {
  name = join("/", ["", "flightdeck", var.kind, var.name, "secret"])
}

data "aws_ssm_parameter" "policies" {
  name = join("/", ["", "flightdeck", var.kind, var.name, "policies"])
}

locals {
  policy_arns = jsondecode(data.aws_ssm_parameter.policies.value)

  attachment_values = flatten(
    [
      for role in var.roles :
      [
        for policy_arn in local.policy_arns :
        {
          key        = "${role.name}/${policy_arn}"
          name       = role.name
          policy_arn = policy_arn
        }
      ]
    ]
  )

  attachments = zipmap(
    local.attachment_values.*.key,
    local.attachment_values
  )
}
