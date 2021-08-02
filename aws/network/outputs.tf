output "cluster_names" {
  description = "List of clusters which run in this network"
  value       = var.cluster_names
}

output "vpc_id" {
  description = "ID of the AWS VPC"
  value       = module.vpc.id
}
