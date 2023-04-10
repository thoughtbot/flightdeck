# Deploy Service Account

This module creates a [Kubernetes service account] which can be used to write to
common resources used by Flightdeck applications, suitable for use in a CI/CD
pipeline.

Example:

``` hcl
module "deploy_service_account" {
  source = "github.com/thoughtbot/flightdeck//aws/deploy-service-account?ref=VERSION"

  # Name of the service account (default: deploy)
  name = "example-staging-deploy"

  # Kubernetes namespace
  namespace = "example-staging"

  # Must match a group declared in your eks-auth configmap
  group = "example-staging-deploy"
}
```

You can use the [github-actions-eks-deploy-role module] to create a role
suitable for use in a GitHub Actions workflow.

Once the deploy service account and role have been created, you must map them in
your [eks-auth] config:

``` hcl
# In your platform configuration
module "workload_platform" {
  source = "github.com/thoughtbot/flightdeck//aws/platform?ref=VERSION"

  # Other config

  custom_roles = {
    # Must match the group binding above
    example-staging-deploy = aws_iam_role.example_staging_deploy.arn
  }
}
```

[Kubernetes service account]: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/
[eks-auth]: https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html
[github-actions-eks-deploy-role module]: github.com/thoughtbot/terraform-eks-cicd//modules/github-actions-eks-deploy-role

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
| [kubernetes_role.deploy_crd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role) | resource |
| [kubernetes_role_binding.cluster](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.crd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_roles"></a> [cluster\_roles](#input\_cluster\_roles) | Names of cluster roles for this serviceaccount (default: admin) | `list(string)` | <pre>[<br>  "admin"<br>]</pre> | no |
| <a name="input_group"></a> [group](#input\_group) | Name of the Kubernetes group allowed to deploy | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Kubernetes service account (default: deploy) | `string` | `"deploy"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to which this tenant deploys | `string` | n/a | yes |
<!-- END_TF_DOCS -->
