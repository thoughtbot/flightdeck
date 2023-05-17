variable "admin_principals" {
  description = "IAM principals allowed to manage underlying resources"
  type        = list(string)
  default     = []
}

variable "alert_group_by" {
  description = "Labels used to group similar alerts"
  type        = list(string)
  default     = null
}

variable "alert_resolve_timeout" {
  description = "Time after which alerts without an end time after resolved"
  type        = string
  default     = null
}

variable "alert_message_template" {
  description = "Template used for AlertManager messages"
  type        = string
  default     = null
}

variable "alert_subject_template" {
  description = "Template used for AlertManager alert subjects"
  type        = string
  default     = null
}

variable "alert_severities" {
  description = "List of alert priorities for AlertManager"
  type        = list(string)
  default     = ["warning", "ticket", "page"]
}

variable "alert_default_severity" {
  description = "Default severity for alerts"
  type        = string
  default     = "warning"
}

variable "prometheus_workspace_name" {
  description = "Name of the AWS Managed Prometheus workspace"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to created resources"
  type        = map(string)
  default     = {}
}
