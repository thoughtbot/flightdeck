variable "cluster_roles" {
  description = "Names of cluster roles for this serviceaccount (default: admin)"
  type        = list(string)
  default     = ["admin"]
}

variable "group" {
  description = "Name of the Kubernetes group allowed to deploy"
  type        = string
}

variable "iam_role_arn" {
  description = "ARN of the IAM role used to deploy"
  type        = string
}

variable "name" {
  description = "Name of the Kubernetes service account (default: deploy)"
  type        = string
  default     = "deploy"
}

variable "namespace" {
  description = "Kubernetes namespace to which this tenant deploys"
  type        = string
}
