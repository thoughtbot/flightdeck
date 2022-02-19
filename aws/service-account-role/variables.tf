variable "cluster_names" {
  type        = list(string)
  description = "Names of Kubernetes clusters (to look up OIDC issuers)"
  default     = []
}

variable "managed_policy_arns" {
  type        = list(string)
  description = "List of managed policy ARNs to attach to the role"
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

variable "policy_documents" {
  type        = list(string)
  description = "List of policy documents to add to the role's inline policy"
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

