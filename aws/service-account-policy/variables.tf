variable "name" {
  description = "Name for the IAM policy"
  type        = string
}

variable "policy_documents" {
  description = "JSON policies to add to the generated policy"
  type        = list(string)
}

variable "role_names" {
  description = "Roles to which this policy will be attached"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to be applied to created resources"
  type        = map(string)
  default     = {}
}
