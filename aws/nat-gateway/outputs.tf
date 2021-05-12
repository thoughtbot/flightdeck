output "instances" {
  description = "The created NAT gateways for each availability zone"
  value       = aws_nat_gateway.this
}
