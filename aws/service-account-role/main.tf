resource "aws_iam_role" "this" {
  name                  = join("-", concat(var.namespace, [var.name]))
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  force_detach_policies = true
  tags                  = var.tags
}

resource "aws_iam_policy" "this" {
  for_each = var.policy_json == null ? [] : [true]

  name   = join("-", concat(var.namespace, [var.name]))
  policy = var.policy_json
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = aws_iam_policy.this

  role       = aws_iam_role.this.name
  policy_arn = each.value.arn
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
