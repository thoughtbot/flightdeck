variable "name" {
  type        = string
  description = "Name for this EKS cluster"
}

variable "namespace" {
  type        = list(string)
  description = "Prefix to be applied to created resources"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to all created resources"
  default     = {}
}
