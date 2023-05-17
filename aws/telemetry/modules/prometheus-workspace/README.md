# Prometheus Workspace

Configures an [AWS Managed Prometheus] workspace.

In addition to the workspace, an IAM role will be provisioned with permission to
write to the workspace.

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
| [aws_iam_policy.ingestion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ingestion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ingestion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_prometheus_alert_manager_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_alert_manager_definition) | resource |
| [aws_prometheus_workspace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_workspace) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ingestion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ingestion_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_group_by"></a> [alert\_group\_by](#input\_alert\_group\_by) | Labels used to group similar alerts | `list(string)` | `null` | no |
| <a name="input_alert_message_template"></a> [alert\_message\_template](#input\_alert\_message\_template) | Template used for AlertManager messages | `string` | `null` | no |
| <a name="input_alert_resolve_timeout"></a> [alert\_resolve\_timeout](#input\_alert\_resolve\_timeout) | Time after which alerts without an end time after resolved | `string` | `null` | no |
| <a name="input_alert_subject_template"></a> [alert\_subject\_template](#input\_alert\_subject\_template) | Template used for AlertManager alert subjects | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for this Prometheus workspace | `string` | n/a | yes |
| <a name="input_sns_receivers"></a> [sns\_receivers](#input\_sns\_receivers) | Map of alert priorities to SNS topics for AlertManager | `map(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to created resources | `map(string)` | `{}` | no |
| <a name="input_workload_account_ids"></a> [workload\_account\_ids](#input\_workload\_account\_ids) | Workload accounts allowed to write to this workspace | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_prometheus_workspace_endpoint"></a> [aws\_prometheus\_workspace\_endpoint](#output\_aws\_prometheus\_workspace\_endpoint) | Prometheus endpoint available for this workspace |
| <a name="output_aws_prometheus_workspace_id"></a> [aws\_prometheus\_workspace\_id](#output\_aws\_prometheus\_workspace\_id) | Id for the prometheus workspace created in AWS |
| <a name="output_ingestion_role_arn"></a> [ingestion\_role\_arn](#output\_ingestion\_role\_arn) | ARN of the IAM role allowed to submit metrics |
<!-- END_TF_DOCS -->