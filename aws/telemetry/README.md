# AWS Telemetry

Creates AWS-managed resources for telemetry, including:

- An AWS Managed Prometheus workspace for metrics
- SNS topics for CloudWatch alarms
- SNS topics for AlertManager alerts
- Different SNS topics for different levels of severity
- KMS encryption at rest for SNS topics
- An IAM role for Grafana to access data sources in this account

## Example

```terraform
module "telemetry" {
  source = "github.com/thoughtbot/flightdeck//aws/telemetry?ref=VERSION"

  prometheus_workspace_name = "flightdeck-production"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_grafana_role"></a> [grafana\_role](#module\_grafana\_role) | ./modules/grafana-role | n/a |
| <a name="module_prometheus_workspace"></a> [prometheus\_workspace](#module\_prometheus\_workspace) | ./modules/prometheus-workspace | n/a |
| <a name="module_sns_topics"></a> [sns\_topics](#module\_sns\_topics) | ./modules/sns-topics | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.ingestion_role_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.prometheus_workspace_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_principals"></a> [admin\_principals](#input\_admin\_principals) | IAM principals allowed to manage underlying resources | `list(string)` | `[]` | no |
| <a name="input_alert_default_severity"></a> [alert\_default\_severity](#input\_alert\_default\_severity) | Default severity for alerts | `string` | `"warning"` | no |
| <a name="input_alert_group_by"></a> [alert\_group\_by](#input\_alert\_group\_by) | Labels used to group similar alerts | `list(string)` | `null` | no |
| <a name="input_alert_message_template"></a> [alert\_message\_template](#input\_alert\_message\_template) | Template used for AlertManager messages | `string` | `null` | no |
| <a name="input_alert_resolve_timeout"></a> [alert\_resolve\_timeout](#input\_alert\_resolve\_timeout) | Time after which alerts without an end time after resolved | `string` | `null` | no |
| <a name="input_alert_severities"></a> [alert\_severities](#input\_alert\_severities) | List of alert priorities for AlertManager | `list(string)` | <pre>[<br>  "warning",<br>  "ticket",<br>  "page"<br>]</pre> | no |
| <a name="input_alert_subject_template"></a> [alert\_subject\_template](#input\_alert\_subject\_template) | Template used for AlertManager alert subjects | `string` | `null` | no |
| <a name="input_grafana_role_name"></a> [grafana\_role\_name](#input\_grafana\_role\_name) | Name of the IAM role created for Grafana | `string` | `"grafana"` | no |
| <a name="input_grafana_workspace_name"></a> [grafana\_workspace\_name](#input\_grafana\_workspace\_name) | Name of the Grafana workspace which will use telemetry resources | `string` | `"Grafana"` | no |
| <a name="input_kms_alias_name"></a> [kms\_alias\_name](#input\_kms\_alias\_name) | KMS alias name for SNS topics | `string` | `"alias/sns-alarm-topics"` | no |
| <a name="input_monitoring_account_ids"></a> [monitoring\_account\_ids](#input\_monitoring\_account\_ids) | AWS account IDs in which Grafana will run | `list(string)` | `null` | no |
| <a name="input_prometheus_workspace_name"></a> [prometheus\_workspace\_name](#input\_prometheus\_workspace\_name) | Name of the AWS Managed Prometheus workspace | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to created resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_prometheus_workspace_endpoint"></a> [aws\_prometheus\_workspace\_endpoint](#output\_aws\_prometheus\_workspace\_endpoint) | Prometheus endpoint available for this workspace |
| <a name="output_aws_prometheus_workspace_id"></a> [aws\_prometheus\_workspace\_id](#output\_aws\_prometheus\_workspace\_id) | Id for the prometheus workspace created in AWS |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | ID of the KMS key created to encrypt SNS messages |
| <a name="output_sns_topic_arns"></a> [sns\_topic\_arns](#output\_sns\_topic\_arns) | ARNs of the created SNS topics |
<!-- END_TF_DOCS -->
