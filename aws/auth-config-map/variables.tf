variable "admin_roles" {
  type        = list(string)
  default     = []
  description = "Role ARNs which have admin privileges within the cluster"
}

variable "custom_roles" {
  type        = map(string)
  default     = {}
  description = "Role ARNs which have custom privileges within the cluster"
}

variable "node_roles" {
  type        = list(string)
  default     = []
  description = "Roles for EKS node groups in this cluster"
}
