<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availability zones in which NAT should be provided | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for this network | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Prefix to be applied to created resources | `list(string)` | `[]` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Public subnets for each availability\_zone | `map(object({ id = string, availability_zone = string }))` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to all created resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instances"></a> [instances](#output\_instances) | The created NAT gateways for each availability zone |
<!-- END_TF_DOCS -->