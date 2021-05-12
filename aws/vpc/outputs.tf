output "instance" {
  value       = aws_vpc.this
  description = "AWS VPC created for the network"
}

output "default_security_group" {
  value       = data.aws_security_group.default
  description = "Security group which allows ingress and egress within the VPC"
}
