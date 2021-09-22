variable "cluster_names" {
  type        = list(string)
  description = "Names of Kubernetes clusters (to look up OIDC issuers)"
  default     = []
}

variable "name" {
  type        = string
  description = "Name for the role"
}

variable "namespace" {
  type        = list(string)
  description = "Prefix to be applied to created resources"
  default     = []
}

variable "oidc_issuers" {
  type        = list(string)
  description = "OIDC issuers for Kubernetes clusters"
  default     = []
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

