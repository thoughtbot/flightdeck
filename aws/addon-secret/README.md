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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kind"></a> [kind](#input\_kind) | Kind of this addon | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of this addon | `string` | n/a | yes |
| <a name="input_policies"></a> [policies](#input\_policies) | List of IAM policies required to access this addon | `list(string)` | n/a | yes |
| <a name="input_secret_data"></a> [secret\_data](#input\_secret\_data) | Secret data for accessing this addon | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->