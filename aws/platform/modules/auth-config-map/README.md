<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.breakglass](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.breakglass](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [null_resource.aws_auth_patch](https://registry.terraform.io/providers/hashicorp/null/3.1.0/docs/resources/resource) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.breakglass](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.breakglass_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_roles"></a> [admin\_roles](#input\_admin\_roles) | Role ARNs which have admin privileges within the cluster | `list(string)` | n/a | yes |
| <a name="input_cluster_full_name"></a> [cluster\_full\_name](#input\_cluster\_full\_name) | Full name of the EKS cluster | `string` | n/a | yes |
| <a name="input_custom_groups"></a> [custom\_groups](#input\_custom\_groups) | RBAC groups to be assigned to an IAM role for custom privileges within the cluster | `map(list(string))` | `{}` | no |
| <a name="input_custom_roles"></a> [custom\_roles](#input\_custom\_roles) | Role ARNs which have custom privileges within the cluster | `map(string)` | `{}` | no |
| <a name="input_node_roles"></a> [node\_roles](#input\_node\_roles) | Roles for EKS node groups in this cluster | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_breakglass_role_arn"></a> [breakglass\_role\_arn](#output\_breakglass\_role\_arn) | ARN for a breakglass role in case of cluster lockout |
<!-- END_TF_DOCS -->