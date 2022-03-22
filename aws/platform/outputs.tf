output "breakglass_role_arn" {
  description = "ARN for a breakglass role in case of cluster lockout"
  value       = module.auth_config_map.breakglass_role_arn
}
