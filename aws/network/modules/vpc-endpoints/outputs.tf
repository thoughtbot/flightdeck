output "endpoint_id" {
  description = "ID of the S3 Gateway VPC endpoint"
  value       = aws_vpc_endpoint.s3.id
}

output "prefix_list_id" {
  description = "Prefix list ID of the S3 endpoint (useful for security group egress rules)"
  value       = aws_vpc_endpoint.s3.prefix_list_id
}