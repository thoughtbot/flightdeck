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
| [aws_sns_topic.alarms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sns_topic) | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet_ids.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_subnet_ids.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_topic_name"></a> [alarm\_topic\_name](#input\_alarm\_topic\_name) | Name of the SNS topic to which alarms should be sent | `string` | `null` | no |
| <a name="input_private_tags"></a> [private\_tags](#input\_private\_tags) | Tags to identify private subnets | `map(string)` | <pre>{<br>  "kubernetes.io/role/internal-elb": "1"<br>}</pre> | no |
| <a name="input_public_tags"></a> [public\_tags](#input\_public\_tags) | Tags to identify public subnets | `map(string)` | <pre>{<br>  "kubernetes.io/role/elb": "1"<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to identify all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Tags to identify the VPC | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_actions"></a> [alarm\_actions](#output\_alarm\_actions) | AWS actions invoked on alarms in this network |
| <a name="output_cidr_blocks"></a> [cidr\_blocks](#output\_cidr\_blocks) | CIDR blocks allowed in this network |
| <a name="output_cluster_names"></a> [cluster\_names](#output\_cluster\_names) | List of clusters which run in this network |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnets for this network |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Private subnets for this network |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | AWS VPC for this network |
<!-- END_TF_DOCS -->