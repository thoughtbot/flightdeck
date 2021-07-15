resource "aws_iam_role" "this" {
  name                  = local.name
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  force_detach_policies = true
  tags                  = var.tags
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        join(
          "/",
          [
            join(
              ":",
              [
                "arn",
                data.aws_partition.current.partition,
                "iam",
                "",
                data.aws_caller_identity.current.account_id,
                "oidc-provider"
              ]
            ),
            var.oidc_issuer
          ]
        )
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_issuer}:sub"

      values = [
        for service_account in var.service_accounts :
        "system:serviceaccount:${service_account}"
      ]
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  name = join(
    "-",
    distinct(split("-", join("-", concat(var.namespace, [var.name]))))
  )
}
