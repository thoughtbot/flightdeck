variable "name" {
  type        = string
  description = "Base name for this cluster"
}

variable "namespace" {
  type        = list(string)
  description = "Prefix to be applied to created resources"
  default     = []
}
