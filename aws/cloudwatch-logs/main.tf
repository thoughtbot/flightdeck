module "fluent_bit_service_account_role" {
  source = "../service-account-role"

  name             = "fluent-bit"
  namespace        = var.aws_namespace
  oidc_issuer      = var.oidc_issuer
  policy_json      = data.aws_iam_policy_document.fluent_bit_service_account_role.json
  service_accounts = ["${var.k8s_namespace}:fluent-bit"]
  tags             = var.aws_tags
}

resource "aws_cloudwatch_log_group" "this" {
  name              = join("/", ["", "flightdeck", var.cluster_full_name])
  retention_in_days = var.retention_in_days
  tags              = var.aws_tags
}

data "aws_iam_policy_document" "fluent_bit_service_account_role" {
  statement {
    sid = "AllowCreateLogEvents"
    actions = [
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.this.arn}:log-stream:*"
    ]
  }

  statement {
    sid = "AllowCreateLogStream"
    actions = [
      "logs:CreateLogStream"
    ]
    resources = [
      aws_cloudwatch_log_group.this.arn,
      "${aws_cloudwatch_log_group.this.arn}:log-stream:*"
    ]
  }
}
