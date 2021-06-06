<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.charts](https://registry.terraform.io/providers/hashicorp/null/3.1.0/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_arch"></a> [arch](#input\_arch) | Architecture to download | `string` | `"amd64"` | no |
| <a name="input_download_base_uri"></a> [download\_base\_uri](#input\_download\_base\_uri) | Base URI for downloading Istio release | `string` | `"https://github.com/istio/istio/releases/download"` | no |
| <a name="input_istio_version"></a> [istio\_version](#input\_istio\_version) | Version of Istio to download | `string` | n/a | yes |
| <a name="input_os"></a> [os](#input\_os) | OS to download | `string` | `"linux"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_chart_path"></a> [chart\_path](#output\_chart\_path) | Path at which charts are available |
<!-- END_TF_DOCS -->