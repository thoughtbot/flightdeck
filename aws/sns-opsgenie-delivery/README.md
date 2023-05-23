# AlertManager Deliery Module

A module to deliver messages from CloudWatch or SNS to Opsgenie.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_sns_topic_subscription.cloudwatch_opsgenie_delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sns_topic_subscription.sns_opsgenie_delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_opsgenie_api_key"></a> [cloudwatch\_opsgenie\_api\_key](#input\_cloudwatch\_opsgenie\_api\_key) | API key of the Opsgenie CloudWatch Integration | `string` | `null` | no |
| <a name="input_sns_opsgenie_api_key"></a> [sns\_opsgenie\_api\_key](#input\_sns\_opsgenie\_api\_key) | API key of the Opsgenie SNS Integration | `string` | `null` | no |
| <a name="input_source_sns_topic_arn"></a> [source\_sns\_topic\_arn](#input\_source\_sns\_topic\_arn) | Source SNS topic for AlertManager messages. | `string` | n/a | yes |
<!-- END_TF_DOCS -->