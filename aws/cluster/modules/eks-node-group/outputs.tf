output "instances" {
  description = "The created node groups"
  value       = aws_eks_node_group.this
}
