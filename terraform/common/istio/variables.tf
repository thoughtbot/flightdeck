variable "base_chart_name" {
  description = "Name of the base chart to install"
  type        = string
  default     = "base"
}

variable "base_chart_values" {
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
  default     = "git+https://github.com/istio/istio@manifests/charts"
}

variable "discovery_chart_name" {
  description = "Name of the discovery chart to install"
  type        = string
  default     = "istio-discovery"
}

variable "discovery_chart_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace in which secrets should be created"
  default     = "istio-system"
}

variable "name" {
  type        = string
  description = "Name of this Helm release"
  default     = "istio"
}
