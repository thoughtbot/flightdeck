variable "chart_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace in which resources will be written"
  default     = "kube-system"
}

variable "name" {
  type        = string
  description = "Name for the Helm release"
  default     = "csi-secrets-store-provider-aws"
}
