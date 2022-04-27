output "prometheus_data" {
  description = "Prometheus datasource object for the provided workspace"
  sensitive   = true
  value       = local.prometheus_data
}
