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
| [aws_iam_role.argocd](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy_document.argocd_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_service_account_role_arn"></a> [argocd\_service\_account\_role\_arn](#input\_argocd\_service\_account\_role\_arn) | ARN of the IAM role used for ArgoCD's service account | `string` | n/a | yes |
| <a name="input_aws_tags"></a> [aws\_tags](#input\_aws\_tags) | Tags to be applied to created AWS resources | `map(string)` | `{}` | no |
| <a name="input_cluster_full_name"></a> [cluster\_full\_name](#input\_cluster\_full\_name) | Full name of the EKS cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_argocd_role"></a> [argocd\_role](#output\_argocd\_role) | IAM role ArgoCD assumes to deploy to this cluster |
| <a name="output_argocd_role_arn"></a> [argocd\_role\_arn](#output\_argocd\_role\_arn) | ARN of the IAM role ArgoCD assumes to deploy to this cluster |
| <a name="output_json"></a> [json](#output\_json) | JSON used for configuring a cluster in ArgoCD |
<!-- END_TF_DOCS -->