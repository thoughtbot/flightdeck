module "prometheus_service_account_role" {
  source = "../../../service-account-role"

  name             = var.role_name
  namespace        = var.aws_namespace
  oidc_issuers     = [var.oidc_issuer]
  service_accounts = ["${var.k8s_namespace}:${var.service_account_name}"]

  tags = merge(
    var.aws_tags,
    { "prometheus.workspace" = var.workspace_name }
  )
}

resource "aws_iam_policy" "this" {
  name   = module.prometheus_service_account_role.name
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = module.prometheus_service_account_role.name
  policy_arn = aws_iam_policy.this.arn
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    resources = ["arn:aws:iam::${var.workspace_account_id}:role/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/prometheus.workspace"
      values   = [var.workspace_name]
    }
  }
}
