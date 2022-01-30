output "instances" {
  value       = aws_subnet.this
  description = "AWS VPC private subnet created for each availability zone"
}

output "ids" {
  value = zipmap(
    keys(aws_subnet.this),
    values(aws_subnet.this).*.id
  )
  description = "IDs for the private subnet created for each availability zone"
}
