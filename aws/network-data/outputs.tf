output "cluster_names" {
  description = "List of clusters which run in this network"
  value       = local.cluster_names
}

output "cidr_blocks" {
  description = "CIDR blocks allowed in this network"
  value       = [data.aws_vpc.this.cidr_block]
}

output "private_subnet_ids" {
  description = "Private subnets for this network"
  value       = data.aws_subnets.private.ids
}

output "public_subnet_ids" {
  description = "Private subnets for this network"
  value       = data.aws_subnets.public.ids
}

output "vpc" {
  description = "AWS VPC for this network"
  value       = data.aws_vpc.this
}
