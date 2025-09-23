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

variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = []
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
    capacity_type   = optional(string, "ON_DEMAND")
    instance_types  = list(string),
    enforce_imdsv2  = optional(bool, false)
    max_size        = number
    max_unavailable = optional(number, 3)
    min_size        = number
    taints = optional(list(object({
      key    = string
      value  = optional(string)
      effect = string
    })), [])
    node_group_labels = optional(map(string), {})
  }))
}

variable "prevent_log_group_destroy" {
  type        = bool
  default     = false
  description = "When true, the CloudWatch log group will be protected from deletion. Terraform will fail if a destroy is attempted on this resource."
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to all created resources"
  default     = {}
}

variable "labels" {
  type        = map(string)
  description = "Labels to be applied to created resources"
  default     = {}
}
