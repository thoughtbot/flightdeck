<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Base name for this cluster | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Prefix to be applied to created resources | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_base"></a> [base](#output\_base) | Base name for this cluster |
| <a name="output_full"></a> [full](#output\_full) | Full name for this cluster |
| <a name="output_private_tags"></a> [private\_tags](#output\_private\_tags) | Tags applied to private resources for this cluster |
| <a name="output_public_tags"></a> [public\_tags](#output\_public\_tags) | Tags applied to public resources for this cluster |
| <a name="output_shared_tags"></a> [shared\_tags](#output\_shared\_tags) | Shared tags for this cluster |
<!-- END_TF_DOCS -->