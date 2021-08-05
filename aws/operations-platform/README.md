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
| <a name="module_aws_load_balancer_controller"></a> [aws\_load\_balancer\_controller](#module\_aws\_load\_balancer\_controller) | ../load-balancer-controller |  |
| <a name="module_cluster_name"></a> [cluster\_name](#module\_cluster\_name) | ../cluster-name |  |
| <a name="module_common_platform"></a> [common\_platform](#module\_common\_platform) | ../../common/operations-platform |  |
| <a name="module_network"></a> [network](#module\_network) | ../network-data |  |
| <a name="module_workload_values"></a> [workload\_values](#module\_workload\_values) | ../workload-values |  |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_roles"></a> [admin\_roles](#input\_admin\_roles) | Additional IAM roles which have admin cluster privileges | `list(string)` | `[]` | no |
| <a name="input_aws_load_balancer_controller_values"></a> [aws\_load\_balancer\_controller\_values](#input\_aws\_load\_balancer\_controller\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_aws_load_balancer_controller_version"></a> [aws\_load\_balancer\_controller\_version](#input\_aws\_load\_balancer\_controller\_version) | Version of aws-load-balancer-controller to install | `string` | `"1.2.3"` | no |
| <a name="input_aws_namespace"></a> [aws\_namespace](#input\_aws\_namespace) | Prefix to be applied to created AWS resources | `list(string)` | `[]` | no |
| <a name="input_aws_tags"></a> [aws\_tags](#input\_aws\_tags) | Tags to be applied to created AWS resources | `map(string)` | `{}` | no |
| <a name="input_cert_manager_values"></a> [cert\_manager\_values](#input\_cert\_manager\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_certificate_issuer"></a> [certificate\_issuer](#input\_certificate\_issuer) | YAML spec for certificate issuer; defaults to self-signed | `string` | `null` | no |
| <a name="input_cluster_autoscaler_values"></a> [cluster\_autoscaler\_values](#input\_cluster\_autoscaler\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_custom_roles"></a> [custom\_roles](#input\_custom\_roles) | Additional IAM roles which have custom cluster privileges | `map(string)` | `{}` | no |
| <a name="input_dex_extra_secrets"></a> [dex\_extra\_secrets](#input\_dex\_extra\_secrets) | Extra values to append to the Dex secret | `map(string)` | `{}` | no |
| <a name="input_dex_values"></a> [dex\_values](#input\_dex\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_domain_names"></a> [domain\_names](#input\_domain\_names) | Domains which are allowed in this cluster | `list(string)` | `[]` | no |
| <a name="input_external_dns_enabled"></a> [external\_dns\_enabled](#input\_external\_dns\_enabled) | Set to true to enable External DNS | `bool` | `false` | no |
| <a name="input_external_dns_values"></a> [external\_dns\_values](#input\_external\_dns\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_fluent_bit_values"></a> [fluent\_bit\_values](#input\_fluent\_bit\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_host"></a> [host](#input\_host) | Base hostname for flightdeck UI | `string` | n/a | yes |
| <a name="input_hosted_zones"></a> [hosted\_zones](#input\_hosted\_zones) | Hosted zones this cluster is allowed to update | `list(string)` | `[]` | no |
| <a name="input_istio_ingress_values"></a> [istio\_ingress\_values](#input\_istio\_ingress\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes namespace in which resources should be created | `string` | `"flightdeck"` | no |
| <a name="input_logs_retention_in_days"></a> [logs\_retention\_in\_days](#input\_logs\_retention\_in\_days) | Number of days for which logs should be retained | `number` | `30` | no |
| <a name="input_node_roles"></a> [node\_roles](#input\_node\_roles) | Additional node roles which can join the cluster | `list(string)` | `[]` | no |
| <a name="input_pagerduty_parameter"></a> [pagerduty\_parameter](#input\_pagerduty\_parameter) | SSM parameter containing the Pagerduty routing key | `string` | `null` | no |
| <a name="input_prometheus_adapter_values"></a> [prometheus\_adapter\_values](#input\_prometheus\_adapter\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_prometheus_operator_values"></a> [prometheus\_operator\_values](#input\_prometheus\_operator\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
