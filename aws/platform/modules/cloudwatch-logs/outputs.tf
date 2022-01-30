output "log_group_name" {
  description = "Name of the created Cloudwatch log group"
  value       = aws_cloudwatch_log_group.this.name
}

output "service_account_role_arn" {
  description = "ARN of the AWS IAM role created for service accounts"
  value       = module.fluent_bit_service_account_role.instance.arn
}
