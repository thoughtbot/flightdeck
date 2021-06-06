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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.discovery](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_chart_values"></a> [base\_chart\_values](#input\_base\_chart\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_chart_path"></a> [chart\_path](#input\_chart\_path) | Path at which Istio charts can be found | `string` | n/a | yes |
| <a name="input_discovery_chart_values"></a> [discovery\_chart\_values](#input\_discovery\_chart\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_istio_version"></a> [istio\_version](#input\_istio\_version) | Version of Istio to be installed | `string` | n/a | yes |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes namespace in which secrets should be created | `string` | `"istio-system"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->