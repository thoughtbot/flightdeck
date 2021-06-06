<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.1.2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.1.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.dex](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret.dex](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [random_password.client](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_values"></a> [chart\_values](#input\_chart\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_extra_secrets"></a> [extra\_secrets](#input\_extra\_secrets) | Extra values to append to the Dex secret | `map(string)` | `{}` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes namespace in which secrets should be created | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the Helm release | `string` | `"dex"` | no |
| <a name="input_static_clients"></a> [static\_clients](#input\_static\_clients) | Map of static clients to configure with OAuth2 secrets | `map(object({ name = string, redirectURIs = list(string) }))` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_secrets"></a> [client\_secrets](#output\_client\_secrets) | OAuth2 secret for each static client |
<!-- END_TF_DOCS -->