variable "chart_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}

variable "extra_secrets" {
  type        = map(string)
  default     = {}
  description = "Extra values to append to the Dex secret"
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace in which secrets should be created"
}

variable "name" {
  description = "Name for the Helm release"
  type        = string
  default     = "dex"
}

variable "static_clients" {
  type        = map(object({ name = string, redirectURIs = list(string) }))
  default     = {}
  description = "Map of static clients to configure with OAuth2 secrets"
}
