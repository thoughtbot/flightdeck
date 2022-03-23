variable "cluster_names" {
  type        = list(string)
  description = "List of clusters that this ingress stack will forward to"
}

variable "network_tags" {
  description = "Additional tags for finding the AWS VPC and subnets"
  type        = map(string)
  default     = {}
}
