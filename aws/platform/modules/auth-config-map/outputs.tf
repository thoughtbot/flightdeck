output "breakglass_role_arn" {
  description = "ARN for a breakglass role in case of cluster lockout"
  value       = aws_iam_role.breakglass.arn
}
