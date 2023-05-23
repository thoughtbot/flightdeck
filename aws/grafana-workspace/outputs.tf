output "arn" {
  description = "ARN for this Grafana workspace"
  value       = aws_grafana_workspace.this.arn
}

output "endpoint" {
  description = "URL for accessing this Grafana workspace"
  value       = aws_grafana_workspace.this.endpoint
}

