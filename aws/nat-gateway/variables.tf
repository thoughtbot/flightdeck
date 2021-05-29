variable "availability_zones" {
  type        = list(string)
  description = "Availability zones in which NAT should be provided"
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

variable "public_subnets" {
  type        = map(object({ id = string, availability_zone = string }))
  description = "Public subnets for each availability_zone"
}

variable "private_subnets" {
  type        = map(object({ id = string, availability_zone = string }))
  description = "Private subnets for each availability_zone"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to all created resources"
  default     = {}
}

variable "vpc" {
  type        = object({ id = string, cidr_block = string })
  description = "AWS VPC for NAT gateways"
}
