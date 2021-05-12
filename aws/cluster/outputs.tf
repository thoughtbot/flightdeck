output "cluster_name" {
  description = "Name of the created cluster"
  value       = local.cluster_name
}

output "node_role_arn_parameter" {
  description = "SSM parameter which contains the ARN of the IAM role for nodes"
  value       = aws_ssm_parameter.node_role_arn.name
}

output "oidc_issuer_parameter" {
  description = "SSM parameter which contains the OIDC issuer URL"
  value       = aws_ssm_parameter.oidc_issuer.name
}

output "vpc_id_parameter" {
  description = "SSM parameter which contains the VPC ID"
  value       = aws_ssm_parameter.vpc_id.name
}
