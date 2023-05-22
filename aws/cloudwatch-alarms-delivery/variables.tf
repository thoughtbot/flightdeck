variable "endpoint" {
  description = "Endpoint for CloudWatch alarm"
  type        = string

  validation {
    condition     = contains(["Opsgenie", "Sentry"], var.endpoint)
    error_message = "Valid values for var: endpoint are (Opsgenie, Sentry)."
  }
}

variable "name" {
  description = "Unique name for CloudWatch Alarm delivery"
  type        = string
}

variable "opsgenie_cloudwatch_api_key" {
  description = "API key of the Opsgenie CloudWatch integration"
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

variable "source_sns_topic_arn" {
  description = "Source SNS topic for CloudWatch alarm messages."
  type        = string
}

