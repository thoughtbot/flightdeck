module "fluent_bit_service_account_role" {
  source = "../service-account-role"

  name             = "fluent-bit"
  namespace        = var.aws_namespace
  oidc_issuers     = [var.oidc_issuer]
  service_accounts = ["${var.k8s_namespace}:fluent-bit"]
  tags             = var.aws_tags
}

resource "aws_cloudwatch_log_group" "this" {
  name              = join("/", ["", "flightdeck", var.cluster_full_name])
  retention_in_days = var.retention_in_days
  tags              = var.aws_tags
}

resource "aws_iam_policy" "this" {
  name   = module.fluent_bit_service_account_role.name
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = module.fluent_bit_service_account_role.name
  policy_arn = aws_iam_policy.this.arn
}

data "aws_iam_policy_document" "this" {
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
