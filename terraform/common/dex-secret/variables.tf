variable "clients" {
  type        = set(string)
  default     = []
  description = "List of static clients to configure with OAuth2 secrets"
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace in which secrets should be created"
}
