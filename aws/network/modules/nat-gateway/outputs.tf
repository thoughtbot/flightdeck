output "instances" {
  description = "The created NAT gateways for each availability zone"
  value       = aws_nat_gateway.this
}

output "ip_addresses" {
  description = "IP addresses created for NAT gateways"
  value       = values(aws_nat_gateway.this)[*].public_ip
}
