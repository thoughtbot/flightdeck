variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = ["api", "audit"]
  description = "Which EKS control plane log types to enable"
}

variable "endpoint_private_access" {
  type        = bool
  description = "Enables the Amazon EKS private API server endpoint."
  default     = false
}

variable "endpoint_public_access" {
  type        = bool
  description = "Enables the Amazon EKS public API server endpoint."
  default     = true
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

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets which should be used by this cluster"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets which should be used by this cluster"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to created resources"
  default     = {}
}

variable "k8s_version" {
  type        = string
  description = "Kubernetes version to deploy"
}

variable "vpc" {
  type        = object({ id = string })
  description = "VPC in which this cluster should run"
}
