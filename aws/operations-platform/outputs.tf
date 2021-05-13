output "argocd_service_account_role_arn" {
  description = "ARN of the IAM role used by ArgoCD's service account"
  value       = module.argocd_service_account_role.arn
}
