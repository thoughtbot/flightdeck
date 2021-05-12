output "cluster_name" {
  description = "Name of the created cluster"
  value       = local.cluster_name
}

output "vpc_id_parameter" {
  description = "SSM parameter which contains the VPC ID"
  value       = aws_ssm_parameter.vpc_id.name
}

output "oidc_issuer" {
  description = "SSM parameter which contains the OIDC issuer URL"
  value       = aws_ssm_parameter.oidc_issuer.name
}
