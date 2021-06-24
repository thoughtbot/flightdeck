variable "certificate_email" {
  type        = string
  description = "Email to be notified of certificate expiration and renewal"
}

variable "certificate_solvers" {
  type        = string
  description = "YAML spec for solving ACME challenges"
}

variable "domain_names" {
  type        = list(string)
  default     = []
  description = "Domains which are allowed in this cluster"
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace in which secrets should be created"
}

variable "name" {
  description = "Name for the Helm release"
  type        = string
  default     = "ingress-config"
}
