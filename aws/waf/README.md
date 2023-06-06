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
      priority = 20
    }
    rule_two = {
      name     = "AWSManagedRulesKnownBadInputsRuleSet"
      priority = 30
    }
  }
  rate_limit = {
    Priority      = 10
    Limit         = 1000  # The limit on requests from any single IP address within a 5 minute period
  }
}
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

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.aws_waf_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ssm_parameter.aws_waf_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_wafv2_web_acl.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_logging_configuration.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_managed_rule_groups"></a> [aws\_managed\_rule\_groups](#input\_aws\_managed\_rule\_groups) | Rule statement values used to run the rules that are defined in a managed rule group. You may review this list for the available AWS managed rule groups - https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html | <pre>map(object({<br>    name           = string               # Name of the Managed rule group<br>    priority       = number               # Relative processing order for rules processed by AWS WAF. All rules are processed from lowest priority to the highest.<br>    count_override = optional(bool, true) # Override the rule action setting to count, this instructs AWS WAF to count the matching web request and allow it<br>  }))</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Friendly name of the WebACL. | `string` | n/a | yes |
| <a name="input_rate_limit"></a> [rate\_limit](#input\_rate\_limit) | Rule statement to track and rate limits requests when they are coming at too fast a rate.. For more details, visit - https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html | <pre>object({<br>    Priority = number                 # Relative processing order for rate limit rule relative to other rules processed by AWS WAF.<br>    Limit    = optional(number, 1000) # This is the limit on requests from any single IP address within a 5 minute period<br>  })</pre> | n/a | yes |
| <a name="input_resource_arn"></a> [resource\_arn](#input\_resource\_arn) | The Amazon Resource Name (ARN) of the resource to associate with the web ACL. This must be an ARN of an Application Load Balancer or an Amazon API Gateway stage. Value is required if scope is REGIONAL | `string` | `null` | no |
| <a name="input_waf_scope"></a> [waf\_scope](#input\_waf\_scope) | Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. | `string` | `"REGIONAL"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_waf_arn"></a> [aws\_waf\_arn](#output\_aws\_waf\_arn) | The arn for AWS WAF WebACL. |
<!-- END_TF_DOCS -->