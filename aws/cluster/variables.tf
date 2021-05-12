variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = ["api", "audit"]
  description = "Which EKS control plane log types to enable"
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

variable "k8s_version" {
  type        = string
  description = "Kubernetes version to deploy"
}

variable "log_retention_in_days" {
  type        = number
  description = "How many days until control plane logs are purged"
  default     = 7
}

variable "name" {
  type        = string
  description = "Name for this EKS cluster"
}

variable "namespace" {
  type        = list(string)
  description = "Prefix to be applied to created resources"
  default     = []
}

variable "node_groups" {
  description = "Node groups to create in this cluster"

  type = map(object({
    instance_types = list(string),
    max_size       = number
    min_size       = number
  }))
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
