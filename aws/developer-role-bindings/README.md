# Developer Service Account

This module creates [Kubernetes role bindings] which can be used by
developers to debug Flightdeck applications. It provides read access to most
Kubernetes resources within the namespace, including the CRDs declared by
Flightdeck.

Example:

``` hcl
module "developer_role_bindings" {
  source = "github.com/thoughtbot/flightdeck//aws/developer-role-bindings?ref=VERSION"

  # Kubernetes namespace
  namespace = "example-staging"

  # Must match a group declared in your eks-auth configmap
  group = "example-staging-developer"

  # Uncomment if you want developers to be able to use kubectl exec
  # enable_exec = true
}
```

Once the role bindings has been created, you must map them in your [eks-auth]
config. You can use the [SSO permission set roles module] to lookup a role that
developers will use.


``` hcl
# In your platform configuration
module "sso_roles" {
  source = "git@github.com:thoughtbot/terraform-aws-sso-permission-set-roles.git?ref=v0.2.0"
}

module "platform" {
  source = "github.com/thoughtbot/flightdeck//aws/platform?ref=v0.9.0-alpha.0"

  # Other config

  custom_roles = {
    example-developer  module.permission_set_roles.by_name_without_path.DeveloperAccess
  }
}

```

[Kubernetes role bindings]: https://kubernetes.io/docs/reference/access-authn-authz/rbac/
[eks-auth]: https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html
[SSO permission set roles module]: https://github.com/thoughtbot/terraform-aws-sso-permission-set-roles

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.5 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.6 |

## Resources

| Name | Type |
|------|------|
| [kubernetes_role.developer_access](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role) | resource |
| [kubernetes_role_binding.developer_access](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_exec"></a> [enable\_exec](#input\_enable\_exec) | Set to true to allow running exec on pods | `bool` | `false` | no |
| <a name="input_group"></a> [group](#input\_group) | Name of the Kubernetes group used by developers | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Kubernetes service account (default: developer) | `string` | `"developer"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to which developers will have access | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_group_name"></a> [group\_name](#output\_group\_name) | Name of the group bound to the developer role |
<!-- END_TF_DOCS -->
