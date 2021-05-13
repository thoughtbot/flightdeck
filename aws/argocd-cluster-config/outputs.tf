output "argocd_role" {
  description = "IAM role ArgoCD assumes to deploy to this cluster"
  value       = aws_iam_role.argocd
}

output "argocd_role_arn" {
  description = "ARN of the IAM role ArgoCD assumes to deploy to this cluster"
  value       = aws_iam_role.argocd.arn
}

output "json" {
  description = "JSON used for configuring a cluster in ArgoCD"
  value       = jsonencode(local.argocd_cluster_config)
}
