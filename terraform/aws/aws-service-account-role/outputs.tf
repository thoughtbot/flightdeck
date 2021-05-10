output "arn" {
  description = "The ARN of the created role"
  value       = aws_iam_role.this.arn
}

output "instance" {
  description = "The created role"
  value       = aws_iam_role.this
}
