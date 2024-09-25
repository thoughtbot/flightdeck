variable "capacity_type" {
  type        = string
  default     = "ON_DEMAND"
  description = "Allow values: ON_DEMAND (default), SPOT"
}

variable "cluster" {
  type        = object({ name = string })
  description = "Cluster which this node group should join"
}

variable "instance_types" {
  type        = list(string)
  description = "EC2 instance types allowed in this node group"
  default     = ["t3.medium"]
}

variable "max_size" {
  type        = number
  description = "Maximum number of nodes in this group"
}

variable "min_size" {
  type        = number
  description = "Minimum number of nodes in this group"
}

variable "name" {
  type        = string
  description = "Name for this EKS node group"
}

variable "namespace" {
  type        = list(string)
  description = "Prefix to be applied to created resources"
  default     = []
}

variable "role" {
  type        = object({ arn = string })
  description = "IAM role nodes in this group will assume"
}

variable "subnets" {
  type        = list(object({ id = string, availability_zone = string }))
  description = "Subnets in which the node group should run"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to created resources"
  default     = {}
}

variable "labels" {
  type        = map(string)
  description = "Labels to be applied to created resources"
  default     = {}
}

variable "label_node_role" {
  type        = string
  description = "Role to struct kubernetes scheduler to use for this node group"
  default     = "general"
}

variable "max_unavailable" {
  type        = number
  description = "Maximum number of nodes that can be unavailable during a rolling update"
  default     = 1
}

variable "user_data" {
  type        = string
  description = "Optional user data script for the launch template"
  default     = null # Default to an empty string if no user data is provided
}
