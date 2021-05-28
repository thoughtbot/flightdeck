variable "chart_path" {
  description = "Path at which istio charts can be found"
  type        = string
}

variable "chart_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "istio_namespace" {
  type        = string
  description = "Kubernetes namespace in which Istio is installed"
  default     = "istio-system"
}

variable "istio_version" {
  type        = string
  description = "Version of Istio to be installed"
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace in which the gateway should be installed"
  default     = "istio-system"
}

variable "name" {
  type        = string
  description = "Name of this Helm release"
  default     = "istio-ingressgateway"
}
