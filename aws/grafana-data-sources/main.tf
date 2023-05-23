resource "grafana_data_source" "prometheus" {
  is_default = false
  name       = local.prometheus_data_source
  type       = "prometheus"
  url        = data.aws_prometheus_workspace.this.prometheus_endpoint

  json_data_encoded = jsonencode({
    alertmanagerUid    = grafana_data_source.alertmanager.uid
    httpMethod         = "POST"
    sigV4Auth          = true
    sigV4AuthType      = "default"
    sigV4Region        = data.aws_region.this.name
    sigV4AssumeRoleArn = data.aws_iam_role.grafana.arn
  })
}

resource "grafana_data_source" "cloudwatch" {
  type = "cloudwatch"
  name = local.cloudwatch_data_source

  json_data_encoded = jsonencode({
    defaultRegion = data.aws_region.this.name
    authType      = "default"
    assumeRoleArn = data.aws_iam_role.grafana.arn
  })
}

resource "grafana_data_source" "alertmanager" {
  type = "alertmanager"
  name = local.alertmanager_data_source
  url  = "${data.aws_prometheus_workspace.this.prometheus_endpoint}alertmanager"

  json_data_encoded = jsonencode({
    implementation     = "prometheus"
    sigV4Auth          = true
    sigV4AuthType      = "default"
    sigV4Region        = data.aws_region.this.name
    sigV4AssumeRoleArn = data.aws_iam_role.grafana.arn
  })
}

data "aws_iam_role" "grafana" {
  name = var.grafana_role_name
}

data "aws_prometheus_workspace" "this" {
  workspace_id = data.aws_ssm_parameter.prometheus_workspace_id.value
}

data "aws_ssm_parameter" "prometheus_workspace_id" {
  name = join("/", concat(["", "flightdeck", "prometheus", local.prometheus_workspace_name, "workspace_id"]))
}

data "aws_region" "this" {}

locals {
  alertmanager_data_source = coalesce(
    var.alertmanager_data_source_name,
    "AlertManager (${var.name})"
  )

  cloudwatch_data_source = coalesce(
    var.cloudwatch_data_source_name,
    "Cloudwatch (${var.name})"
  )

  prometheus_data_source = coalesce(
    var.prometheus_data_source_name,
    "Prometheus (${var.name})"
  )

  prometheus_workspace_name = coalesce(
    var.prometheus_workspace_name,
    "flightdeck-${var.name}"
  )
}
