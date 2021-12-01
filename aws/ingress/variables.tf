variable "alarm_evaluation_minutes" {
  type        = number
  default     = 2
  description = "Number of minutes of alarm state until triggering an alarm"
}

variable "alarm_actions" {
  type        = list(object({ arn = string }))
  description = "SNS topics or other actions to invoke for alarms"
  default     = []
}

variable "alternative_domain_names" {
  type        = list(string)
  default     = []
  description = "Alternative domain names for the ALB"
}

variable "cluster_names" {
  type        = list(string)
  description = "List of clusters that this ingress stack will forward to"
}

variable "create_aliases" {
  description = "Set to false to disable creation of Route 53 aliases"
  type        = bool
  default     = true
}

variable "failure_threshold" {
  type        = number
  description = "Percentage of failed requests considered an anomaly"
  default     = 5
}

variable "hosted_zone_name" {
  type        = string
  description = "Hosted zone for AWS Route53"
  default     = null
}

variable "issue_certificates" {
  description = "Set to false to disable creation of ACM certificates"
  type        = bool
  default     = true
}

variable "legacy_target_group_names" {
  description = "Names of legacy target groups which should be included"
  type        = list(string)
  default     = []
}

variable "name" {
  description = "Name of the AWS network in which ingress should be provided"
  type        = string
}

variable "namespace" {
  description = "Prefix to apply to created resources"
  type        = list(string)
  default     = []
}

variable "network_tags" {
  description = "Tags for finding the AWS VPC and subnets"
  type        = map(string)
  default     = {}
}

variable "primary_domain_name" {
  type        = string
  description = "Primary domain name for the ALB"
}

variable "slow_response_threshold" {
  type        = number
  default     = 10
  description = "Response time considered extremely slow"
}

variable "tags" {
  description = "Tags to apply to created resources"
  type        = map(string)
  default     = {}
}

variable "target_group_weights" {
  description = "Weight for each target group (defaults to 100)"
  type        = map(number)
  default     = {}
}

variable "validate_certificates" {
  description = "Set to false to disable validation via Route 53"
  type        = bool
  default     = true
}
