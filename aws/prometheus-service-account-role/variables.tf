variable "aws_namespace" {
  type        = list(string)
  default     = []
  description = "Prefix to be applied to created AWS resources"
}

variable "aws_tags" {
  type        = map(string)
  description = "Tags to be applied to created AWS resources"
  default     = {}
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace in which resources should be created"
}

variable "oidc_issuer" {
  type        = string
  description = "OIDC issuer of the operations Kubernetes cluster"
}

variable "role_name" {
  type        = string
  description = "Name for the IAM role"
  default     = "prometheus"
}

variable "service_account_name" {
  type        = string
  description = "Name for the Prometheus service account"
  default     = "federated-prometheus"
}

variable "workspace_account_id" {
  type        = string
  description = "ID of the account in which the Prometheus workspace is found"
}

variable "workspace_name" {
  type        = string
  description = "Name of the Prometheus workspace"
}
