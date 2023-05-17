data "aws_region" "this" {}

data "aws_prometheus_workspace" "this" {
  workspace_id = data.aws_ssm_parameter.workspace_id.value
}

data "aws_ssm_parameter" "workspace_id" {
  name = join("/", concat(["", "flightdeck", "prometheus", var.aws_prometheus_workspace_name, "workspace_id"]))
}

data "aws_ssm_parameter" "ingestion_role_arn" {
  name = join("/", concat(["", "flightdeck", "prometheus", var.aws_prometheus_workspace_name, "ingestion_role_arn"]))
}

locals {
  prometheus_data = {
    host       = local.workspace_host
    query_path = "${local.workspace_path}/api/v1/query"
    name       = var.aws_prometheus_workspace_name
    region     = data.aws_region.this.name
    role_arn   = data.aws_ssm_parameter.ingestion_role_arn.value
    write_path = "${local.workspace_path}/api/v1/remote_write"
    url        = "https://${local.workspace_host}/${local.workspace_path}/"
  }
}

locals {
  workspace_host = "aps-workspaces.${data.aws_region.this.name}.amazonaws.com"
  workspace_path = "workspaces/${data.aws_prometheus_workspace.this.id}"
}
