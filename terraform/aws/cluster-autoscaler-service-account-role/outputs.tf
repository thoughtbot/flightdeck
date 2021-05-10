output "arn" {
  description = "The ARN of the created role"
  value       = module.cluster_autoscaler_service_account_role.instance.arn
}

output "service_account_role_arn" {
  description = "ARN of the AWS IAM role created for service accounts"
  value       = module.cluster_autoscaler_service_account_role.instance.arn
}
