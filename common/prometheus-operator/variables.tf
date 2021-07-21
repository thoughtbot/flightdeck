variable "chart_name" {
  type        = string
  description = "Helm chart to install"
  default     = "kube-prometheus-stack"
}

variable "chart_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "chart_version" {
  type        = string
  description = "Version of chart to install"
}

variable "chart_repository" {
  type        = string
  description = "Helm repository containing the chart"
  default     = "https://prometheus-community.github.io/helm-charts"
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace in which resources will be written"
}

variable "name" {
  type        = string
  description = "Name for the service account role"
  default     = "kube-prometheus-stack"
}

variable "pagerduty_routing_key" {
  type        = string
  description = "Routing key for delivering Pagerduty alerts"
  default     = null
}
