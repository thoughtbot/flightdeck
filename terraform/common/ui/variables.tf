variable "chart_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace in which secrets should be created"
}

variable "name" {
  description = "Name for the Helm release"
  type        = string
  default     = "flightdeck-ui"
}
