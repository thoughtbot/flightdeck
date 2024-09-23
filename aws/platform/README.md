# Platform for AWS

Deploys the [Flightdeck Platform] to an EKS cluster on AWS.

The following components are included:

- [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/)
- [AWS Secrets Store Provider](https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrating_csi_driver.html)
- [CertManager](https://cert-manager.io/)
- [Cluster Autoscaler](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/README.md)
- [Fluent Bit for CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-logs-FluentBit.html)
- [Istio](https://istio.io/)
- [Metrics Server](https://github.com/kubernetes-sigs/metrics-server)
- [Prometheus Adapter](https://github.com/kubernetes-sigs/prometheus-adapter)
- [Prometheus Operator](https://prometheus-operator.dev/)
- [Reloader](https://github.com/stakater/Reloader)
- [Secrets Store CSI Driver](https://secrets-store-csi-driver.sigs.k8s.io/)
- [Sloth](https://sloth.dev/)
- [Vertical Pod Autoscaler](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md)

Appropriate IAM roles for service accounts are configured for Prometheus,
Cluster Autoscaler, Cert Manager, External DNS, and Fluent Bit.

[flightdeck platform]: ../../platform

## Deployment

You need a compatible EKS cluster to deploy the platform for AWS. You can use
the [cluster module] to create compatible EKS clusters.

[cluster module]: ../cluster/README.md

```terraform
module "workload_platform" {
  source = "github.com/thoughtbot/flightdeck//aws/workload-platform?ref=v0.5.0"

  # Name of the EKS cluster to which the platform will be deployed
  cluster_name = "example-production-v1"

  # These roles will be added to the `aws-auth` ConfigMap as admins.
  # See the [EKS IAM documentation] for more information.
  admin_roles = ["arn:aws:iam::123456789012:role/devops"]

  # An Istio ingress gateway is created as part of the platform. Domains listed
  # here will be added to the gateway and certificate.
  domain_names = ["example.com", "www.example.com"]

  # Any tags you want to add to created resources like IAM roles.
  aws_tags = { Module = "platform/production-v1" }
}

# The Helm and Kubernetes providers must be set up to connect to your cluster.

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.kubernetes.token
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.kubernetes.token
}

data "aws_eks_cluster_auth" "kubernetes" {
  name = data.aws_eks_cluster.this.name
}

data "aws_eks_cluster" "this" {
  name = "example-production-v1"
}
```

[eks iam documentation]: https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html

## Preventing Cluster Lockout

You are required to pass at least one role to be designated as a cluster
administrator role. However, in case this role somehow loses admin privileges in
the cluster, Flightdeck creates a special "breakglass" role you can use to
regain access. This role is disabled by default and is always added as an admin
regardless of what other roles you provide.

If you have the following cluster:

```
module "workload_platform" {
  source = "github.com/thoughtbot/flightdeck//aws/platform?ref=v0.6.0"

  # Name of the EKS cluster to which the platform will be deployed
  cluster_name = "example-production-v1"
}
```

The role will be named "example-production-v1-breakglass" and is disabled by
default. To enable it, change the "Enabled" tag on the role to "True":

```
aws iam tag-role \
  --role-name example-production-v1-breakglass \
  --tags Key=Enabled,Value=True
```

You can then use it to manually edit the aws-auth ConfigMap:

```
% aws eks update-kubeconfig \
  --name example-production-v1 \
  --alias breakglass \
  --role-arn arn:aws:iam:ACCOUNT_ID::role/example-production-v1
% kubectl edit -n kube-system configmap aws-auth
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_auth_config_map"></a> [auth\_config\_map](#module\_auth\_config\_map) | ./modules/auth-config-map | n/a |
| <a name="module_aws_ebs_csi_driver"></a> [aws\_ebs\_csi\_driver](#module\_aws\_ebs\_csi\_driver) | ./modules/aws-ebs-csi-driver | n/a |
| <a name="module_aws_load_balancer_controller"></a> [aws\_load\_balancer\_controller](#module\_aws\_load\_balancer\_controller) | ./modules/load-balancer-controller | n/a |
| <a name="module_cloudwatch_logs"></a> [cloudwatch\_logs](#module\_cloudwatch\_logs) | ./modules/cloudwatch-logs | n/a |
| <a name="module_cluster_autoscaler_service_account_role"></a> [cluster\_autoscaler\_service\_account\_role](#module\_cluster\_autoscaler\_service\_account\_role) | ./modules/cluster-autoscaler-service-account-role | n/a |
| <a name="module_cluster_name"></a> [cluster\_name](#module\_cluster\_name) | ../cluster-name | n/a |
| <a name="module_common_platform"></a> [common\_platform](#module\_common\_platform) | ../../platform | n/a |
| <a name="module_dns_service_account_role"></a> [dns\_service\_account\_role](#module\_dns\_service\_account\_role) | ./modules/dns-service-account-role | n/a |
| <a name="module_ebs_csi_driver_service_account_role"></a> [ebs\_csi\_driver\_service\_account\_role](#module\_ebs\_csi\_driver\_service\_account\_role) | ./modules/ebs-csi-driver-service-account-role | n/a |
| <a name="module_network"></a> [network](#module\_network) | ../network-data | n/a |
| <a name="module_prometheus_service_account_role"></a> [prometheus\_service\_account\_role](#module\_prometheus\_service\_account\_role) | ./modules/prometheus-service-account-role | n/a |
| <a name="module_secrets_store_provider"></a> [secrets\_store\_provider](#module\_secrets\_store\_provider) | ./modules/secrets-store-provider | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_ssm_parameter.node_role_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.oidc_issuer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.opsgenie_api_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.pagerduty_routing_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_roles"></a> [admin\_roles](#input\_admin\_roles) | Additional IAM roles which have admin cluster privileges | `list(string)` | n/a | yes |
| <a name="input_aws_ebs_csi_driver_values"></a> [aws\_ebs\_csi\_driver\_values](#input\_aws\_ebs\_csi\_driver\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_aws_ebs_csi_driver_version"></a> [aws\_ebs\_csi\_driver\_version](#input\_aws\_ebs\_csi\_driver\_version) | Version of the ebs csi driver to install | `string` | `null` | no |
| <a name="input_aws_load_balancer_controller_values"></a> [aws\_load\_balancer\_controller\_values](#input\_aws\_load\_balancer\_controller\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_aws_load_balancer_controller_version"></a> [aws\_load\_balancer\_controller\_version](#input\_aws\_load\_balancer\_controller\_version) | Version of aws-load-balancer-controller to install | `string` | `null` | no |
| <a name="input_aws_namespace"></a> [aws\_namespace](#input\_aws\_namespace) | Prefix to be applied to created AWS resources | `list(string)` | `[]` | no |
| <a name="input_aws_tags"></a> [aws\_tags](#input\_aws\_tags) | Tags to be applied to created AWS resources | `map(string)` | `{}` | no |
| <a name="input_cert_manager_values"></a> [cert\_manager\_values](#input\_cert\_manager\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_certificate_issuer"></a> [certificate\_issuer](#input\_certificate\_issuer) | YAML spec for certificate issuer; defaults to self-signed | `string` | `null` | no |
| <a name="input_cluster_autoscaler_values"></a> [cluster\_autoscaler\_values](#input\_cluster\_autoscaler\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_custom_roles"></a> [custom\_roles](#input\_custom\_roles) | Additional IAM roles which have custom cluster privileges | `map(string)` | `{}` | no |
| <a name="input_domain_names"></a> [domain\_names](#input\_domain\_names) | Domains which are allowed in this cluster | `list(string)` | `[]` | no |
| <a name="input_external_dns_enabled"></a> [external\_dns\_enabled](#input\_external\_dns\_enabled) | Set to true to enable External DNS | `bool` | `false` | no |
| <a name="input_external_dns_values"></a> [external\_dns\_values](#input\_external\_dns\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_federated_prometheus_values"></a> [federated\_prometheus\_values](#input\_federated\_prometheus\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_flightdeck_prometheus_values"></a> [flightdeck\_prometheus\_values](#input\_flightdeck\_prometheus\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_fluent_bit_enable_kubernetes_annotations"></a> [fluent\_bit\_enable\_kubernetes\_annotations](#input\_fluent\_bit\_enable\_kubernetes\_annotations) | Set to true to add Kubernetes annotations to log output | `bool` | `false` | no |
| <a name="input_fluent_bit_enable_kubernetes_labels"></a> [fluent\_bit\_enable\_kubernetes\_labels](#input\_fluent\_bit\_enable\_kubernetes\_labels) | Set to true to add Kubernetes labels to log output | `bool` | `false` | no |
| <a name="input_fluent_bit_values"></a> [fluent\_bit\_values](#input\_fluent\_bit\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_hosted_zones"></a> [hosted\_zones](#input\_hosted\_zones) | Hosted zones this cluster is allowed to update | `list(string)` | `[]` | no |
| <a name="input_istio_base_values"></a> [istio\_base\_values](#input\_istio\_base\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_istio_ingress_values"></a> [istio\_ingress\_values](#input\_istio\_ingress\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_istiod_values"></a> [istiod\_values](#input\_istiod\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes namespace in which resources should be created | `string` | `"flightdeck"` | no |
| <a name="input_logs_retention_in_days"></a> [logs\_retention\_in\_days](#input\_logs\_retention\_in\_days) | Number of days for which logs should be retained | `number` | `30` | no |
| <a name="input_metrics_server_values"></a> [metrics\_server\_values](#input\_metrics\_server\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_metrics_server_version"></a> [metrics\_server\_version](#input\_metrics\_server\_version) | Version of the Metrics Server to install | `string` | `null` | no |
| <a name="input_monitoring_account_id"></a> [monitoring\_account\_id](#input\_monitoring\_account\_id) | ID of the account in which monitoring resources are found | `string` | `null` | no |
| <a name="input_node_roles"></a> [node\_roles](#input\_node\_roles) | Additional node roles which can join the cluster | `list(string)` | `[]` | no |
| <a name="input_opsgenie_parameter"></a> [opsgenie\_parameter](#input\_opsgenie\_parameter) | SSM parameter containing the OpsGenie api key | `string` | `null` | no |
| <a name="input_pagerduty_parameter"></a> [pagerduty\_parameter](#input\_pagerduty\_parameter) | SSM parameter containing the Pagerduty routing key | `string` | `null` | no |
| <a name="input_prometheus_adapter_values"></a> [prometheus\_adapter\_values](#input\_prometheus\_adapter\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_prometheus_data_source"></a> [prometheus\_data\_source](#input\_prometheus\_data\_source) | Prometheus datasource object with necessary details required to connect to the Prometheus workspace for centralized ingestion | <pre>object({<br/>    # The name of the Prometheus workspace for centralized injestion<br/>    name = string<br/><br/>    # The Prometheus workspace host. <br/>    # A sample value for AWs managed Prometheus will be `aps-workspaces.us-east-1.amazonaws.com`<br/>    host = string<br/><br/>    # The Prometheus workspace query path. <br/>    # A sample value for AWs managed Prometheus will be `workspaces/ws-xxxxx-xxx-xxx-xxx-xxxxxxx/api/v1/query`<br/>    query_path = string<br/><br/>    # The region for the Prometheus workspace created for centralized injestion path.<br/>    region = string<br/><br/>    # The ARN of the AWS IAM role enabling this cluster to use the Prometheus workspace for centralized ingestion <br/>    role_arn = string<br/><br/>    # The write path for the Prometheus workspace. <br/>    # A sample value for AWs managed Prometheus will be `workspaces/ws-xxxxx-xxx-xxx-xxx-xxxxxxx/api/v1/remote_write`<br/>    write_path = string<br/><br/>    # The url for the Prometheus workspace. <br/>    # A sample value for AWs managed Prometheus will be `https://aps-workspaces.us-east-1.amazonaws.com/workspaces/ws-xxxxx-xxx-xxx-xxx-xxxxxxx`<br/>    url = string<br/>  })</pre> | <pre>{<br/>  "host": null,<br/>  "name": null,<br/>  "query_path": null,<br/>  "region": null,<br/>  "role_arn": null,<br/>  "url": null,<br/>  "write_path": null<br/>}</pre> | no |
| <a name="input_prometheus_operator_values"></a> [prometheus\_operator\_values](#input\_prometheus\_operator\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_reloader_values"></a> [reloader\_values](#input\_reloader\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_reloader_version"></a> [reloader\_version](#input\_reloader\_version) | Version of external-dns to install | `string` | `null` | no |
| <a name="input_secret_store_driver_values"></a> [secret\_store\_driver\_values](#input\_secret\_store\_driver\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_secret_store_driver_version"></a> [secret\_store\_driver\_version](#input\_secret\_store\_driver\_version) | Version of the secret store driver to install | `string` | `null` | no |
| <a name="input_secret_store_provider_values"></a> [secret\_store\_provider\_values](#input\_secret\_store\_provider\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_vertical_pod_autoscaler_values"></a> [vertical\_pod\_autoscaler\_values](#input\_vertical\_pod\_autoscaler\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_breakglass_role_arn"></a> [breakglass\_role\_arn](#output\_breakglass\_role\_arn) | ARN for a breakglass role in case of cluster lockout |
<!-- END_TF_DOCS -->
