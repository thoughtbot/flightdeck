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

variable "name" {
  description = "Name for this Prometheus workspace"
  type        = string
}

variable "sns_receivers" {
  description = "Map of alert priorities to SNS topics for AlertManager"
  type        = map(string)
}

variable "tags" {
  description = "Tags to be applied to created resources"
  type        = map(string)
  default     = {}
}

variable "workload_account_ids" {
  description = "Workload accounts allowed to write to this workspace"
  type        = list(string)
  default     = []
}
