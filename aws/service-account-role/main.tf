resource "aws_iam_role" "this" {
  name                  = local.name
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  force_detach_policies = true
  tags                  = var.tags
}

resource "aws_iam_role_policy" "inline" {
  count = length(var.policy_documents) == 0 ? 0 : 1

  name   = "${local.name}-inline"
  policy = data.aws_iam_policy_document.inline_policy.json
  role   = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  policy_arn = each.value
  role       = aws_iam_role.this.name
}

data "aws_iam_policy_document" "inline_policy" {
  source_policy_documents = var.policy_documents
}

data "aws_iam_policy_document" "assume_role" {
  dynamic "statement" {
    for_each = local.oidc_issuers

    content {
      actions = ["sts:AssumeRoleWithWebIdentity"]

      principals {
        identifiers = ["${local.oidc_root}/${statement.value}"]
        type        = "Federated"
      }

      condition {
        test     = "StringEquals"
        variable = "${statement.value}:sub"

        values = [
          for service_account in var.service_accounts :
          "system:serviceaccount:${service_account}"
        ]
      }
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

data "aws_ssm_parameter" "oidc_issuer" {
  for_each = toset(var.cluster_names)

  name = join("/", concat(["", "flightdeck", each.value, "oidc_issuer"]))
}

locals {
  name = join(
    "-",
    distinct(split("-", join("-", concat(var.namespace, [var.name]))))
  )

  oidc_root = join(
    ":",
    [
      "arn",
      data.aws_partition.current.partition,
      "iam",
      "",
      data.aws_caller_identity.current.account_id,
      "oidc-provider"
    ]
  )

  cluster_issuers = values(data.aws_ssm_parameter.oidc_issuer).*.value
  oidc_issuers    = concat(var.oidc_issuers, local.cluster_issuers)
}
