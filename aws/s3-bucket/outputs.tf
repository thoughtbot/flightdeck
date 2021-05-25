output "arn" {
  description = "ARN for the created S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "instance" {
  description = "The created S3 bucket"
  value       = aws_s3_bucket.this
}

output "name" {
  description = "The name of the created S3 bucket"
  value       = aws_s3_bucket.this.bucket
}
