<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_argocd_service_account_role"></a> [argocd\_service\_account\_role](#module\_argocd\_service\_account\_role) | ../service-account-role |  |

## Resources

| Name | Type |
|------|------|
| [kubernetes_secret.cluster](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [aws_iam_policy_document.argocd_service_account_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_namespace"></a> [aws\_namespace](#input\_aws\_namespace) | Prefix to be applied to created AWS resources | `list(string)` | `[]` | no |
| <a name="input_aws_tags"></a> [aws\_tags](#input\_aws\_tags) | Tags to be applied to created AWS resources | `map(string)` | `{}` | no |
| <a name="input_cluster_configs"></a> [cluster\_configs](#input\_cluster\_configs) | ArgoCD configuration objects for workload clusters | <pre>list(object({<br>    name   = string<br>    server = string<br>    config = object({<br>      awsAuthConfig = object({<br>        clusterName = string<br>        roleARN     = string<br>      })<br>      tlsClientConfig = object({<br>        caData = string<br>      })<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes namespace in which resources should be created | `string` | n/a | yes |
| <a name="input_oidc_issuer"></a> [oidc\_issuer](#input\_oidc\_issuer) | OIDC issuer of the operations Kubernetes cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the AWS IAM role created for service accounts |
<!-- END_TF_DOCS -->