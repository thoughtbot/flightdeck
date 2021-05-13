output "argocd_cluster_config" {
  description = "JSON data for configuring an ArgoCD cluster"
  value       = module.argocd_cluster_config.json
}
