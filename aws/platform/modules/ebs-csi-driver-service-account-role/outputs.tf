output "arn" {
  description = "The ARN of the created role"
  value       = module.ebs_csi_driver_service_account_role.instance.arn
}
