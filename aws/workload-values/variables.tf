variable "aws_tags" {
  type        = map(string)
  description = "Tags to be applied to created AWS resources"
  default     = {}
}

variable "cluster_full_name" {
  type        = string
  description = "Full name of the EKS cluster"
}

variable "domain_filters" {
  type        = list(string)
  default     = []
  description = "Domains on which External DNS should update entries"
}

variable "k8s_namespace" {
  type        = string
  default     = "flightdeck"
  description = "Kubernetes namespace in which resources should be created"
}
