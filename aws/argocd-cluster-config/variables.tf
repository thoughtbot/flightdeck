variable "argocd_service_account_role_arn" {
  type        = string
  description = "ARN of the IAM role used for ArgoCD's service account"
}

variable "aws_tags" {
  type        = map(string)
  description = "Tags to be applied to created AWS resources"
  default     = {}
}

variable "cluster_full_name" {
  type        = string
  description = "Full name of the EKS cluster"
}
