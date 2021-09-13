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

variable "certificate_issuer" {
  type        = string
  description = "YAML spec for certificate issuer; defaults to self-signed"
  default     = null
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

variable "domain_names" {
  type        = list(string)
  default     = []
  description = "Domains which are allowed in this cluster"
}

variable "external_dns_enabled" {
  description = "Set to false to disable External DNS"
  type        = bool
  default     = true
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

variable "fluent_bit_enable_kubernetes_annotations" {
  description = "Set to true to add Kubernetes annotations to log output"
  type        = bool
  default     = false
}

variable "fluent_bit_enable_kubernetes_labels" {
  description = "Set to true to add Kubernetes labels to log output"
  type        = bool
  default     = false
}

variable "fluent_bit_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "fluent_bit_version" {
  type        = string
  description = "Version of Fluent Bit to install"
  default     = "0.15.1"
}

variable "istio_discovery_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
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

variable "pagerduty_routing_key" {
  type        = string
  description = "Routing key for delivering Pagerduty alerts"
  default     = null
}

variable "prometheus_adapter_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "prometheus_adapter_version" {
  type        = string
  description = "Version of prometheus adapter to install"
  default     = "2.17.0"
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

variable "secret_store_driver_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "secret_store_driver_version" {
  type        = string
  description = "Version of the secret store driver to install"
  default     = "0.3.0"
}
