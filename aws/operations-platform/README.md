# AWS Operations Platform

Deploys the [Flightdeck Operations Platform] to an EKS cluster on AWS.

Appropriate IAM roles for service accounts are configured for CertManager,
Cluster Autoscaler, and ExternalDNS.

[Flightdeck Operations Platform]: ../../common/operations-platform

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
| <a name="module_common_platform"></a> [common\_platform](#module\_common\_platform) | ../../common/operations-platform |  |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dex_extra_secrets"></a> [dex\_extra\_secrets](#input\_dex\_extra\_secrets) | Extra values to append to the Dex secret | `map(string)` | `{}` | no |
| <a name="input_dex_values"></a> [dex\_values](#input\_dex\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_host"></a> [host](#input\_host) | Base hostname for flightdeck UI | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
