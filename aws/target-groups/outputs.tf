output "by_cluster" {
  description = "Target group definition for each cluster"
  value       = local.target_groups
}

output "subnet_ids" {
  description = "Subnets in which target groups should be created"
  value       = module.network.public_subnet_ids
}

output "vpc_id" {
  description = "VPC in which target groups should be created"
  value       = module.network.vpc.id
}
