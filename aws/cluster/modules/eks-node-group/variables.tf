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
variable "taints" {
  type = list(object({
    key    = string
    value  = optional(string)
    effect = string
  }))
  description = <<-EOT
    List of `key`, `value`, `effect` objects representing Kubernetes taints.
    `effect` must be one of `NO_SCHEDULE`, `NO_EXECUTE`, or `PREFER_NO_SCHEDULE`.
    `key` and `effect` are required, `value` may be null.
    EOT
  default     = []
  nullable    = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to created resources"
  default     = {}
}
