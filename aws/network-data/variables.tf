variable "private_tags" {
  description = "Tags to identify private subnets"
  type        = map(string)
}

variable "public_tags" {
  description = "Tags to identify public subnets"
  type        = map(string)
}

variable "network_tags" {
  description = "Tags to identify this network"
  type        = map(string)
}
