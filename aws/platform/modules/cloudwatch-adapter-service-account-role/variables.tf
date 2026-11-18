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

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace in which resources should be created"
}

variable "oidc_issuer" {
  type        = string
  description = "OIDC issuer of the Kubernetes cluster"
}
