# AWS Managed Grafana Data Sources

Adds data sources from a workload account to an AWS Managed Grafana workspace.

Example:

```terraform
module "grafana_production" {
  source = "github.com/thoughtbot/flightdeck//aws/grafana-data-sources?ref=VERSION"

  name = "production"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | ~> 1.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_grafana"></a> [grafana](#provider\_grafana) | ~> 1.13 |

## Resources

| Name | Type |
|------|------|
| [grafana_data_source.alertmanager](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/data_source) | resource |
| [grafana_data_source.cloudwatch](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/data_source) | resource |
| [grafana_data_source.prometheus](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/data_source) | resource |
| [aws_iam_role.grafana](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_prometheus_workspace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/prometheus_workspace) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_ssm_parameter.prometheus_workspace_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alertmanager_data_source_name"></a> [alertmanager\_data\_source\_name](#input\_alertmanager\_data\_source\_name) | Name of the AlertManager data source | `string` | `null` | no |
| <a name="input_cloudwatch_data_source_name"></a> [cloudwatch\_data\_source\_name](#input\_cloudwatch\_data\_source\_name) | Name of the CloudWatch data source | `string` | `null` | no |
| <a name="input_grafana_role_name"></a> [grafana\_role\_name](#input\_grafana\_role\_name) | Name of the Grafana role | `string` | `"grafana"` | no |
| <a name="input_name"></a> [name](#input\_name) | Namespace for data sources in this account | `string` | n/a | yes |
| <a name="input_prometheus_data_source_name"></a> [prometheus\_data\_source\_name](#input\_prometheus\_data\_source\_name) | Name of the Prometheus Grafana data source | `string` | `null` | no |
| <a name="input_prometheus_workspace_name"></a> [prometheus\_workspace\_name](#input\_prometheus\_workspace\_name) | Name of the Prometheus workspace for Grafana data source | `string` | `null` | no |
<!-- END_TF_DOCS -->
