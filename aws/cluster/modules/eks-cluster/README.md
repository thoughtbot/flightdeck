<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.74.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.74.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.eks](https://registry.terraform.io/providers/hashicorp/aws/5.74.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/5.74.0/docs/resources/eks_cluster) | resource |
| [aws_iam_role.control_plane](https://registry.terraform.io/providers/hashicorp/aws/5.74.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.control_plane](https://registry.terraform.io/providers/hashicorp/aws/5.74.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.control_plane](https://registry.terraform.io/providers/hashicorp/aws/5.74.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/5.74.0/docs/resources/security_group_rule) | resource |
| [aws_iam_policy_document.eks_assume_role](https://registry.terraform.io/providers/hashicorp/aws/5.74.0/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/5.74.0/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auth_mode"></a> [auth\_mode](#input\_auth\_mode) | Authentiation mode associated with the cluster Access config | `string` | `"API_AND_CONFIG_MAP"` | no |
| <a name="input_enable_cluster_creator_admin_permission"></a> [enable\_cluster\_creator\_admin\_permission](#input\_enable\_cluster\_creator\_admin\_permission) | Bootstrap access config values to the cluster | `bool` | `false` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | Which EKS control plane log types to enable | `list(string)` | <pre>[<br>  "api",<br>  "audit"<br>]</pre> | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Kubernetes version to deploy | `string` | n/a | yes |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | How many days until control plane logs are purged | `number` | `7` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for this EKS cluster | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Prefix to be applied to created resources | `list(string)` | `[]` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnets which should be used by this cluster | `list(string)` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | Public subnets which should be used by this cluster | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to created resources | `map(string)` | `{}` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | VPC in which this cluster should run | `object({ id = string })` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance"></a> [instance](#output\_instance) | The created EKS cluster |
<!-- END_TF_DOCS -->