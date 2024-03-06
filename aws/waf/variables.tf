variable "name" {
  description = "Friendly name of the WebACL."
  type        = string
}

variable "waf_scope" {
  description = "Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. "
  type        = string
  default     = "REGIONAL"

  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.waf_scope)
    error_message = "Scope must be either CLOUDFRONT or REGIONAL."
  }
}

variable "resource_arn" {
  description = "The Amazon Resource Name (ARN) of the resource to associate with the web ACL. This must be an ARN of an Application Load Balancer or an Amazon API Gateway stage. Value is required if scope is REGIONAL"
  type        = string
  default     = null
}

variable "aws_managed_rule_groups" {
  description = "Rule statement values used to run the rules that are defined in a managed rule group. You may review this list for the available AWS managed rule groups - https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html"
  type = map(object({
    name           = string                     # Name of the Managed rule group
    priority       = number                     # Relative processing order for rules processed by AWS WAF. All rules are processed from lowest priority to the highest.
    count_override = optional(bool, true)       # If true, this will override the rule action setting to `count`, if false, the rule action will be set to `block`.
    country_list   = optional(list(string), []) # List of countries to apply the managed rule to. If populated, from other countries will be ignored by this rule. IF empty, the rule will apply to all traffic.
  }))
}

variable "rate_limit_rules" {
  description = "Rule statement to track and rate limits requests when they are coming at too fast a rate.. For more details, visit - https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html"
  type = map(object({
    name           = string                     # Name of the Rate limit rule group
    priority       = number                     # Relative processing order for rate limit rule relative to other rules processed by AWS WAF.
    limit          = optional(number, 2000)     # This is the limit on requests from any single IP address within a 5 minute period
    count_override = optional(bool, false)      # If true, this will override the rule action setting to `count`, if false, the rule action will be set to `block`. Default value is false.
    country_list   = optional(list(string), []) # List of countries to apply the rate limit to. If populated, from other countries will be ignored by this rule. IF empty, the rule will apply to all traffic.
  }))
}

variable "allowed_ip_list" {
  description = "List of allowed IP addresses, these IP addresses will be exempted from any configured rules"
  type        = list(string)
  default     = []
}

variable "block_ip_list" {
  description = "List of IP addresses to be blocked and denied access to the ingress / cloudfront."
  type        = list(string)
  default     = []
}
