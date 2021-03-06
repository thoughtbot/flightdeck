variable "cluster_names" {
  type        = list(string)
  default     = []
  description = "List of clusters which run in this network"
}

variable "create_internet_gateway" {
  description = "Set to false to disable creation of an internet gateway"
  type        = bool
  default     = true
}

variable "create_nat_gateways" {
  description = "Set to false to disable creation of NAT gateways"
  type        = bool
  default     = true
}

variable "create_vpc" {
  description = "Set to false to disable creation of the VPC"
  type        = bool
  default     = true
}

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

variable "enable_public_ip_on_launch" {
  type        = bool
  default     = false
  description = "Set to true to auto-assign IP addresses in public subnets"
}

variable "name" {
  type        = string
  description = "Name for this network"
}

variable "namespace" {
  type        = list(string)
  description = "Prefix to be applied to created resources"
  default     = []
}

variable "nat_availability_zones" {
  type        = list(string)
  description = "Availability zones in which NAT should be provided"
}

variable "private_subnet_cidr_blocks" {
  type        = map(string)
  description = "CIDR block for each availability zone"
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Tags to be applied to private subnets"
  default     = {}
}

variable "public_subnet_cidr_blocks" {
  type        = map(string)
  description = "CIDR block for each availability zone"
}

variable "public_subnet_tags" {
  type        = map(string)
  description = "Tags to be applied to public subnets"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to all created resources"
  default     = {}
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block to be used for the VPC, such as 10.0.0.0/16"
}

variable "vpc_tags" {
  type        = map(string)
  description = "Tags to be applied to the VPC"
  default     = {}
}
