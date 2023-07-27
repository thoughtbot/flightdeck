variable "admin_principals" {
  description = "IAM principals allowed to manage this topic (defaults to current account)"
  type        = list(string)
  default     = []
}

variable "enable_kms" {
  description = "Set to false to disable encryption with KMS"
  type        = bool
  default     = true
}

variable "sns_topic_names" {
  description = "Names of SNS topics for alarms"
  type        = list(string)
}

variable "kms_alias_name" {
  description = "KMS alias name for SNS topics"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to created resources"
  type        = map(string)
  default     = {}
}
