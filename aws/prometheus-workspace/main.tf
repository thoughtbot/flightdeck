resource "aws_prometheus_workspace" "this" {
  alias = var.name

  dynamic "logging_configuration" {
    for_each = var.logging_configuration != null ? [1] : []
    content {
      log_group_arn = var.logging_configuration.log_group_arn
    }
  }
}

resource "aws_iam_role" "ingestion" {
  assume_role_policy = data.aws_iam_policy_document.ingestion_assume_role.json
  name               = join("-", concat([var.name, "prometheus", "ingestion"]))
  tags               = merge(var.tags, { "prometheus.workspace" = var.name })
}

resource "aws_iam_policy" "ingestion" {
  name   = aws_iam_role.ingestion.name
  policy = data.aws_iam_policy_document.ingestion.json
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

resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "this" {
  bucket       = aws_s3_bucket.this.bucket
  content_type = "application/json"
  key          = "ingestion.json"

  content = jsonencode({
    host       = local.workspace_host
    query_path = "${local.workspace_path}/api/v1/query"
    name       = var.name
    region     = data.aws_region.this.name
    role_arn   = aws_iam_role.ingestion.arn
    write_path = "${local.workspace_path}/api/v1/remote_write"
    url        = "https://${local.workspace_host}/${local.workspace_path}/"
  })
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.bucket
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    sid     = "AllowAdministrativeAccess"
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"
      ]
    }
  }

  dynamic "statement" {
    for_each = local.workload_account_ids

    content {
      sid    = "Allow${statement.value}"
      effect = "Allow"
      actions = [
        "s3:Get*",
        "s3:List*"
      ]
      resources = [
        aws_s3_bucket.this.arn,
        "${aws_s3_bucket.this.arn}/*",
      ]

      principals {
        type = "AWS"
        identifiers = [
          "arn:aws:iam::${statement.value}:root"
        ]
      }
    }
  }
}

data "aws_caller_identity" "this" {}

data "aws_region" "this" {}

locals {
  bucket_name = join("-", concat([
    "prometheus",
    var.name,
    data.aws_caller_identity.this.account_id
  ]))

  workspace_host = "aps-workspaces.${data.aws_region.this.name}.amazonaws.com"

  workspace_path = "workspaces/${aws_prometheus_workspace.this.id}"

  workload_account_ids = concat(
    var.workload_account_ids,
    [data.aws_caller_identity.this.account_id]
  )
}
