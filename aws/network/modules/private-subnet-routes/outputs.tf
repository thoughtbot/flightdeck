output "route_tables" {
  description = "Map of per-AZ NAT route tables for private subnets"
  value       = aws_route_table.nat
}

output "route_table_ids" {
  description = "List of route table IDs for private subnets"
  value       = [for rt in aws_route_table.nat : rt.id]
}