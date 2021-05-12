output "arn" {
  description = "ARN of the AWS IAM role created for service accounts"
  value       = module.argocd_service_account_role.instance.arn
}
