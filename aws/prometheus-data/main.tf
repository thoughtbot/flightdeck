data "aws_caller_identity" "this" {}

data "aws_region" "current" {}

locals {
  prometheus_data = {
    "host" : "aps-workspaces.${data.aws_region.current.name}.amazonaws.com",
    "name" : var.aws_prometheus_workspace_name,
    "query_path" : "workspaces/${var.aws_prometheus_workspace_id}/api/v1/query",
    "region" : data.aws_region.current.name,
    "role_arn" : "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/flightdeck-prometheus-ingestion",
    "write_path" : "workspaces/${var.aws_prometheus_workspace_id}/api/v1/remote_write"
  }
}