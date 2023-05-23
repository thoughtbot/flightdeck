module "sns_topics" {
  source = "./modules/sns-topics"

  admin_principals = var.admin_principals
  tags             = var.tags

  sns_topic_names = flatten([
    for source in ["alertmanager", "cloudwatch-alarms", "cloudwatch-logs"] :
    [
      for severity in var.alert_severities :
      "${source}-${severity}"
    ]
  ])
}

module "prometheus_workspace" {
  source = "./modules/prometheus-workspace"

  alert_group_by         = var.alert_group_by
  alert_message_template = var.alert_message_template
  alert_resolve_timeout  = var.alert_resolve_timeout
  alert_subject_template = var.alert_subject_template
  name                   = var.prometheus_workspace_name
  tags                   = var.tags

  sns_receivers = merge({
    default = module.sns_topics.arns["alertmanager-${var.alert_default_severity}"]
    },
    zipmap(
      var.alert_severities,
      [
        for severity in var.alert_severities :
        module.sns_topics.arns["alertmanager-${severity}"]
      ]
    )
  )
}

module "grafana_role" {
  source = "./modules/grafana-role"

  grafana_workspace_name = var.grafana_workspace_name
  monitoring_account_ids = var.monitoring_account_ids
  name                   = var.grafana_role_name
}

resource "aws_ssm_parameter" "prometheus_workspace_id" {
  name  = join("/", concat(["", "flightdeck", "prometheus", var.prometheus_workspace_name, "workspace_id"]))
  type  = "String"
  value = module.prometheus_workspace.aws_prometheus_workspace_id
}

resource "aws_ssm_parameter" "ingestion_role_arn" {
  name  = join("/", concat(["", "flightdeck", "prometheus", var.prometheus_workspace_name, "ingestion_role_arn"]))
  type  = "String"
  value = module.prometheus_workspace.ingestion_role_arn
}
