variable "cert_manager_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install"
  default     = null
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
  default     = null
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
  default     = null
}

variable "flightdeck_namespace" {
  type        = string
  default     = "flightdeck"
  description = "Kubernetes namespace in which flightdeck should be installed"
}

variable "federated_prometheus_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "flightdeck_prometheus_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
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
  default     = null
}

variable "istio_base_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "istiod_values" {
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
  default     = null
}

variable "metrics_server_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "metrics_server_version" {
  type        = string
  description = "Version of the Metrics Server to install"
  default     = null
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
  default     = null
}

variable "prometheus_operator_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "prometheus_operator_version" {
  type        = string
  description = "Version of external-dns to install"
  default     = null
}

variable "reloader_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "reloader_version" {
  type        = string
  description = "Version of external-dns to install"
  default     = null
}

variable "secret_store_driver_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "secret_store_driver_version" {
  type        = string
  description = "Version of the secret store driver to install"
  default     = null
}

variable "vertical_pod_autoscaler_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}
