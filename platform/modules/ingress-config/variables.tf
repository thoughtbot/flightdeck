variable "domain_names" {
  type        = list(string)
  default     = []
  description = "Domains which are allowed in this cluster"
}

variable "issuer" {
  type        = string
  description = "YAML spec for the cert-manager issuer"
  default     = null
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace in which secrets should be created"
}
