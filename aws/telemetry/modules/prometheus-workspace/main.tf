resource "aws_prometheus_workspace" "this" {
  alias = var.name
  tags  = var.tags
}

resource "aws_iam_role" "ingestion" {
  assume_role_policy = data.aws_iam_policy_document.ingestion_assume_role.json
  name               = join("-", concat([var.name, "prometheus", "ingestion"]))
  tags               = merge(var.tags, { "prometheus.workspace" = var.name })
}

resource "aws_iam_policy" "ingestion" {
  name   = aws_iam_role.ingestion.name
  policy = data.aws_iam_policy_document.ingestion.json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "ingestion" {
  role       = aws_iam_role.ingestion.name
  policy_arn = aws_iam_policy.ingestion.arn
}

data "aws_iam_policy_document" "ingestion" {
  statement {
    actions = [
      "aps:RemoteWrite",
      "aps:GetSeries",
      "aps:GetLabels",
      "aps:GetMetricMetadata"
    ]
    resources = [aws_prometheus_workspace.this.arn]
  }
}

data "aws_iam_policy_document" "ingestion_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        for account_id in local.workload_account_ids :
        "arn:aws:iam::${account_id}:root"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "iam:ResourceTag/prometheus.workspace"
      values   = [var.name]
    }
  }
}

resource "aws_prometheus_alert_manager_definition" "this" {
  definition   = yamlencode(local.alert_manager_definition)
  workspace_id = aws_prometheus_workspace.this.id
}

data "aws_caller_identity" "this" {}

data "aws_region" "current" {}

locals {
  workload_account_ids = concat(
    var.workload_account_ids,
    [data.aws_caller_identity.this.account_id]
  )

  alert_manager_definition = {
    alertmanager_config = yamlencode(local.alertmanager_config)
    template_files      = yamldecode(file("${path.module}/template_files.yaml"))
  }

  alert_group_by = coalesce(
    var.alert_group_by,
    ["alertname", "sloth_id", "severity", "summary", "description"]
  )

  alert_message_template = coalesce(
    var.alert_message_template,
    "{{ template \"sns.default.message\" .}} - {{ template \"sns.default.subject\" .}} "
  )

  alert_resolve_timeout = coalesce(var.alert_resolve_timeout, "5m")

  alert_subject_template = coalesce(
    var.alert_subject_template,
    "{{ .GroupLabels.alertname }}: {{ .CommonAnnotations.summary }}"
  )

  alertmanager_config = {
    global = {
      resolve_timeout = local.alert_resolve_timeout
    }

    route = {
      group_by = local.alert_group_by
      receiver = "default"

      routes = [
        for name, topic_arn in var.sns_receivers :
        {
          receiver = name

          matchers = [
            "severity = ${name}"
          ]
        }
      ]
    }

    receivers = [
      for name, topic_arn in var.sns_receivers :
      {
        name = name
        sns_configs = [
          {
            message   = local.alert_message_template
            subject   = local.alert_subject_template
            topic_arn = topic_arn

            attributes = {
              tags = "{{ range .Alerts }}{{ .Labels.Values | join \",\" }}{{end}}"
            }

            sigv4 = {
              region = data.aws_region.current.name
            }
          }
        ]
      }
    ]
  }
}
