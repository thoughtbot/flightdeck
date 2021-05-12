variable "enable_ipv6" {
  type        = bool
  default     = false
  description = "Set to false to disable IPV6"
}

variable "namespace" {
  type        = list(string)
  default     = []
  description = "Prefix to be applied to created resources"
}

variable "cidr_blocks" {
  type        = map(string)
  description = "CIDR block for each availability zone"
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
