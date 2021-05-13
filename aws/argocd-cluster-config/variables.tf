variable "argocd_service_account_role_arn" {
  type        = string
  description = "ARN of the IAM role used for ArgoCD's service account"
}

variable "aws_namespace" {
  type        = list(string)
  default     = ["flightdeck"]
  description = "Prefix to be applied to created AWS resources"
}

variable "aws_tags" {
  type        = map(string)
  description = "Tags to be applied to created AWS resources"
  default     = {}
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}
