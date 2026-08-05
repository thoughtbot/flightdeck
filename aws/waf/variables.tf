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

variable "host_ip_restriction_rules" {
  description = "Restrict specific Hosts (optionally scoped to URL path prefixes) to an allowed IP set. For each entry, blocks requests where the Host header matches exactly, the URI matches one of the given path prefixes (if any), AND the source IP is not in that entry's allowed set. Globally allowed IPs (allowed_ip_list) still pass via the priority-0 allow rule."
  type = map(object({
    name            = string                     # Friendly name, used in the rule name and CloudWatch metric.
    priority        = number                     # Unique WAF rule priority within the ACL. All rules are processed from lowest to highest priority.
    host            = string                     # Exact Host header to restrict, e.g. "core-data.albaikcloud.com".
    allowed_ip_list = list(string)               # IPv4 CIDRs permitted to reach the host. All other (non globally-allowed) IPs are blocked for this host.
    uri_paths       = optional(list(string), []) # Path prefixes to scope the restriction to, e.g. ["/admin"]. Matched with STARTS_WITH, so "/admin" also covers "/admin/x". Empty (default) restricts the whole host.
    count_override  = optional(bool, false)      # If true, override the action to `count` (dry run). If false (default), the action is `block`.
  }))
  default = {}
}

variable "host_uri_rate_limit_rules" {
  description = "Per-IP rate limits scoped to a specific Host and optional URI path(s). Only requests matching the host (and URI, if given) count toward the limit; when an IP exceeds it within the evaluation window the rule action applies."
  type = map(object({
    name                  = string                          # Friendly name -> rule name + CloudWatch metric.
    priority              = number                          # Unique WAF rule priority within the ACL.
    limit                 = optional(number, 2000)          # Max matching requests per IP per evaluation window (AWS minimum is 10).
    evaluation_window_sec = optional(number, 300)           # Rate-limit window in seconds. One of 60, 120, 300, 600.
    host                  = string                          # Exact Host header to scope the rate limit to, e.g. "example.com".
    uri_paths             = optional(list(string), [])      # URI path(s) to scope the rate limit to. With REGEX these are regex patterns. Empty (default) rate-limits the whole host.
    uri_match_type        = optional(string, "STARTS_WITH") # How to match uri_paths: EXACTLY (pin one endpoint), STARTS_WITH (prefix), or REGEX (for variable segments, e.g. "^/api/v1/users/[^/]+/validation$"). REGEX is case-sensitive (URL-decoded, not lowercased); use an inline (?i) flag for case-insensitivity.
    count_override        = optional(bool, false)           # If true, override the action to `count` (dry run). If false (default), the action is `block` when the limit is exceeded.

    # Optional custom block response (only applied when the action is `block`, i.e. count_override = false).
    block_response_code       = optional(number) # HTTP status returned to blocked clients, e.g. 429. Null (default) => WAF's default 403. Setting this is what enables the custom response.
    block_retry_after_seconds = optional(number) # If set (requires block_response_code), adds a `Retry-After: <n>` response header.
    block_response_body_json  = optional(string) # If set (requires block_response_code), returns this string as an APPLICATION_JSON body (<= 4096 bytes).
  }))
  default = {}

  validation {
    condition     = alltrue([for r in values(var.host_uri_rate_limit_rules) : contains(["EXACTLY", "STARTS_WITH", "REGEX"], r.uri_match_type)])
    error_message = "uri_match_type must be EXACTLY, STARTS_WITH, or REGEX."
  }
  validation {
    condition     = alltrue([for r in values(var.host_uri_rate_limit_rules) : contains([60, 120, 300, 600], r.evaluation_window_sec)])
    error_message = "evaluation_window_sec must be one of 60, 120, 300, 600."
  }
  validation {
    condition     = alltrue([for r in values(var.host_uri_rate_limit_rules) : r.block_response_code == null ? true : (r.block_response_code >= 200 && r.block_response_code <= 599)])
    error_message = "block_response_code must be a valid HTTP status (200-599) supported by AWS WAF, e.g. 429."
  }
  validation {
    condition     = alltrue([for r in values(var.host_uri_rate_limit_rules) : r.block_response_body_json == null ? true : length(r.block_response_body_json) <= 4096])
    error_message = "block_response_body_json must be 4096 bytes or fewer (AWS WAF custom response body limit)."
  }
}
