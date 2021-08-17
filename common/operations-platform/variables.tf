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

variable "flightdeck_namespace" {
  type        = string
  default     = "flightdeck"
  description = "Kubernetes namespace in which flightdeck should be installed"
}

variable "host" {
  type        = string
  description = "Base hostname for flightdeck UI"
}

variable "ui_values" {
  description = "Overrides to pass to the Helm chart"
  type        = list(string)
  default     = []
}
