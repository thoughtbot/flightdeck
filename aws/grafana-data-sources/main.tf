resource "grafana_data_source" "prometheus" {
  for_each = local.prometheus_workspaces

  is_default = length(var.prometheus_workspace_names) == 1
  name       = each.key
  type       = "prometheus"
  url        = each.value.url

  json_data {
    http_method     = "POST"
    sigv4_auth      = true
    sigv4_auth_type = "default"
    sigv4_region    = each.value.region
  }
}

resource "grafana_data_source" "cloudwatch" {
  type = "cloudwatch"
  name = "cloudwatch"

  json_data {
    default_region = data.aws_region.this.name
    auth_type      = "default"
  }
}

data "aws_s3_bucket_object" "prometheus" {
  for_each = toset(var.prometheus_workspace_names)

  bucket = join("-", concat([
    "prometheus",
    each.value,
    data.aws_caller_identity.this.account_id
  ]))

  key = "ingestion.json"
}

data "aws_caller_identity" "this" {}

data "aws_region" "this" {}

locals {
  prometheus_workspaces = zipmap(
    var.prometheus_workspace_names,
    [
      for name in var.prometheus_workspace_names :
      jsondecode(data.aws_s3_bucket_object.prometheus[name].body)
    ]
  )
}
