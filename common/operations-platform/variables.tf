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

variable "cluster_autoscaler_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "cluster_autoscaler_version" {
  type        = string
  description = "Version of cluster-autoscaler to install"
  default     = "9.7.0"
}

variable "certificate_email" {
  type        = string
  description = "Email to be notified of certificate expiration and renewal"
}

variable "certificate_solvers" {
  type        = string
  description = "YAML spec for solving ACME challenges"
}

variable "dex_extra_secrets" {
  type        = map(string)
  default     = {}
  description = "Extra values to append to the Dex secret"
}

variable "dex_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
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

variable "host" {
  type        = string
  description = "Base hostname for flightdeck UI"
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
  default     = "1.10.0"
}

variable "prometheus_adapter_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "prometheus_adapter_version" {
  type        = string
  description = "Version of external-dns to install"
  default     = "2.14.1"
}

variable "prometheus_operator_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "prometheus_operator_version" {
  type        = string
  description = "Version of external-dns to install"
  default     = "16.0.1"
}

variable "ui_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}
