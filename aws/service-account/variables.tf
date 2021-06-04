variable "cluster_name" {
  type        = string
  description = "Full name of the cluster for this service account"
}

variable "name" {
  type        = string
  description = "Name for this service account"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace for this service account"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to all created resources"
  default     = {}
}
