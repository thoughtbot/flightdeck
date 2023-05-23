variable "grafana_workspace_name" {
  description = "Name of the AWS Managed Grafana workspace allowed to assume this role"
  type        = string
  default     = "Grafana"
}

variable "monitoring_account_ids" {
  description = "AWS account IDs in which Grafana will run"
  type        = list(string)
  default     = null
}

variable "name" {
  description = "Name of the IAM role for Grafana"
  type        = string
  default     = "grafana"
}

variable "tags" {
  description = "Tags to be applied to created resources"
  type        = map(string)
  default     = {}
}