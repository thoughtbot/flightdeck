# AWS Load Balancer Controller

Installs [AWS Load Balancer Controller] for this cluster and pre-configures a
target group bound to the Istio ingress gateway service.

[AWS Load Balancer Controller]: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.1.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.74.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.1.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_service_account_role"></a> [service\_account\_role](#module\_service\_account\_role) | ../../../service-account-role | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.ingress_config](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_lb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_target_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_namespace"></a> [aws\_namespace](#input\_aws\_namespace) | Prefix to be applied to created resources | `list(string)` | `[]` | no |
| <a name="input_aws_tags"></a> [aws\_tags](#input\_aws\_tags) | Tags to be applied to created resources | `map(string)` | `{}` | no |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Helm chart to install | `string` | `null` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Helm repository containing the chart | `string` | `null` | no |
| <a name="input_chart_values"></a> [chart\_values](#input\_chart\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of chart to install | `string` | `null` | no |
| <a name="input_cluster_full_name"></a> [cluster\_full\_name](#input\_cluster\_full\_name) | Full name of the cluster in which the chart is installed | `string` | n/a | yes |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes namespace in which resources will be written | `string` | `"default"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the release | `string` | `"aws-load-balancer-controller"` | no |
| <a name="input_oidc_issuer"></a> [oidc\_issuer](#input\_oidc\_issuer) | OIDC issuer of the Kubernetes cluster | `string` | n/a | yes |
| <a name="input_target_group_name"></a> [target\_group\_name](#input\_target\_group\_name) | Override the name of the target group for this cluster | `string` | `null` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | CIDR block for the AWS VPC in which the load balancer runs | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
