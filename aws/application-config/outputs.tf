output "deploy_group" {
  description = "Name of the group bound to deploy roles"
  value       = module.deploy_role_bindings.group_name
}

output "developer_group" {
  description = "Name of the group bound to developer roles"
  value       = module.developer_role_bindings.group_name
}

output "namespace" {
  description = "Kubernetes amepsace for this application"
  value       = var.namespace
}

output "pod_service_account" {
  description = "Name of the service account for application pods"
  value       = kubernetes_service_account.pods.metadata[0].name
}
