variable "chart_name" {
  description = "Name of the base chart to install"
  type        = string
  default     = "istio-ingress"
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
  default     = "git+https://github.com/istio/istio@manifests/charts/gateways"
}

variable "istio_namespace" {
  type        = string
  description = "Kubernetes namespace in which Istio is installed"
  default     = "istio-system"
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
