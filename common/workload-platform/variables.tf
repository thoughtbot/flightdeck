variable "cert_manager_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install"
  default     = "v1.3.1"
}

variable "external_dns_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "external_dns_version" {
  type        = string
  description = "Version of external-dns to install"
  default     = "5.0.0"
}

variable "flightdeck_namespace" {
  type        = string
  default     = "flightdeck"
  description = "Kubernetes namespace in which flightdeck should be installed"
}

variable "istio_ingress_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "istio_namespace" {
  type        = string
  default     = "istio-system"
  description = "Kubernetes namespace in which istio should be installed"
}

variable "istio_version" {
  type        = string
  description = "Version of Istio to install"
  default     = "1.9.4"
}
