variable "alertmanager_data_source_name" {
  description = "Name of the AlertManager data source"
  type        = string
  default     = null
}

variable "cloudwatch_data_source_name" {
  description = "Name of the CloudWatch data source"
  type        = string
  default     = null
}

variable "name" {
  description = "Namespace for data sources in this account"
  type        = string
}

variable "prometheus_data_source_name" {
  description = "Name of the Prometheus Grafana data source"
  type        = string
  default     = null
}

variable "prometheus_workspace_name" {
  description = "Name of the Prometheus workspace for Grafana data source"
  type        = string
  default     = null
}

variable "grafana_role_name" {
  description = "Name of the Grafana role"
  type        = string
  default     = "grafana"
}
