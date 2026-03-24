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

variable "name" {
  type        = string
  description = "Name for this network"
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

variable "flow_logs_retention_days" {
  description = "Number of days to retain VPC Flow Logs in CloudWatch." # Only applies when enable_flow_logs is true.
  type        = number
  default     = null # null = retain forever
}