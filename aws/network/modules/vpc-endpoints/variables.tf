variable "name" {
  type        = string
  description = "Name for this network (used in the endpoint's Name tag)"
}

variable "namespace" {
  type        = list(string)
  description = "Prefix to be applied to created resources"
  default     = []
}

variable "vpc" {
  description = "The VPC object in which to create the S3 endpoint"
  type = object({
    id = string
  })
}

variable "route_table_ids" {
  type        = list(string)
  description = "List of route table IDs to associate with the S3 Gateway endpoint"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to the endpoint"
  default     = {}
}