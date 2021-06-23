variable "name" {
  type        = string
  description = "Name of this addon"
}

variable "policies" {
  type        = list(string)
  description = "List of IAM policies required to access this addon"
}

variable "secret_data" {
  type        = map(string)
  description = "Secret data for accessing this addon"
}
