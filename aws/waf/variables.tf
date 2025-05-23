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
    name                = string                     # Name of the Managed rule group
    priority            = number                     # Relative processing order for rules processed by AWS WAF. All rules are processed from lowest priority to the highest.
    count_override      = optional(bool, true)       # If true, this will override the rule action setting to `count`, if false, the rule action will be set to `block`.
    country_list        = optional(list(string), []) # List of countries to apply the managed rule to. If populated, from other countries will be ignored by this rule. IF empty, the rule will apply to all traffic. You must either specify country_list or exempt_country_list, but not both.
    exempt_country_list = optional(list(string), []) # List of countries to exempt from the managed rule. If populated, the selected countries will be ignored by this rule. IF empty, the rule will apply to all traffic. You must either specify country_list or exempt_country_list, but not both.
  }))
}

variable "rate_limit_rules" {
  description = "Rule statement to track and rate limits requests when they are coming at too fast a rate.. For more details, visit - https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html"
  type = map(object({
    name                = string                     # Name of the Rate limit rule group
    priority            = number                     # Relative processing order for rate limit rule relative to other rules processed by AWS WAF.
    limit               = optional(number, 2000)     # This is the limit on requests from any single IP address within a 5 minute period
    count_override      = optional(bool, false)      # If true, this will override the rule action setting to `count`, if false, the rule action will be set to `block`. Default value is false.
    country_list        = optional(list(string), []) # List of countries to apply the rate limit to. If populated, from other countries will be ignored by this rule. IF empty, the rule will apply to all traffic. You must either specify country_list or exempt_country_list, but not both.
    exempt_country_list = optional(list(string), []) # List of countries to exempt from the rate limit. If populated, the selected countries will be ignored by this rule. IF empty, the rule will apply to all traffic. You must either specify country_list or exempt_country_list, but not both.
  }))
}

variable "header_match_rules" {
  description = "Rule statement to inspect and match the header for an incoming request."
  type = map(object({
    name     = string                       # Name of the header match rule group
    priority = number                       # Relative processing order for header match rule relative to other rules processed by AWS WAF.
    header_values = map(object({            # Header values contains a map of headers to inspect. You can provide multiple headers and values, all headers will be inspected together with `AND` logic.
      header_name   = string                # This is the name of the header to inspect for all incoming requests.
      header_value  = string                # This is the value to look out for a matching header name for all incoming requests
      not_statement = optional(bool, false) # This indicates if the result this header match should be negated. The negated result will be joined with other header match results using `AND` logic if more than 1 header is provided.
    }))
    count_override = optional(bool, true) # If true, this will override the rule action setting to `count`, if false, the rule action will be set to `block`. Default value is false.
  }))

  default = null
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
