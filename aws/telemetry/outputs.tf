output "aws_prometheus_workspace_endpoint" {
  description = "Prometheus endpoint available for this workspace"
  value       = module.prometheus_workspace.aws_prometheus_workspace_endpoint
}

output "aws_prometheus_workspace_id" {
  description = "Id for the prometheus workspace created in AWS"
  value       = module.prometheus_workspace.aws_prometheus_workspace_id
}

output "sns_topic_arns" {
  description = "ARNs of the created SNS topics"
  value       = module.sns_topics.arns
}

output "kms_key_id" {
  description = "ID of the KMS key created to encrypt SNS messages"
  value       = module.sns_topics.kms_key_id
}
