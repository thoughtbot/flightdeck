output "instance" {
  description = "The created EKS cluster"
  value       = aws_eks_cluster.this
}
