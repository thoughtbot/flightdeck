module "fluent_bit_service_account_role" {
  source = "../../../service-account-role"

  name             = "fluent-bit"
  namespace        = var.aws_namespace
  oidc_issuers     = [var.oidc_issuer]
  service_accounts = ["${var.k8s_namespace}:fluent-bit"]
  tags             = var.aws_tags
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "${var.log_group_prefix}/${var.cluster_full_name}"
  retention_in_days = var.retention_in_days
  skip_destroy      = var.skip_destroy
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
    sid = "AllowWriteLogs"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutRetentionPolicy",
    ]
    resources = [
      "${local.arn_prefix}:log-group:${var.log_group_prefix}/*"
    ]
  }
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

locals {
  arn_prefix = join(":", [
    "arn",
    data.aws_partition.current.partition,
    "logs",
    data.aws_region.current.name,
    data.aws_caller_identity.current.account_id,
  ])
}
