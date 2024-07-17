variable "aws_namespace" {
  type        = list(string)
  description = "Prefix to be applied to created resources"
  default     = []
}

variable "aws_tags" {
  type        = map(string)
  description = "Tags to be applied to created resources"
  default     = {}
}

variable "chart_name" {
  type        = string
  description = "Helm chart to install"
  default     = null
}

variable "chart_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "chart_version" {
  type        = string
  description = "Version of chart to install"
  default     = null
}

variable "chart_repository" {
  type        = string
  description = "Helm repository containing the chart"
  default     = null
}

variable "cluster_full_name" {
  type        = string
  description = "Full name of the cluster in which the chart is installed"
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace in which resources will be written"
  default     = "default"
}

variable "name" {
  type        = string
  description = "Name for the release"
  default     = "aws-load-balancer-controller"
}

variable "oidc_issuer" {
  type        = string
  description = "OIDC issuer of the Kubernetes cluster"
}

variable "target_group_name" {
  description = "Override the name of the target group for this cluster"
  type        = string
  default     = null
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the AWS VPC in which the load balancer runs"
}

variable "default_ssl_policy" {
  type        = string
  description = "The default SSL policy to use for the load balancer"
  default     = null
}