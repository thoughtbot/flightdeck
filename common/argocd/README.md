<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 4.5 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.1.2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | ~> 4.5 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.1.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 3.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_repository_deploy_key.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_deploy_key) | resource |
| [github_repository_webhook.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook) | resource |
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret.argocd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.github](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [random_id.github_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_id.secret_key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [github_repository.source](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Helm chart to install | `string` | `"argo-cd"` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Helm repository containing the chart | `string` | `"https://argoproj.github.io/argo-helm"` | no |
| <a name="input_chart_values"></a> [chart\_values](#input\_chart\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of chart to install | `string` | n/a | yes |
| <a name="input_extra_secrets"></a> [extra\_secrets](#input\_extra\_secrets) | Extra values to append to the ArgoCD secret | `map(string)` | `{}` | no |
| <a name="input_github_repositories"></a> [github\_repositories](#input\_github\_repositories) | GitHub repositories to connect to ArgoCD | `list(string)` | `[]` | no |
| <a name="input_host"></a> [host](#input\_host) | Hostname for ArgoCD | `string` | n/a | yes |
| <a name="input_install_to_github"></a> [install\_to\_github](#input\_install\_to\_github) | Set to false if Terraform won't have GitHub write permission | `bool` | `true` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes namespace in which secrets should be created | `string` | n/a | yes |
| <a name="input_kustomize_versions"></a> [kustomize\_versions](#input\_kustomize\_versions) | Versions of Kustomize to install | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the Helm release | `string` | `"argocd"` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | Policy grants for ArgoCD RBAC | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->