variable "alertmanager_sns_topic_name" {
  description = "Alertmanager SNS topic name"
  type        = string
}

variable "sentry_environment" {
  description = "Sentry environment to push warning logs"
  type        = string
  default     = "production"
}

variable "name" {
  description = "Unique name for alertmanager config"
  type        = string
}

variable "opsgenie_sns_api_key" {
  description = "API key of the Opsgenie SNS integration"
  type        = string
}

variable "opsgenie_sns_subscription_filter" {
  description = "Opsgenie sns subscription filter policy to filter messages seen by the target resource"
  type        = map(list(string))
}

variable "prometheus_workspace_id" {
  description = "Unique Identifier of the prometheus workspace"
  type        = string
}

variable "sentry_secret_name" {
  description = "Name of the secrets manager secret containing the sentry credentials"
  type        = string
}

variable "sentry_sns_subscription_filter" {
  description = "Sns subscription filter policy to filter messages seen by Sentry"
  type        = map(list(string))
}
