output "namespace" {
  description = "Kubernetes namespace created for Flightdeck"
  value       = kubernetes_namespace.flightdeck.metadata[0].name
}

output "url" {
  description = "URL at which Flightdeck is reachable"
  value       = "https://${var.host}"
}
