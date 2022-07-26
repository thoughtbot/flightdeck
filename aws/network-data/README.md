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
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_tags"></a> [private\_tags](#input\_private\_tags) | Tags to identify private subnets | `map(string)` | <pre>{<br>  "kubernetes.io/role/internal-elb": "1"<br>}</pre> | no |
| <a name="input_public_tags"></a> [public\_tags](#input\_public\_tags) | Tags to identify public subnets | `map(string)` | <pre>{<br>  "kubernetes.io/role/elb": "1"<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to identify all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Tags to identify the VPC | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cidr_blocks"></a> [cidr\_blocks](#output\_cidr\_blocks) | CIDR blocks allowed in this network |
| <a name="output_cluster_names"></a> [cluster\_names](#output\_cluster\_names) | List of clusters which run in this network |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | Private subnets for this network |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | Private subnets for this network |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | AWS VPC for this network |
<!-- END_TF_DOCS -->
