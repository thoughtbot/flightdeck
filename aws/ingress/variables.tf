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

variable "waf_allowed_ip_list" {
  description = "Applicable if WAF is enabled. List of allowed IP addresses, these IP addresses will be exempted from any configured rules"
  type        = list(string)
  default     = []
}

variable "waf_block_ip_list" {
  description = "Applicable if WAF is enabled. List of IP addresses to be blocked and denied access to the ingress / cloudfront."
  type        = list(string)
  default     = []
}

variable "alternative_domain_names" {
  type        = list(string)
  default     = []
  description = "Alternative domain names for the ALB"
}

variable "certificate_domain_name" {
  type        = string
  default     = null
  description = "Override the domain name for the ACM certificate (defaults to primary domain)"
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

variable "enable_waf" {
  description = "Enable AWS WAF for this ingress resource"
  type        = bool
  default     = false
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

variable "waf_aws_managed_rule_groups" {
  description = "Applicable if WAF is enabled. Rule statement values used to run the rules that are defined in a managed rule group. You may review this list for the available AWS managed rule groups - https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html"
  type = map(object({
    name           = string               # Name of the Managed rule group
    priority       = number               # Relative processing order for rules processed by AWS WAF. All rules are processed from lowest priority to the highest.
    count_override = optional(bool, true) # If true, this will override the rule action setting to `count`, if false, the rule action will be set to `block`.
  }))
  default = {
    rule_one = {
      name     = "AWSManagedRulesAmazonIpReputationList"
      priority = 20
    }
    rule_two = {
      name     = "AWSManagedRulesKnownBadInputsRuleSet"
      priority = 30
    }
    rule_three = {
      name     = "AWSManagedRulesSQLiRuleSet"
      priority = 40
    }
    rule_four = {
      name     = "AWSManagedRulesLinuxRuleSet"
      priority = 50
    }
    rule_five = {
      name     = "AWSManagedRulesUnixRuleSet"
      priority = 60
    }
    rule_six = {
      name     = "AWSManagedRulesBotControlRuleSet"
      priority = 70
    }
  }
}

variable "waf_rate_limit" {
  description = "Applicable if WAF is enabled. Rule statement to track and rate limits requests when they are coming at too fast a rate.. For more details, visit - https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html"
  type = map(object({
    name           = string                     # Name of the Rate limit rule group
    priority       = number                     # Relative processing order for rate limit rule relative to other rules processed by AWS WAF.
    limit          = optional(number, 2000)     # This is the limit on requests from any single IP address within a 5 minute period
    count_override = optional(bool, false)      # If true, this will override the rule action setting to `count`, if false, the rule action will be set to `block`. Default value is false.
    country_list   = optional(list(string), []) # List of countries to apply the rate limit to. If populated, from other countries will be ignored by this rule. IF empty, the rule will apply to all traffic.
  }))
  default = {
    default_rule = {
      name     = "General"
      priority = 10
      limit    = 2000
    }
  }
}
