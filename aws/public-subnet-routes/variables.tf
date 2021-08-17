variable "enable_ipv6" {
  type        = bool
  default     = false
  description = "Set to false to disable IPV6"
}

variable "name" {
  description = "Name for this network"
  type        = string
}

variable "namespace" {
  type        = list(string)
  default     = []
  description = "Prefix to be applied to created resources"
}

variable "subnets" {
  description = "Subnets for which public routes should be created"
  type        = map(object({ id = string }))
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to created resources"
  default     = {}
}

variable "vpc" {
  type        = object({ id = string })
  description = "AWS VPC in which subnets should be created"
}
