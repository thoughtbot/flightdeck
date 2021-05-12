variable "enable_flow_logs" {
  type        = bool
  default     = false
  description = "Set to true to enable VPC flow logs"
}

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

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to created resources"
  default     = {}
}

variable "cidr_block" {
  type        = string
  description = "CIDR block to be used for the VPC, such as 10.0.0.0/16"
}
