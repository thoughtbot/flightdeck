variable "block_public_access" {
  type        = bool
  description = "Set to false to enable public access policies"
  default     = true
}

variable "kms_key" {
  type        = object({ id = string })
  description = "Encryption key for objects in this bucket"
  default     = null
}

variable "name" {
  type        = string
  description = "Name for this S3 bucket"

  validation {
    condition     = can(regex("^[a-z][a-z0-9.-]{2,63}$", var.name))
    error_message = "Bucket name must be a valid DNS name."
  }
}

variable "namespace" {
  type        = list(string)
  description = "Prefix to be applied to created resources"
  default     = []
}

variable "policy" {
  type        = string
  description = "IAM resource policy for this bucket"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to created resources"
  default     = {}
}
