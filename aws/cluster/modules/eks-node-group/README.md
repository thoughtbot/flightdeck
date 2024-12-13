<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capacity_type"></a> [capacity\_type](#input\_capacity\_type) | Allow values: ON\_DEMAND (default), SPOT | `string` | `"ON_DEMAND"` | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | Cluster which this node group should join | `object({ name = string })` | n/a | yes |
| <a name="input_enforce_imdsv2"></a> [enforce\_imdsv2](#input\_enforce\_imdsv2) | Whether to enforce IMDSv2 on the launch template | `bool` | `false` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | EC2 instance types allowed in this node group | `list(string)` | <pre>[<br>  "t3.medium"<br>]</pre> | no |
| <a name="input_label_node_role"></a> [label\_node\_role](#input\_label\_node\_role) | Role to struct kubernetes scheduler to use for this node group | `string` | `"general"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to be applied to created resources | `map(string)` | `{}` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum number of nodes in this group | `number` | n/a | yes |
| <a name="input_max_unavailable"></a> [max\_unavailable](#input\_max\_unavailable) | Maximum number of nodes that can be unavailable during a rolling update | `number` | `1` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum number of nodes in this group | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for this EKS node group | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Prefix to be applied to created resources | `list(string)` | `[]` | no |
| <a name="input_role"></a> [role](#input\_role) | IAM role nodes in this group will assume | `object({ arn = string })` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets in which the node group should run | `list(object({ id = string, availability_zone = string }))` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to created resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instances"></a> [instances](#output\_instances) | The created node groups |
<!-- END_TF_DOCS -->