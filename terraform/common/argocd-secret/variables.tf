variable "extra_secrets" {
  type        = map(string)
  default     = {}
  description = "Extra values to append to the ArgoCD secret"
}

variable "github_repositories" {
  type        = map(object({ name = string, branch = string }))
  description = "GitHub repositories to connect to ArgoCD"
  default     = {}
}

variable "host" {
  type        = string
  description = "Hostname for ArgoCD"
}

variable "install_to_github" {
  type        = bool
  default     = true
  description = "Set to false if Terraform won't have GitHub write permission"
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace in which secrets should be created"
}
