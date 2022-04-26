# Prometheus Workspace

Creates a prometheus datasource object containing the necessary details to connect to a prometheus workspace in AWS using flightdeck workload platform.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_prometheus_workspace_id"></a> [aws\_prometheus\_workspace\_id](#input\_aws\_prometheus\_workspace\_id) | AWS managed prometheus workspace name. | `string` | n/a | yes |
| <a name="input_aws_prometheus_workspace_name"></a> [aws\_prometheus\_workspace\_name](#input\_aws\_prometheus\_workspace\_name) | AWS managed prometheus workspace name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_prometheus_data"></a> [prometheus\_data](#output\_prometheus\_data) | Prometheus datasource object for the provided workspace |
<!-- END_TF_DOCS -->
