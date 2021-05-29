output "base" {
  description = "Base name for this cluster"
  value       = local.base
}

output "full" {
  description = "Full name for this cluster"
  value       = local.full
}

output "private_tags" {
  description = "Tags applied to private resources for this cluster"
  value       = local.private_tags
}

output "public_tags" {
  description = "Tags applied to public resources for this cluster"
  value       = local.public_tags
}

output "shared_tags" {
  description = "Shared tags for this cluster"
  value       = local.shared_tags
}
