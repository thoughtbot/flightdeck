resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.trust.json
  name               = var.name

  tags = merge(
    var.tags,
    { "grafana.workspace.${var.grafana_workspace_name}" = "true" }
  )
}

resource "aws_iam_role_policy_attachment" "grafana" {
  policy_arn = aws_iam_policy.grafana.arn
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  policy_arn = data.aws_iam_policy.cloudwatch.arn
  role       = aws_iam_role.this.name
}

resource "aws_iam_policy" "grafana" {
  name   = var.name
  policy = data.aws_iam_policy_document.grafana.json
  tags   = var.tags
}

data "aws_iam_policy_document" "grafana" {
  statement {
    sid       = "AllowPrometheus"
    resources = ["*"]

    actions = [
      "aps:DescribeWorkspace",
      "aps:GetAlertManagerStatus",
      "aps:GetLabels",
      "aps:GetMetricMetadata",
      "aps:GetSeries",
      "aps:ListAlertManagerAlertGroups",
      "aps:ListAlertManagerAlerts",
      "aps:ListAlertManagerSilences",
      "aps:ListWorkspaces",
      "aps:ListRules",
      "aps:QueryMetrics",
    ]
  }
}

data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"

      identifiers = [
        for account_id in local.monitoring_account_ids :
        "arn:aws:iam::${account_id}:root"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "iam:ResourceTag/grafana.workspace.${var.name}"
      values   = ["true"]
    }
  }
}

data "aws_iam_policy" "cloudwatch" {
  name = "AmazonGrafanaCloudWatchAccess"
}

data "aws_caller_identity" "this" {}

locals {
  monitoring_account_ids = coalesce(var.monitoring_account_ids, [data.aws_caller_identity.this.account_id])
}
