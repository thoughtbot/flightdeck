# AWS Cluster

Creates a Kubernetes cluster capable of running the Flightdeck platform using
Terraform and EKS.

Components:

* [VPC](../vpc)
* [NAT gateway](../nat-gateway)
* [EKS cluster](../eks-cluster)
* [Node groups](../eks-node-group)

An [OIDC provider](../k8s-oidc-provider) is configured to enable [IRSA].

[IRSA]: https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/setting-up-enable-IAM.html

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nat_gateway"></a> [nat\_gateway](#module\_nat\_gateway) | ./modules/nat-gateway | n/a |
| <a name="module_private_subnet_routes"></a> [private\_subnet\_routes](#module\_private\_subnet\_routes) | ./modules/private-subnet-routes | n/a |
| <a name="module_private_subnets"></a> [private\_subnets](#module\_private\_subnets) | ./modules/private-subnets | n/a |
| <a name="module_public_subnet_routes"></a> [public\_subnet\_routes](#module\_public\_subnet\_routes) | ./modules/public-subnet-routes | n/a |
| <a name="module_public_subnets"></a> [public\_subnets](#module\_public\_subnets) | ./modules/public-subnets | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_names"></a> [cluster\_names](#input\_cluster\_names) | List of clusters which run in this network | `list(string)` | `[]` | no |
| <a name="input_create_internet_gateway"></a> [create\_internet\_gateway](#input\_create\_internet\_gateway) | Set to false to disable creation of an internet gateway | `bool` | `true` | no |
| <a name="input_create_nat_gateways"></a> [create\_nat\_gateways](#input\_create\_nat\_gateways) | Set to false to disable creation of NAT gateways | `bool` | `true` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Set to false to disable creation of the VPC | `bool` | `true` | no |
| <a name="input_enable_flow_logs"></a> [enable\_flow\_logs](#input\_enable\_flow\_logs) | Set to true to enable VPC flow logs | `bool` | `false` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Set to false to disable IPV6 | `bool` | `false` | no |
| <a name="input_enable_public_ip_on_launch"></a> [enable\_public\_ip\_on\_launch](#input\_enable\_public\_ip\_on\_launch) | Set to true to auto-assign IP addresses in public subnets | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for this network | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Prefix to be applied to created resources | `list(string)` | `[]` | no |
| <a name="input_nat_availability_zones"></a> [nat\_availability\_zones](#input\_nat\_availability\_zones) | Availability zones in which NAT should be provided | `list(string)` | n/a | yes |
| <a name="input_private_subnet_cidr_blocks"></a> [private\_subnet\_cidr\_blocks](#input\_private\_subnet\_cidr\_blocks) | CIDR block for each availability zone | `map(string)` | n/a | yes |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | Tags to be applied to private subnets | `map(string)` | `{}` | no |
| <a name="input_public_subnet_cidr_blocks"></a> [public\_subnet\_cidr\_blocks](#input\_public\_subnet\_cidr\_blocks) | CIDR block for each availability zone | `map(string)` | n/a | yes |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | Tags to be applied to public subnets | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to all created resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | CIDR block to be used for the VPC, such as 10.0.0.0/16 | `string` | n/a | yes |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Tags to be applied to the VPC | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_names"></a> [cluster\_names](#output\_cluster\_names) | List of clusters which run in this network |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the AWS VPC |
<!-- END_TF_DOCS -->
