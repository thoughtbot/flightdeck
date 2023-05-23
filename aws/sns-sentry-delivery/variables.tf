variable "endpoint" {
  description = "Endpoint for AlertManager message"
  type        = string

  validation {
    condition     = contains(["Opsgenie", "Sentry"], var.endpoint)
    error_message = "Valid values for var: endpoint are (Opsgenie, Sentry)."
  }
}

variable "name" {
  description = "Unique name for alertmanager delivery"
  type        = string
}

variable "opsgenie_sns_api_key" {
  description = "API key of the Opsgenie SNS integration"
  type        = string
  default     = null
}

variable "sentry_environment" {
  description = "Sentry environment to push warning logs"
  type        = string
  default     = "production"
}

variable "sentry_secret_name" {
  description = "Name of the secrets manager secret containing the sentry credentials"
  type        = string
  default     = null
}

variable "sentry_subject_prefix" {
  description = "Set a prefix to add to the subject before being published to Sentry"
  type        = string
  default     = ""
}

variable "sns_message_as_subject" {
  description = "Set the SNS message field as the subject for Sentry"
  type        = bool
  default     = false
}

variable "source_sns_topic_arn" {
  description = "Source SNS topic for AlertManager messages."
  type        = string
}
