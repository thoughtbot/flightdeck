output "aws_prometheus_workspace_id" {
  description = "Id for the prometheus workspace created in AWS"
  value       = aws_prometheus_workspace.this.id
}
