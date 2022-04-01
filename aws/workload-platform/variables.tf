variable "admin_roles" {
  type        = list(string)
  description = "Additional IAM roles which have admin cluster privileges"
  default     = []
}

variable "aws_load_balancer_controller_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "aws_load_balancer_controller_version" {
  type        = string
  description = "Version of aws-load-balancer-controller to install"
  default     = null
}

variable "aws_namespace" {
  type        = list(string)
  default     = []
  description = "Prefix to be applied to created AWS resources"
}

variable "aws_prometheus_workspace_id" {
  description = "Id for the prometheus workspace created in AWS. This variable is mandatory if the Prometheus workspace for centralized ingestion is in a different region"
  type        = string
  default     = ""
}

variable "aws_tags" {
  type        = map(string)
  description = "Tags to be applied to created AWS resources"
  default     = {}
}

variable "cert_manager_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
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

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "custom_roles" {
  type        = map(string)
  description = "Additional IAM roles which have custom cluster privileges"
  default     = {}
}

variable "domain_names" {
  type        = list(string)
  default     = []
  description = "Domains which are allowed in this cluster"
}

variable "external_dns_enabled" {
  description = "Set to true to enable External DNS"
  type        = bool
  default     = false
}

variable "external_dns_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
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

variable "hosted_zones" {
  type        = list(string)
  description = "Hosted zones this cluster is allowed to update"
  default     = []
}

variable "k8s_namespace" {
  type        = string
  default     = "flightdeck"
  description = "Kubernetes namespace in which resources should be created"
}

variable "logs_retention_in_days" {
  type        = number
  default     = 30
  description = "Number of days for which logs should be retained"
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

variable "node_roles" {
  type        = list(string)
  description = "Additional node roles which can join the cluster"
  default     = []
}

variable "pagerduty_parameter" {
  type        = string
  description = "SSM parameter containing the Pagerduty routing key"
  default     = null
}

variable "prometheus_adapter_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "prometheus_operator_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "monitoring_account_id" {
  description = "ID of the account in which monitoring resources are found"
  type        = string
  default     = null
}

variable "prometheus_workspace_name" {
  description = "Name of the Prometheus workspace for centralized ingestion"
  type        = string
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

variable "secret_store_provider_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "vertical_pod_autoscaler_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "workspace_region" {
  description = "Region of the Prometheus workspace for centralized ingestion. This variable is mandatory if the Prometheus workspace for centralized ingestion is in a different region"
  type        = string
  default     = "us-east-1"
}
