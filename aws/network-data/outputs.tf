output "alarm_actions" {
  description = "AWS actions invoked on alarms in this network"
  value       = [data.aws_sns_topic.alarms]
}

output "cluster_names" {
  description = "List of clusters which run in this network"
  value       = local.cluster_names
}

output "cidr_blocks" {
  description = "CIDR blocks allowed in this network"
  value       = [data.aws_vpc.this.cidr_block]
}

output "private_subnets" {
  description = "Private subnets for this network"
  value       = local.private_subnets
}

output "public_subnets" {
  description = "Private subnets for this network"
  value       = local.public_subnets
}

output "vpc" {
  description = "AWS VPC for this network"
  value       = data.aws_vpc.this
}
