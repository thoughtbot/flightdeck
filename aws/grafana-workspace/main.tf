resource "aws_grafana_workspace" "this" {
  account_access_type       = "CURRENT_ACCOUNT"
  authentication_providers  = var.authentication_providers
  description               = "Grafana instance for Flightdeck applications"
  name                      = var.name
  notification_destinations = ["SNS"]
  permission_type           = "CUSTOMER_MANAGED"
  role_arn                  = aws_iam_role.grafana.arn
  grafana_version           = var.grafana_version

  configuration = jsonencode({
    unifiedAlerting = { enabled = true }
  })
}

resource "aws_iam_role" "grafana" {
  name               = coalesce(var.iam_role_name, "${lower(var.name)}-service")
  assume_role_policy = data.aws_iam_policy_document.grafana_trust.json
  tags               = { "grafana.service" = "true" }
}

resource "aws_iam_role_policy_attachment" "grafana" {
  role       = aws_iam_role.grafana.name
  policy_arn = aws_iam_policy.grafana.arn
}

data "aws_iam_policy_document" "grafana" {
  statement {
    sid     = "AssumeTelemetryRoles"
    actions = ["sts:AssumeRole"]

    resources = [
      for account_id in local.workload_account_ids :
      "arn:aws:iam::${account_id}:role/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/grafana.service"
      values   = ["true"]
    }
  }
}

resource "aws_iam_policy" "grafana" {
  name   = "flightdeck-grafana"
  policy = data.aws_iam_policy_document.grafana.json
}

data "aws_iam_policy_document" "grafana_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["grafana.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_grafana_role_association" "admin" {
  count = length(var.admin_groups) == 0 ? 0 : 1

  role         = "ADMIN"
  group_ids    = var.admin_groups
  workspace_id = aws_grafana_workspace.this.id
}

resource "aws_grafana_role_association" "editor" {
  count = length(var.editor_groups) == 0 ? 0 : 1

  role         = "EDITOR"
  group_ids    = var.editor_groups
  workspace_id = aws_grafana_workspace.this.id
}

resource "aws_grafana_role_association" "viewer" {
  count = length(var.viewer_groups) == 0 ? 0 : 1

  role         = "VIEWER"
  group_ids    = var.viewer_groups
  workspace_id = aws_grafana_workspace.this.id
}

resource "aws_grafana_workspace_api_key" "initial" {
  key_name        = var.grafana_api_key_name
  key_role        = "ADMIN"
  seconds_to_live = 60 * 60 * 24 * 16
  workspace_id    = aws_grafana_workspace.this.id
}

module "api_key" {
  source = "./modules/rotating-api-key"

  initial_api_key = aws_grafana_workspace_api_key.initial.key
  name            = "grafana-workspace-${var.name}"
  workspace_url   = "https://${aws_grafana_workspace.this.endpoint}"
}

resource "aws_ssm_parameter" "grafana_workspace_id" {
  name  = join("/", concat(["", "flightdeck", "grafana", var.name, "workspace_id"]))
  type  = "String"
  value = aws_grafana_workspace.this.id
}

resource "aws_ssm_parameter" "grafana_api_key_secret" {
  name  = join("/", concat(["", "flightdeck", "grafana", var.name, "secret_arn"]))
  type  = "SecureString"
  value = module.api_key.secret_arn
}

data "aws_caller_identity" "this" {}

locals {
  workload_account_ids = coalesce(
    var.workload_account_ids,
    [data.aws_caller_identity.this.account_id]
  )
}
