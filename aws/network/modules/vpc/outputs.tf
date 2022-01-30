output "id" {
  value       = aws_vpc.this.id
  description = "ID of this AWS VPC"
}

output "instance" {
  value       = aws_vpc.this
  description = "AWS VPC created for the network"
}
