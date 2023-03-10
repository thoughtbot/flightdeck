<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.4 |

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Helm chart to install | `string` | `null` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Helm repository containing the chart | `string` | `null` | no |
| <a name="input_chart_values"></a> [chart\_values](#input\_chart\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of chart to be installed | `string` | `null` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes namespace in which the chart should be installed | `string` | `"kube-system"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of this Helm release | `string` | `"csi-secrets-store-provider-aws"` | no |
<!-- END_TF_DOCS -->