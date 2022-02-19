output "arn" {
  description = "ARN of the created IAM policy"
  value       = aws_iam_policy.this.arn
}

output "json" {
  description = "Combined JSON policy"
  value       = data.aws_iam_policy_document.this.json
}
