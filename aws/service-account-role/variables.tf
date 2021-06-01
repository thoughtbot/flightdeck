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

variable "policy_arns" {
  type        = list(string)
  description = "Existing IAM policies to attach to the created role"
  default     = []
}

variable "policy_json" {
  type        = string
  description = "IAM policy to create for this role"
  default     = null
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

