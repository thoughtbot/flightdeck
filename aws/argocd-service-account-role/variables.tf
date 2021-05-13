variable "aws_namespace" {
  type        = list(string)
  default     = []
  description = "Prefix to be applied to created AWS resources"
}

variable "aws_tags" {
  type        = map(string)
  description = "Tags to be applied to created AWS resources"
  default     = {}
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

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace in which resources should be created"
}

variable "oidc_issuer" {
  type        = string
  description = "OIDC issuer of the operations Kubernetes cluster"
}
