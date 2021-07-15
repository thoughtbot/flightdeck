output "arn" {
  description = "The ARN of the created role"
  value       = aws_iam_role.this.arn
}

output "instance" {
  description = "The created role"
  value       = aws_iam_role.this
}

output "name" {
  description = "The name of the created role"
  value       = aws_iam_role.this.name
}
