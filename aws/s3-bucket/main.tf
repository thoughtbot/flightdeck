resource "aws_s3_bucket" "this" {
  bucket = local.name
  policy = var.policy
  tags   = var.tags

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_key == null ? null : var.kms_key.id
        sse_algorithm     = var.kms_key == null ? "AES256" : "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = var.block_public_access ? 1 : 0

  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

locals {
  name = join("-", concat(var.namespace, [var.name]))
}
