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
    name           = string               # Name of the Managed rule group
    priority       = number               # Relative processing order for rules processed by AWS WAF. All rules are processed from lowest priority to the highest.
    count_override = optional(bool, true) # Override the rule action setting to count, this instructs AWS WAF to count the matching web request and allow it
  }))
}

variable "rate_limit" {
  description = "Rule statement to track and rate limits requests when they are coming at too fast a rate.. For more details, visit - https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html"
  type = object({
    Priority = number                 # Relative processing order for rate limit rule relative to other rules processed by AWS WAF.
    Limit    = optional(number, 1000) # This is the limit on requests from any single IP address within a 5 minute period
  })
}