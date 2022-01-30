<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.1.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.1.2 |

## Resources

| Name | Type |
|------|------|
| [helm_release.base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.discovery](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_chart_name"></a> [base\_chart\_name](#input\_base\_chart\_name) | Name of the Istio base chart | `string` | `"base"` | no |
| <a name="input_base_chart_repository"></a> [base\_chart\_repository](#input\_base\_chart\_repository) | Helm repository containing the Istio base chart | `string` | `"https://flightdeck-charts.s3.amazonaws.com/istio"` | no |
| <a name="input_base_chart_values"></a> [base\_chart\_values](#input\_base\_chart\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_discovery_chart_name"></a> [discovery\_chart\_name](#input\_discovery\_chart\_name) | Name of the Istio discovery chart | `string` | `"istio-discovery"` | no |
| <a name="input_discovery_chart_repository"></a> [discovery\_chart\_repository](#input\_discovery\_chart\_repository) | Helm repository containing the Istio discovery chart | `string` | `"https://flightdeck-charts.s3.amazonaws.com/istio"` | no |
| <a name="input_discovery_chart_values"></a> [discovery\_chart\_values](#input\_discovery\_chart\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_istio_version"></a> [istio\_version](#input\_istio\_version) | Version of Istio to be installed | `string` | `null` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes namespace in which secrets should be created | `string` | `"istio-system"` | no |
<!-- END_TF_DOCS -->