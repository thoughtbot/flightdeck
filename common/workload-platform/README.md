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
| <a name="module_istio"></a> [istio](#module\_istio) | ../../common/istio |  |
| <a name="module_istio_charts"></a> [istio\_charts](#module\_istio\_charts) | ../../common/istio-charts |  |
| <a name="module_istio_ingress"></a> [istio\_ingress](#module\_istio\_ingress) | ../../common/istio-ingress |  |
| <a name="module_prometheus_operator"></a> [prometheus\_operator](#module\_prometheus\_operator) | ../../common/prometheus-operator |  |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.flightdeck](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.istio](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_manager_values"></a> [cert\_manager\_values](#input\_cert\_manager\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of cert-manager to install | `string` | `"v1.3.1"` | no |
| <a name="input_cluster_autoscaler_values"></a> [cluster\_autoscaler\_values](#input\_cluster\_autoscaler\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_cluster_autoscaler_version"></a> [cluster\_autoscaler\_version](#input\_cluster\_autoscaler\_version) | Version of cluster-autoscaler to install | `string` | `"9.7.0"` | no |
| <a name="input_external_dns_values"></a> [external\_dns\_values](#input\_external\_dns\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | Version of external-dns to install | `string` | `"5.0.0"` | no |
| <a name="input_flightdeck_namespace"></a> [flightdeck\_namespace](#input\_flightdeck\_namespace) | Kubernetes namespace in which flightdeck should be installed | `string` | `"flightdeck"` | no |
| <a name="input_istio_ingress_values"></a> [istio\_ingress\_values](#input\_istio\_ingress\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_istio_namespace"></a> [istio\_namespace](#input\_istio\_namespace) | Kubernetes namespace in which istio should be installed | `string` | `"istio-system"` | no |
| <a name="input_istio_version"></a> [istio\_version](#input\_istio\_version) | Version of Istio to install | `string` | `"1.10.0"` | no |
| <a name="input_prometheus_operator_values"></a> [prometheus\_operator\_values](#input\_prometheus\_operator\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_prometheus_operator_version"></a> [prometheus\_operator\_version](#input\_prometheus\_operator\_version) | Version of external-dns to install | `string` | `"16.0.1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_flightdeck_namespace"></a> [flightdeck\_namespace](#output\_flightdeck\_namespace) | Kubernetes namespace created for Flightdeck |
<!-- END_TF_DOCS -->
