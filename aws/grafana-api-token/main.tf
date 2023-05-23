data "aws_ssm_parameter" "grafana_workspace_id" {
  name = join(
    "/",
    concat([
      "",
      "flightdeck",
      "grafana",
      var.grafana_workspace_name,
      "workspace_id"
    ])
  )
}

data "aws_ssm_parameter" "grafana_api_token_secret" {
  name = join(
    "/",
    concat([
      "",
      "flightdeck",
      "grafana",
      var.grafana_workspace_name,
      "secret_arn"
    ])
  )
}

data "aws_grafana_workspace" "this" {
  workspace_id = data.aws_ssm_parameter.grafana_workspace_id.value
}

data "aws_secretsmanager_secret_version" "api_token" {
  secret_id = data.aws_ssm_parameter.grafana_api_token_secret.value
}

locals {
  auth = jsondecode(
    data.aws_secretsmanager_secret_version.api_token.secret_string
  ).GRAFANA_API_KEY
}
