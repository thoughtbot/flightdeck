variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = ["api", "audit"]
  description = "Which EKS control plane log types to enable"
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

variable "auth_mode" {
  type        = string
  description = "Authentiation mode associated with the cluster Access config"
  default     = "API_AND_CONFIG_MAP"
}

variable "bootstrap_cluster_creator_admin_permission" {
  type        = bool
  description = "Bootstrap access config values to the cluster"
  default     = false
}
