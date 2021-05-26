output "allowed_cidr_blocks" {
  description = "CIDR blocks allowed in this cluster"
  value       = [data.aws_vpc.cluster.cidr_block]
}

output "ca_certificate" {
  description = "Certificate authority for this cluster"
  value       = base64decode(local.cluster.certificate_authority[0].data)
}

output "host" {
  description = "Host for this cluster's API endpoint"
  value       = local.cluster.endpoint
}

output "private_subnets" {
  description = "Private subnets for this cluster's VPC"
  value       = data.aws_subnet.private
}

output "token" {
  description = "Token to authenticate to this cluster"
  value       = data.aws_eks_cluster_auth.token.token
}

output "vpc" {
  description = "AWS VPC for this cluster"
  value       = data.aws_vpc.cluster
}
