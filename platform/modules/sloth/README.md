# Sloth

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
| [helm_release.sloth](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Helm chart to install | `string` | `"sloth"` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Helm repository containing the chart | `string` | `"https://flightdeck-charts.s3.amazonaws.com/sloth"` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes namespace in which the gateway should be installed | `string` | `"flightdeck"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of this Helm release | `string` | `"sloth"` | no |
| <a name="input_sloth_version"></a> [sloth\_version](#input\_sloth\_version) | Version of Sloth Chart to be installed | `string` | `"0.3.0"` | no |
<!-- END_TF_DOCS -->