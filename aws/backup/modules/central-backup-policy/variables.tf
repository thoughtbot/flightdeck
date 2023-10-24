variable "backup_cron_schedule" {
  type        = string
  description = "Cron schedule for backup plan"
}

variable "backup_delete_after" {
  type        = number
  description = "Specifies the number of days after creation that a recovery point is deleted. Must be 90 days greater than cold_storage_after"
  default     = 270
}

variable "backup_selection_role_name" {
  type        = string
  description = "Unique name for the backup policy"
  default     = "backup-selection-role"
}

variable "backup_selection_tags" {
  type        = map(list(string))
  description = "Specifies the tags that identify the resources to be backed up"
}

variable "cold_storage_after" {
  type        = number
  description = "Specifies the number of days after creation that a recovery point is moved to cold storage"
  default     = 90
}

variable "completion_window" {
  type        = number
  default     = 360
  description = "The amount of time in minutes AWS Backup attempts a backup before canceling the job and returning an error."
}

variable "name" {
  type        = string
  description = "Unique name for the backup policy"
}

variable "secondary_vault_region" {
  type        = string
  description = "The secondary AWS region to store copies of backup from the target region"
}

variable "start_window_minutes" {
  type        = number
  description = "Specifies the number of minutes to wait before canceling a job that does not start successfully"
  default     = 60
}

variable "target_resource_region" {
  type        = string
  description = "The AWS target region for this policy to scan for resources"
}

variable "vault_name" {
  type        = string
  description = "Unique name for the backup vault"
  default     = "aws_backup_vault"
}
