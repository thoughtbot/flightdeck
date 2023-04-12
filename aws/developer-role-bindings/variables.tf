variable "enable_exec" {
  description = "Set to true to allow running exec on pods"
  type        = bool
  default     = false
}

variable "group" {
  description = "Name of the Kubernetes group used by developers"
  type        = string
}

variable "name" {
  description = "Name of the Kubernetes service account (default: developer)"
  type        = string
  default     = "developer"
}

variable "namespace" {
  description = "Kubernetes namespace to which developers will have access"
  type        = string
}
