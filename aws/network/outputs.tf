output "cluster_names" {
  description = "List of clusters which run in this network"
  value       = var.cluster_names
}

output "nat_ip_addresses" {
  description = "List of IP addresses created for NAT gateways"
  value       = flatten(module.nat_gateway[*].ip_addresses)
}

output "vpc_id" {
  description = "ID of the AWS VPC"
  value       = local.vpc.id
}

output "s3_endpoint_id" {
  description = "ID of the S3 Gateway VPC endpoint (null if disabled)"
  value       = try(module.s3_endpoint[0].endpoint_id, null)
}