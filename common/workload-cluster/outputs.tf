output "flightdeck_namespace" {
  description = "Kubernetes namespace created for Flightdeck"
  value       = kubernetes_namespace.flightdeck.metadata[0].name
}
