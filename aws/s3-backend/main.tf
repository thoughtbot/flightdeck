resource "aws_s3_bucket" "state" {
  bucket        = var.bucket
  tags          = var.tags
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "locks" {
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  name         = var.dynamodb_table
  tags         = var.tags
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}
