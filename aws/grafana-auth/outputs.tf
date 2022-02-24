output "api_key" {
  description = "Current API key for Grafana"

  value = jsondecode(
    data.aws_secretsmanager_secret_version.latest_version.secret_string
  ).GRAFANA_API_KEY
}

output "policy_json" {
  description = "Required IAM policies"
  value       = module.secret.policy_json
}

output "secret_arn" {
  description = "ARN of the secrets manager secret containing credentials"
  value       = module.secret.arn
}

output "secret_name" {
  description = "Name of the secrets manager secret containing credentials"
  value       = module.secret.name
}
