variable "argocd_github_repositories" {
  type        = list(string)
  description = "GitHub repositories to connect to ArgoCD"
  default     = []
}

variable "argocd_policy" {
  type        = string
  description = "Policy grants for ArgoCD RBAC"
  default     = ""
}

variable "argocd_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
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

variable "cert_manager_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "certificate_email" {
  type        = string
  description = "Email to be notified of certificate expiration and renewal"
}

variable "cluster_configs" {
  default     = []
  description = "ArgoCD configuration objects for workload clusters"

  type = list(object({
    name   = string
    server = string
    config = object({
      awsAuthConfig = object({
        clusterName = string
        roleARN     = string
      })
      tlsClientConfig = object({
        caData = string
      })
    })
  }))
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "domain_filters" {
  type        = list(string)
  default     = []
  description = "Domains on which External DNS should update entries"
}

variable "dex_extra_secrets" {
  type        = map(string)
  default     = {}
  description = "Extra values to append to the Dex secret"
}

variable "dex_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "external_dns_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "host" {
  type        = string
  description = "Base hostname for flightdeck UI"
}

variable "k8s_namespace" {
  type        = string
  default     = "flightdeck"
  description = "Kubernetes namespace in which resources should be created"
}
