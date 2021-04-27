variable "host" {
  type        = string
  description = "Base hostname for flightdeck UI"
}

variable "k8s_namespace" {
  type        = string
  default     = "flightdeck"
  description = "Kubernetes namespace in which resources should be created"
}
