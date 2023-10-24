variable "force_destroy" {
  type        = bool
  default     = false
  description = "A boolean that indicates that all recovery points stored in the vault are deleted so that the vault can be destroyed without error."
}

variable "admin_principals" {
  description = "Principals allowed to peform admin actions (default: current account)"
  type        = list(string)
  default     = null
}

variable "vault_name" {
  type        = string
  description = "Unique name for the backup vault"
  default     = "aws_backup_vault"
}

