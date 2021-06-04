output "name" {
  description = "Name of the created namespace"
  value       = kubernetes_namespace.this.metadata[0].name
}
