# AlertManager Deliery Module

A module to deliver AlertManger messages to one of the selected endpoints. Available endpoints are Opsgenie and Sentry.

Creates SNS topics for different sources and alert severity levels. Topic
contents are encrypted at rest using KMS.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~> 2.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.logs_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.alertmanger_sentry_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_layer_version.sentry_sdk_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [aws_lambda_permission.allow_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sns_topic_subscription.alertmanager_opsgenie_delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sns_topic_subscription.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [random_id.unique_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [archive_file.function](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lamada_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alertmanager_sns_topic_name"></a> [alertmanager\_sns\_topic\_name](#input\_alertmanager\_sns\_topic\_name) | Alertmanager SNS topic name | `string` | n/a | yes |
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | Endpoint for AlertManager message | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Unique name for alertmanager delivery | `string` | n/a | yes |
| <a name="input_opsgenie_sns_api_key"></a> [opsgenie\_sns\_api\_key](#input\_opsgenie\_sns\_api\_key) | API key of the Opsgenie SNS integration | `string` | `null` | no |
| <a name="input_sentry_environment"></a> [sentry\_environment](#input\_sentry\_environment) | Sentry environment to push warning logs | `string` | `"production"` | no |
| <a name="input_sentry_secret_name"></a> [sentry\_secret\_name](#input\_sentry\_secret\_name) | Name of the secrets manager secret containing the sentry credentials | `string` | `null` | no |
| <a name="input_source_sns_topic_arn"></a> [source\_sns\_topic\_arn](#input\_source\_sns\_topic\_arn) | Source SNS topic for AlertManager messages. | `string` | n/a | yes |
<!-- END_TF_DOCS -->