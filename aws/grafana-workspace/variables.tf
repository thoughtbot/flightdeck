variable "admin_groups" {
  description = "IAM Identity Center groups with administrator access to Grafana"
  type        = list(string)
  default     = []
}

variable "authentication_providers" {
  description = "Providers used to sign in to Grafana"
  type        = list(string)
  default     = ["AWS_SSO"]
}

variable "editor_groups" {
  description = "IAM Identity Center groups with edit access to Grafana"
  type        = list(string)
  default     = []
}

variable "grafana_api_key_name" {
  description = "Name for the Grafana API key used by Terraform"
  type        = string
  default     = "terraform"
}

variable "name" {
  description = "Name of this Grafana workspace"
  type        = string
  default     = "Grafana"
}

variable "iam_role_name" {
  description = "Override the name of the service role for Grafana"
  type        = string
  default     = null
}

variable "workload_account_ids" {
  description = "AWS account IDs for Prometheus and CloudWatch resources"
  type        = list(string)
  default     = null
}

variable "viewer_groups" {
  description = "IAM Identity Center groups with view access to Grafana"
  type        = list(string)
  default     = []
}
