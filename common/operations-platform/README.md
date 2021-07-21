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
| <a name="module_workload_platform"></a> [workload\_platform](#module\_workload\_platform) | ../workload-platform |  |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_manager_values"></a> [cert\_manager\_values](#input\_cert\_manager\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of cert-manager to install | `string` | `"v1.3.1"` | no |
| <a name="input_certificate_email"></a> [certificate\_email](#input\_certificate\_email) | Email to be notified of certificate expiration and renewal | `string` | n/a | yes |
| <a name="input_certificate_solvers"></a> [certificate\_solvers](#input\_certificate\_solvers) | YAML spec for solving ACME challenges | `string` | n/a | yes |
| <a name="input_cluster_autoscaler_values"></a> [cluster\_autoscaler\_values](#input\_cluster\_autoscaler\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_cluster_autoscaler_version"></a> [cluster\_autoscaler\_version](#input\_cluster\_autoscaler\_version) | Version of cluster-autoscaler to install | `string` | `"9.7.0"` | no |
| <a name="input_dex_extra_secrets"></a> [dex\_extra\_secrets](#input\_dex\_extra\_secrets) | Extra values to append to the Dex secret | `map(string)` | `{}` | no |
| <a name="input_dex_values"></a> [dex\_values](#input\_dex\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_domain_names"></a> [domain\_names](#input\_domain\_names) | Domains which are allowed in this cluster | `list(string)` | `[]` | no |
| <a name="input_external_dns_values"></a> [external\_dns\_values](#input\_external\_dns\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | Version of external-dns to install | `string` | `"5.0.0"` | no |
| <a name="input_flightdeck_namespace"></a> [flightdeck\_namespace](#input\_flightdeck\_namespace) | Kubernetes namespace in which flightdeck should be installed | `string` | `"flightdeck"` | no |
| <a name="input_fluent_bit_values"></a> [fluent\_bit\_values](#input\_fluent\_bit\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_fluent_bit_version"></a> [fluent\_bit\_version](#input\_fluent\_bit\_version) | Version of Fluent Bit to install | `string` | `"0.15.1"` | no |
| <a name="input_host"></a> [host](#input\_host) | Base hostname for flightdeck UI | `string` | n/a | yes |
| <a name="input_istio_ingress_values"></a> [istio\_ingress\_values](#input\_istio\_ingress\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_istio_namespace"></a> [istio\_namespace](#input\_istio\_namespace) | Kubernetes namespace in which istio should be installed | `string` | `"istio-system"` | no |
| <a name="input_istio_version"></a> [istio\_version](#input\_istio\_version) | Version of Istio to install | `string` | `"1.10.0"` | no |
| <a name="input_pagerduty_routing_key"></a> [pagerduty\_routing\_key](#input\_pagerduty\_routing\_key) | Routing key for delivering Pagerduty alerts | `string` | `null` | no |
| <a name="input_prometheus_adapter_values"></a> [prometheus\_adapter\_values](#input\_prometheus\_adapter\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_prometheus_adapter_version"></a> [prometheus\_adapter\_version](#input\_prometheus\_adapter\_version) | Version of external-dns to install | `string` | `"2.14.1"` | no |
| <a name="input_prometheus_operator_values"></a> [prometheus\_operator\_values](#input\_prometheus\_operator\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_prometheus_operator_version"></a> [prometheus\_operator\_version](#input\_prometheus\_operator\_version) | Version of external-dns to install | `string` | `"16.0.1"` | no |
| <a name="input_ui_values"></a> [ui\_values](#input\_ui\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Kubernetes namespace created for Flightdeck |
| <a name="output_url"></a> [url](#output\_url) | URL at which Flightdeck is reachable |
<!-- END_TF_DOCS -->
