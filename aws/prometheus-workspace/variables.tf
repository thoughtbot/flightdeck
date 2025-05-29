variable "name" {
  description = "Name for this Prometheus workspace"
  type        = string
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

variable "logging_configuration" {
  type    = object({ log_group_arn = string })
  default = null
}