variable "name" {
  description = "Name of the addon to authorize"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace in which the secret should be written"
  type        = string
}

variable "roles" {
  description = "IAM roles capable of using this addon"
  type        = list(object({ name = string }))
}
