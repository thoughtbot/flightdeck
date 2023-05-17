<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.logs_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.alertmanger_sentry_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_layer_version.sentry_sdk_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [aws_lambda_permission.allow_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sns_topic.alertmanager_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.alertmanager_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sns_topic_subscription.prometheus_alertmanager_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [random_id.unique_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [archive_file.function](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lamada_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_prometheus_workspace.prometheus_workspace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/prometheus_workspace) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alertmanager_sns_topic_name"></a> [alertmanager\_sns\_topic\_name](#input\_alertmanager\_sns\_topic\_name) | Alertmanager SNS topic name | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Unique name for alertmanager config | `string` | n/a | yes |
| <a name="input_opsgenie_sns_api_key"></a> [opsgenie\_sns\_api\_key](#input\_opsgenie\_sns\_api\_key) | API key of the Opsgenie SNS integration | `string` | n/a | yes |
| <a name="input_opsgenie_sns_subscription_filter"></a> [opsgenie\_sns\_subscription\_filter](#input\_opsgenie\_sns\_subscription\_filter) | Opsgenie sns subscription filter policy to filter messages seen by the target resource | `map(list(string))` | n/a | yes |
| <a name="input_prometheus_workspace_id"></a> [prometheus\_workspace\_id](#input\_prometheus\_workspace\_id) | Unique Identifier of the prometheus workspace | `string` | n/a | yes |
| <a name="input_sentry_environment"></a> [sentry\_environment](#input\_sentry\_environment) | Sentry environment to push warning logs | `string` | `"production"` | no |
| <a name="input_sentry_secret_name"></a> [sentry\_secret\_name](#input\_sentry\_secret\_name) | Name of the secrets manager secret containing the sentry credentials | `string` | n/a | yes |
| <a name="input_sentry_sns_subscription_filter"></a> [sentry\_sns\_subscription\_filter](#input\_sentry\_sns\_subscription\_filter) | Sns subscription filter policy to filter messages seen by Sentry | `map(list(string))` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alertmanager_sentry_lambda_role_arn"></a> [alertmanager\_sentry\_lambda\_role\_arn](#output\_alertmanager\_sentry\_lambda\_role\_arn) | IAM role arn for the Lambda function that will send alertmanager messages from SNS to Sentry. |
| <a name="output_alertmanager_sns_topic_arn"></a> [alertmanager\_sns\_topic\_arn](#output\_alertmanager\_sns\_topic\_arn) | SNS topic arn for Alertmanager |
<!-- END_TF_DOCS -->