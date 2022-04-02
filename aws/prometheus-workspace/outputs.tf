output "aws_prometheus_workspace_endpoint" {
  description = "Prometheus endpoint available for this workspace"
  value       = aws_prometheus_workspace.this.prometheus_endpoint
}

output "aws_prometheus_workspace_id" {
  description = "Id for the prometheus workspace created in AWS"
  value       = aws_prometheus_workspace.this.id
}
