variable "name" {
  type        = string
  description = "Name for the role"
}

variable "namespace" {
  type        = list(string)
  description = "Prefix to be applied to created resources"
  default     = []
}

variable "oidc_issuer" {
  type        = string
  description = "OIDC issuer of the Kubernetes cluster"
}

variable "service_accounts" {
  type        = list(string)
  description = "Namespace and name of service accounts allowed to use this role"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to created resources"
  default     = {}
}

