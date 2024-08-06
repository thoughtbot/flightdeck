# CloudWatch Logs Extract Module

This module creates a [CloudWatch logs subscription](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#LambdaFunctionExample) to stream CloudWatch logs to a lambda function endpoint. You can pass in a Log group filter to select the Logs from the Log group that need to be streamed, you can also pass in a regex pattern to pick out important details from the log group and map each capture group to a label.
These messages will be sent as a json string to an SNS endpoint. You can pass in a message attribute detail to be added to the message sent to the SNS destination endpoint.


Example:

```
module "cloudwatch_log_extract" {
  source = "github.com/thoughtbot/flightdeck//aws/cloudwatch-log-extract"
  
  # Enter a log group filter pattern to pick which logs get sent to the lambda endpoint
  log_group_filter_pattern = "duration"

  # Enter a log message filter expression to pick out specific details to be sent to the destination SNS topic. You may provide a regex pattern with capture groups, and enter the label for each capture group.
  log_message_filter = {
    regex_pattern = ".* duration: ([0-9.]+) ms .* content: (.*)"
    capture_group = {
      1 = "duration",
      2 = "message"
    }
  }

  # Enter the destination SNS topic
  destination_sns_topic_arn = "arn:aws:sns:us-east-1:123456789:destination-sns-topic"

  # Enter any message attribute for the SNS message.
  destination_sns_message_attributes = {
    environment = "production"
  }

  # Enter the CloudWatch log group to subscribe to for log messages.
  source_cloudwatch_log_group = "/sample/cloudwatch/log/group"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~> 2.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_subscription_filter.cloudwatch_log_filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.logs_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.sql_query_update](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [random_id.unique_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [archive_file.function](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudwatch_log_group) | data source |
| [aws_iam_policy_document.assume_role_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_filter_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_destination_sns_topic_arn"></a> [destination\_sns\_topic\_arn](#input\_destination\_sns\_topic\_arn) | The ARN of the destination SNS topic to deliver matching log events to. | `string` | n/a | yes |
| <a name="input_log_group_filter_pattern"></a> [log\_group\_filter\_pattern](#input\_log\_group\_filter\_pattern) | CloudWatch Logs filter pattern for subscribing to a filtered stream of log events | `string` | `""` | no |
| <a name="input_log_message_filter"></a> [log\_message\_filter](#input\_log\_message\_filter) | Filter regex pattern to pick out items from a Cloudwatch log to be sent to destination endpoint. Pass in a valid regex pattern with capture groups, and a capture\_group map stating the label for each capture\_group | <pre>object({<br>    regex_pattern = string,<br>    capture_group = map(string)<br>  })</pre> | <pre>{<br>  "capture_group": {},<br>  "regex_pattern": ""<br>}</pre> | no |
| <a name="input_message_attributes"></a> [message\_attributes](#input\_message\_attributes) | Message attributes to be included with messages publised to SNS | `map(string)` | `{}` | no |
| <a name="input_source_cloudwatch_log_group"></a> [source\_cloudwatch\_log\_group](#input\_source\_cloudwatch\_log\_group) | The name of the log group to associate the subscription filter with | `string` | n/a | yes |
<!-- END_TF_DOCS -->
