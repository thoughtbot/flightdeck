output "arn" {
  description = "ARN for this Grafana workspace"
  value       = data.aws_grafana_workspace.this.arn
}

output "auth" {
  description = "Auth header for connecting to this Grafana workspace"
  value       = local.auth
}

output "url" {
  description = "URL for accessing this Grafana workspace"
  value       = "https://${data.aws_grafana_workspace.this.endpoint}"
}

