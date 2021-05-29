output "cluster_name" {
  description = "Full ame of the created cluster"
  value       = module.cluster_name.full
}

output "node_role_arn_parameter" {
  description = "SSM parameter which contains the ARN of the IAM role for nodes"
  value       = aws_ssm_parameter.node_role_arn.name
}

output "oidc_issuer_parameter" {
  description = "SSM parameter which contains the OIDC issuer URL"
  value       = aws_ssm_parameter.oidc_issuer.name
}
