variable "alarm_topic_name" {
  type        = string
  description = "Name of the SNS topic to which alarms should be sent"
  default     = null
}

variable "private_tags" {
  description = "Tags to identify private subnets"
  type        = map(string)
  default     = { "kubernetes.io/role/internal-elb" = "1" }
}

variable "public_tags" {
  description = "Tags to identify public subnets"
  type        = map(string)
  default     = { "kubernetes.io/role/elb" = "1" }
}

variable "tags" {
  description = "Tags to identify all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Tags to identify the VPC"
  type        = map(string)
  default     = {}
}
