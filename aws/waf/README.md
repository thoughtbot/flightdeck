# AWS WAF Module

A module to create and configure an [AWS WAF](https://aws.amazon.com/waf/faqs/) (Web Application Firewall) resource. It supports Rate limiting and accepts a list of AWS managed rules to be applied to the WAF for incoming requests from cloudfront, ELB or API Gateway.


Example:

``` hcl
module "aws_waf" {
  source = "github.com/thoughtbot/flightdeck//aws/waf?ref=VERSION"

  name         = "sandbox-waf"
  resource_arn = "arn:aws:xxx:region:123456:xx/xx/xx/xx" # Load balance / API gateway resource arn. This is required if scope is REGIONAL
  aws_managed_rule_groups = {
    rule_one = {
      name     = "AWSManagedRulesAmazonIpReputationList"
      priority = 30
    }
    rule_two = {
      name     = "AWSManagedRulesAmazonIpReputationList"
      priority = 40
      count_override = false    # Set count override to false to enable rule in blocking mode
    }
    rule_three = {
      name     = "AWSManagedRulesAmazonIpReputationList"
      priority = 50
      country_list = ["US"]     # Set rule for only traffic from the US
      count_override = false    # Set count override to false to enable rule in blocking mode
    }
    rule_four = {
      name     = "AWSManagedRulesKnownBadInputsRuleSet"
      priority = 60
    }
  }
  rate_limit_rules = {
    country_specific_rate_limit = {
      name          = "Country-Specific"
      priority      = 10
      limit         = 2000      # The limit on requests from any single IP address within a 5 minute period
      exempt_country_list = ["BE"]     # Set rate limit rule for only traffic from the US
    }
    general_rate_limit = {
      name          = "General"
      priority      = 20
      limit         = 1000  # The limit on requests from any single IP address within a 5 minute period
    }
  }
}

Note: For each rule, if you are providing a country list, you can only specify either country_list or exempt_country_list, but you cannot enter both
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudwatch_log_extract"></a> [cloudwatch\_log\_extract](#module\_cloudwatch\_log\_extract) | ../cloudwatch-log-extract | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.aws_waf_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_sns_topic.waf_logs_sns_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_ssm_parameter.aws_waf_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_wafv2_ip_set.allowed_ip_list](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_ip_set.block_ip_list](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_logging_configuration.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ip_list"></a> [allowed\_ip\_list](#input\_allowed\_ip\_list) | List of allowed IP addresses, these IP addresses will be exempted from any configured rules | `list(string)` | `[]` | no |
| <a name="input_aws_managed_rule_groups"></a> [aws\_managed\_rule\_groups](#input\_aws\_managed\_rule\_groups) | Rule statement values used to run the rules that are defined in a managed rule group. You may review this list for the available AWS managed rule groups - https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html | <pre>map(object({<br>    name                = string                     # Name of the Managed rule group<br>    priority            = number                     # Relative processing order for rules processed by AWS WAF. All rules are processed from lowest priority to the highest.<br>    count_override      = optional(bool, true)       # If true, this will override the rule action setting to `count`, if false, the rule action will be set to `block`.<br>    country_list        = optional(list(string), []) # List of countries to apply the managed rule to. If populated, from other countries will be ignored by this rule. IF empty, the rule will apply to all traffic. You must either specify country_list or exempt_country_list, but not both.<br>    exempt_country_list = optional(list(string), []) # List of countries to exempt from the managed rule. If populated, the selected countries will be ignored by this rule. IF empty, the rule will apply to all traffic. You must either specify country_list or exempt_country_list, but not both.<br>  }))</pre> | n/a | yes |
| <a name="input_block_ip_list"></a> [block\_ip\_list](#input\_block\_ip\_list) | List of IP addresses to be blocked and denied access to the ingress / cloudfront. | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Friendly name of the WebACL. | `string` | n/a | yes |
| <a name="input_rate_limit_rules"></a> [rate\_limit\_rules](#input\_rate\_limit\_rules) | Rule statement to track and rate limits requests when they are coming at too fast a rate.. For more details, visit - https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html | <pre>map(object({<br>    name                = string                     # Name of the Rate limit rule group<br>    priority            = number                     # Relative processing order for rate limit rule relative to other rules processed by AWS WAF.<br>    limit               = optional(number, 2000)     # This is the limit on requests from any single IP address within a 5 minute period<br>    count_override      = optional(bool, false)      # If true, this will override the rule action setting to `count`, if false, the rule action will be set to `block`. Default value is false.<br>    country_list        = optional(list(string), []) # List of countries to apply the rate limit to. If populated, from other countries will be ignored by this rule. IF empty, the rule will apply to all traffic. You must either specify country_list or exempt_country_list, but not both.<br>    exempt_country_list = optional(list(string), []) # List of countries to exempt from the rate limit. If populated, the selected countries will be ignored by this rule. IF empty, the rule will apply to all traffic. You must either specify country_list or exempt_country_list, but not both.<br>  }))</pre> | n/a | yes |
| <a name="input_resource_arn"></a> [resource\_arn](#input\_resource\_arn) | The Amazon Resource Name (ARN) of the resource to associate with the web ACL. This must be an ARN of an Application Load Balancer or an Amazon API Gateway stage. Value is required if scope is REGIONAL | `string` | `null` | no |
| <a name="input_waf_scope"></a> [waf\_scope](#input\_waf\_scope) | Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. | `string` | `"REGIONAL"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_waf_arn"></a> [aws\_waf\_arn](#output\_aws\_waf\_arn) | The arn for AWS WAF WebACL. |
<!-- END_TF_DOCS -->