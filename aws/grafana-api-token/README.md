# Grafana API token

Fetches the URL and authentication necessary to initialize the Grafana provider
for an AWS Managed Grafana workspace.

Example:

```terraform
module "grafana_api_key" {
  source = "github.com/thoughtbot/flightdeck//aws/grafana-api-token?ref=VERSION"
}


provider "grafana" {
  url  = module.grafana_api_key.url
  auth = module.grafana_api_key.auth
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.12 |

## Resources

| Name | Type |
|------|------|
| [aws_grafana_workspace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/grafana_workspace) | data source |
| [aws_secretsmanager_secret_version.api_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_ssm_parameter.grafana_api_token_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.grafana_workspace_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_grafana_workspace_name"></a> [grafana\_workspace\_name](#input\_grafana\_workspace\_name) | Name of this Grafana workspace | `string` | `"Grafana"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN for this Grafana workspace |
| <a name="output_auth"></a> [auth](#output\_auth) | Auth header for connecting to this Grafana workspace |
| <a name="output_url"></a> [url](#output\_url) | URL for accessing this Grafana workspace |
<!-- END_TF_DOCS -->
