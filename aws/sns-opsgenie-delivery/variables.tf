variable "sns_opsgenie_api_key" {
  description = "API key of the Opsgenie SNS Integration"
  type        = string
  default     = null
}

variable "cloudwatch_opsgenie_api_key" {
  description = "API key of the Opsgenie CloudWatch Integration"
  type        = string
  default     = null
}

variable "source_sns_topic_arn" {
  description = "Source SNS topic for AlertManager messages."
  type        = string
}
