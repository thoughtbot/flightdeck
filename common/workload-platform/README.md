# Flightdeck Workload Platform

Installs the components necessary for running workloads:

* [CertManager](../cert-manager) for managing TLS certificates
* [ExternalDNS](../external-dns) for managing DNS entries for workloads
* [Istio](../istio) for securing traffic between workloads
* [Istio ingress gateway](../istio-ingress) for serving public traffic

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ../../common/cert-manager |  |
| <a name="module_cluster_autoscaler"></a> [cluster\_autoscaler](#module\_cluster\_autoscaler) | ../../common/cluster-autoscaler |  |
| <a name="module_external_dns"></a> [external\_dns](#module\_external\_dns) | ../../common/external-dns |  |
| <a name="module_federated_prometheus"></a> [federated\_prometheus](#module\_federated\_prometheus) | ../../common/prometheus-instance |  |
| <a name="module_flightdeck_prometheus"></a> [flightdeck\_prometheus](#module\_flightdeck\_prometheus) | ../../common/prometheus-instance |  |
| <a name="module_fluent_bit"></a> [fluent\_bit](#module\_fluent\_bit) | ../../common/fluent-bit |  |
| <a name="module_ingress_config"></a> [ingress\_config](#module\_ingress\_config) | ../../common/ingress-config |  |
| <a name="module_istio"></a> [istio](#module\_istio) | ../../common/istio |  |
| <a name="module_istio_ingress"></a> [istio\_ingress](#module\_istio\_ingress) | ../../common/istio-ingress |  |
| <a name="module_metrics_server"></a> [metrics\_server](#module\_metrics\_server) | ../../common/metrics-server |  |
| <a name="module_prometheus_adapter"></a> [prometheus\_adapter](#module\_prometheus\_adapter) | ../../common/prometheus-adapter |  |
| <a name="module_prometheus_operator"></a> [prometheus\_operator](#module\_prometheus\_operator) | ../../common/prometheus-operator |  |
| <a name="module_reloader"></a> [reloader](#module\_reloader) | ../../common/reloader |  |
| <a name="module_secret_store_driver"></a> [secret\_store\_driver](#module\_secret\_store\_driver) | ../../common/secret-store-driver |  |
| <a name="module_sloth"></a> [sloth](#module\_sloth) | ../../common/sloth |  |
| <a name="module_vertical_pod_autoscaler"></a> [vertical\_pod\_autoscaler](#module\_vertical\_pod\_autoscaler) | ../../common/vertical-pod-autoscaler |  |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.flightdeck](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.istio](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.kube_prometheus_stack](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_manager_values"></a> [cert\_manager\_values](#input\_cert\_manager\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of cert-manager to install | `string` | `null` | no |
| <a name="input_certificate_issuer"></a> [certificate\_issuer](#input\_certificate\_issuer) | YAML spec for certificate issuer; defaults to self-signed | `string` | `null` | no |
| <a name="input_cluster_autoscaler_values"></a> [cluster\_autoscaler\_values](#input\_cluster\_autoscaler\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_cluster_autoscaler_version"></a> [cluster\_autoscaler\_version](#input\_cluster\_autoscaler\_version) | Version of cluster-autoscaler to install | `string` | `null` | no |
| <a name="input_domain_names"></a> [domain\_names](#input\_domain\_names) | Domains which are allowed in this cluster | `list(string)` | `[]` | no |
| <a name="input_external_dns_enabled"></a> [external\_dns\_enabled](#input\_external\_dns\_enabled) | Set to false to disable External DNS | `bool` | `true` | no |
| <a name="input_external_dns_values"></a> [external\_dns\_values](#input\_external\_dns\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | Version of external-dns to install | `string` | `null` | no |
| <a name="input_federated_prometheus_values"></a> [federated\_prometheus\_values](#input\_federated\_prometheus\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_flightdeck_namespace"></a> [flightdeck\_namespace](#input\_flightdeck\_namespace) | Kubernetes namespace in which flightdeck should be installed | `string` | `"flightdeck"` | no |
| <a name="input_flightdeck_prometheus_values"></a> [flightdeck\_prometheus\_values](#input\_flightdeck\_prometheus\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_fluent_bit_enable_kubernetes_annotations"></a> [fluent\_bit\_enable\_kubernetes\_annotations](#input\_fluent\_bit\_enable\_kubernetes\_annotations) | Set to true to add Kubernetes annotations to log output | `bool` | `false` | no |
| <a name="input_fluent_bit_enable_kubernetes_labels"></a> [fluent\_bit\_enable\_kubernetes\_labels](#input\_fluent\_bit\_enable\_kubernetes\_labels) | Set to true to add Kubernetes labels to log output | `bool` | `false` | no |
| <a name="input_fluent_bit_values"></a> [fluent\_bit\_values](#input\_fluent\_bit\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_fluent_bit_version"></a> [fluent\_bit\_version](#input\_fluent\_bit\_version) | Version of Fluent Bit to install | `string` | `null` | no |
| <a name="input_istio_discovery_values"></a> [istio\_discovery\_values](#input\_istio\_discovery\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_istio_ingress_values"></a> [istio\_ingress\_values](#input\_istio\_ingress\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_istio_namespace"></a> [istio\_namespace](#input\_istio\_namespace) | Kubernetes namespace in which istio should be installed | `string` | `"istio-system"` | no |
| <a name="input_istio_version"></a> [istio\_version](#input\_istio\_version) | Version of Istio to install | `string` | `null` | no |
| <a name="input_metrics_server_values"></a> [metrics\_server\_values](#input\_metrics\_server\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_metrics_server_version"></a> [metrics\_server\_version](#input\_metrics\_server\_version) | Version of the Metrics Server to install | `string` | `null` | no |
| <a name="input_pagerduty_routing_key"></a> [pagerduty\_routing\_key](#input\_pagerduty\_routing\_key) | Routing key for delivering Pagerduty alerts | `string` | `null` | no |
| <a name="input_prometheus_adapter_values"></a> [prometheus\_adapter\_values](#input\_prometheus\_adapter\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_prometheus_adapter_version"></a> [prometheus\_adapter\_version](#input\_prometheus\_adapter\_version) | Version of prometheus adapter to install | `string` | `null` | no |
| <a name="input_prometheus_operator_values"></a> [prometheus\_operator\_values](#input\_prometheus\_operator\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_prometheus_operator_version"></a> [prometheus\_operator\_version](#input\_prometheus\_operator\_version) | Version of external-dns to install | `string` | `null` | no |
| <a name="input_reloader_values"></a> [reloader\_values](#input\_reloader\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_reloader_version"></a> [reloader\_version](#input\_reloader\_version) | Version of external-dns to install | `string` | `null` | no |
| <a name="input_secret_store_driver_values"></a> [secret\_store\_driver\_values](#input\_secret\_store\_driver\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_secret_store_driver_version"></a> [secret\_store\_driver\_version](#input\_secret\_store\_driver\_version) | Version of the secret store driver to install | `string` | `null` | no |
| <a name="input_vertical_pod_autoscaler_values"></a> [vertical\_pod\_autoscaler\_values](#input\_vertical\_pod\_autoscaler\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_flightdeck_namespace"></a> [flightdeck\_namespace](#output\_flightdeck\_namespace) | Kubernetes namespace created for Flightdeck |
<!-- END_TF_DOCS -->
