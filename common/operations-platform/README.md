# Flightdeck Operations Platform

Installs all components of the [Workload Platform], as well as:

* [Dex](../dex) for single sign-on for platform services

[Workload Platform](../workload-platform)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dex"></a> [dex](#module\_dex) | ../../common/dex |  |
| <a name="module_ui"></a> [ui](#module\_ui) | ../../common/ui |  |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dex_extra_secrets"></a> [dex\_extra\_secrets](#input\_dex\_extra\_secrets) | Extra values to append to the Dex secret | `map(string)` | `{}` | no |
| <a name="input_dex_values"></a> [dex\_values](#input\_dex\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_flightdeck_namespace"></a> [flightdeck\_namespace](#input\_flightdeck\_namespace) | Kubernetes namespace in which flightdeck should be installed | `string` | `"flightdeck"` | no |
| <a name="input_host"></a> [host](#input\_host) | Base hostname for flightdeck UI | `string` | n/a | yes |
| <a name="input_ui_values"></a> [ui\_values](#input\_ui\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_url"></a> [url](#output\_url) | URL at which Flightdeck is reachable |
<!-- END_TF_DOCS -->
