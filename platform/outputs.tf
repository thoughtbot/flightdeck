output "flightdeck_namespace" {
  description = "Kubernetes namespace created for Flightdeck"
  value       = kubernetes_namespace.flightdeck.metadata[0].name
}

output "istio_ingress" {
  description = "Helm release ID for istio-ingress"
  value       = module.istio_ingress.id
}
