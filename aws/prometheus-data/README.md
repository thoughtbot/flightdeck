# Prometheus Workspace

Creates a prometheus datasource object containing the necessary details to connect to a prometheus workspace in AWS using flightdeck workload platform.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.64 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.64 |

## Resources

| Name | Type |
|------|------|
| [aws_prometheus_workspace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/prometheus_workspace) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_ssm_parameter.ingestion_role_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.workspace_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_prometheus_workspace_name"></a> [aws\_prometheus\_workspace\_name](#input\_aws\_prometheus\_workspace\_name) | AWS managed prometheus workspace name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_prometheus_data"></a> [prometheus\_data](#output\_prometheus\_data) | Prometheus datasource object for the provided workspace |
<!-- END_TF_DOCS -->