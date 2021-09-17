variable "chart_values" {
  type        = list(string)
  description = "Overrides for the Helm chart"
  default     = []
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace in which the release should be created"
}

variable "name" {
  description = "Name for the Helm release"
  type        = string
}
