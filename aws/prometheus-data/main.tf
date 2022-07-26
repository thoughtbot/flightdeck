data "aws_caller_identity" "this" {}

data "aws_s3_bucket_object" "prometheus" {

  bucket = join("-", concat([
    "prometheus",
    var.aws_prometheus_workspace_name,
    data.aws_caller_identity.this.account_id
  ]))

  key = "ingestion.json"
}

locals {
  prometheus_workspace_json = join("", data.aws_s3_bucket_object.prometheus.*.body)
  prometheus_data = merge(
    jsondecode(local.prometheus_workspace_json),
    { "name" : var.aws_prometheus_workspace_name }
  )
}
