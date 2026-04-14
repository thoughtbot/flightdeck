# AWS S3 VPC Endpoint

Module for creating a S3 VPC Endpoint in AWS.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name for this network (used in the endpoint's Name tag) | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Prefix to be applied to created resources | `list(string)` | `[]` | no |
| <a name="input_route_table_ids"></a> [route\_table\_ids](#input\_route\_table\_ids) | List of route table IDs to associate with the S3 Gateway endpoint | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the endpoint | `map(string)` | `{}` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | The VPC object in which to create the S3 endpoint | <pre>object({<br>    id = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint_id"></a> [endpoint\_id](#output\_endpoint\_id) | ID of the S3 Gateway VPC endpoint |
| <a name="output_prefix_list_id"></a> [prefix\_list\_id](#output\_prefix\_list\_id) | Prefix list ID of the S3 endpoint (useful for security group egress rules) |
<!-- END_TF_DOCS -->