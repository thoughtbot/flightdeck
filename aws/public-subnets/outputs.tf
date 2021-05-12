output "instances" {
  value       = aws_subnet.this
  description = "AWS VPC subnet created for each availability zone"
}

output "ids" {
  value = zipmap(
    keys(aws_subnet.this),
    values(aws_subnet.this).*.id
  )
  description = "IDs for the subnet created for each availability zone"
}

output "route_table" {
  value       = aws_route_table.this
  description = "Route table for public subnets"
}
