module "cloudwatch_adapter_service_account_role" {
  source = "../../../service-account-role"

  name             = "cloudwatch-adapter"
  namespace        = var.aws_namespace
  oidc_issuers     = [var.oidc_issuer]
  service_accounts = ["${var.k8s_namespace}:cloudwatch-adapter"]
  tags             = var.aws_tags
}

resource "aws_iam_policy" "this" {
  name   = module.cloudwatch_adapter_service_account_role.name
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = module.cloudwatch_adapter_service_account_role.name
  policy_arn = aws_iam_policy.this.arn
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "cloudwatch:GetMetricData"
    ]
    resources = ["*"]
  }
}
