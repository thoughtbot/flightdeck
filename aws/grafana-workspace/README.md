# AWS Managed Grafana workspace

This module creates an AWS Managed Grafana workspace preconfigured to use data
sources created by Flightdeck.

Created resources include:

- The AMG workspace
- A service role configured to assume data source roles in workload accounts
- AWS IAM Identity Center group assignments for Grafana access
- A rotating API key managed by Secrets Manager suitable for automations

Example:

```terraform
module "grafana_workspace" {
  source = "github.com/thoughtbot/flightdeck//aws/grafana-workspace?ref=VERSION"

  # Assign AWS IAM Identity Center groups to Grafana
  admin_groups  = ["admin-group-id"]
  editor_groups = ["editor-group-id"]
  viewer_groups = ["viewer-group-id"]

  # Grant the Grafana service role permission to assume data source roles
  workload_account_ids = [
    "000000000000", # Sandbox
    "000000000000", # Production
  ]
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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_key"></a> [api\_key](#module\_api\_key) | ./modules/rotating-api-key | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_grafana_role_association.admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_role_association) | resource |
| [aws_grafana_role_association.editor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_role_association) | resource |
| [aws_grafana_role_association.viewer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_role_association) | resource |
| [aws_grafana_workspace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace) | resource |
| [aws_grafana_workspace_api_key.initial](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace_api_key) | resource |
| [aws_iam_policy.grafana](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.grafana](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.grafana](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_ssm_parameter.grafana_api_key_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.grafana_workspace_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.grafana](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.grafana_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_groups"></a> [admin\_groups](#input\_admin\_groups) | IAM Identity Center groups with administrator access to Grafana | `list(string)` | `[]` | no |
| <a name="input_authentication_providers"></a> [authentication\_providers](#input\_authentication\_providers) | Providers used to sign in to Grafana | `list(string)` | <pre>[<br/>  "AWS_SSO"<br/>]</pre> | no |
| <a name="input_editor_groups"></a> [editor\_groups](#input\_editor\_groups) | IAM Identity Center groups with edit access to Grafana | `list(string)` | `[]` | no |
| <a name="input_grafana_api_key_name"></a> [grafana\_api\_key\_name](#input\_grafana\_api\_key\_name) | Name for the Grafana API key used by Terraform | `string` | `"terraform"` | no |
| <a name="input_grafana_version"></a> [grafana\_version](#input\_grafana\_version) | Version of AWS Managed Grafana to use (e.g., '11.3.0') | `string` | `null` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | Override the name of the service role for Grafana | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of this Grafana workspace | `string` | `"Grafana"` | no |
| <a name="input_viewer_groups"></a> [viewer\_groups](#input\_viewer\_groups) | IAM Identity Center groups with view access to Grafana | `list(string)` | `[]` | no |
| <a name="input_workload_account_ids"></a> [workload\_account\_ids](#input\_workload\_account\_ids) | AWS account IDs for Prometheus and CloudWatch resources | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN for this Grafana workspace |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | URL for accessing this Grafana workspace |
<!-- END_TF_DOCS -->
