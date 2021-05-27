variable "arch" {
  description = "Architecture to download"
  type        = string
  default     = "amd64"
}

variable "download_base_uri" {
  description = "Base URI for downloading Istio release"
  type        = string
  default     = "https://github.com/istio/istio/releases/download"
}

variable "istio_version" {
  description = "Version of Istio to download"
  type        = string
}

variable "os" {
  description = "OS to download"
  type        = string
  default     = "linux"
}
