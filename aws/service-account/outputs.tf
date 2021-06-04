output "role" {
  description = "The IAM role created for this service account"
  value       = module.role.instance
}
