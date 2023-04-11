# Flightdeck Application Config

This module creates the necessary cluster configuration for an application
running on Flightdeck:

- An Istio-managed namespace
- A service account for an application IAM role
- A service account for a deployment IAM role
- A service account for developers to view application resources
- A SecretsManager SecretProviderClass for mounting secrets

Example:

```
module "example_sandbox_v1" {
  source = "github.com/thoughtbot/flightdeck//aws/application"

  # Kubernetes namespace
  namespace = "example-staging"

  # Name of the service account for the application's pods; must match manifests
  pod_service_account = "example"

  # Assign an IAM role to pods in this application
  pod_iam_role = aws_iam_role.service.arn

  # Name of the deployment service account (default: deploy)
  deploy_service_account = "example-staging-deploy"

  # Must match a group declared in your eks-auth configmap
  deploy_group = "example-staging-deploy"

  # Name of the developer service account (default: developer)
  name = "example-staging-developer"

  # Must match a group declared in your eks-auth configmap
  developer_group = "example-staging-developer"

  # Define mappings from SecretsManager
  secrets_manager_secrets = [
    # Map an environment variable from a SecretsManager secret
    {
      name                  = "rds-postgres-example"
      environment_variables = ["DATABASE_URL"]
    },
    # Map multiple environment variables
    {
      name                  = "smtp"
      environment_variables = ["SMTP_PASSWORD", "SMTP_USERNAME"]
    },
    # Use a custom JMES path to create an alias
    {
      name                  = "rds-postgres-replica"
      environment_variables = ["DATABASE_REPLICA_URL"]
      jmes_paths = [
        {
          object_alias = "DATABASE_REPLICA_URL"
          path         = "DATABASE_URL"
        },
      ]
    },
  ]

  # Uncomment if you want developers to be able to use kubectl exec
  # enable_exec = true
}
```

After applying this module, you will need to map the service accounts to IAM
roles using the [eks-auth] config.

You can do this in your platform configuration:

```
module "sso_roles" {
  source = "git@github.com:thoughtbot/terraform-aws-sso-permission-set-roles.git?ref=v0.2.0"
}

module "platform" {
  source = "github.com/thoughtbot/flightdeck//aws/platform?ref=VERSION"

  # Other config

  custom_roles = {
    example-staging-deploy    = aws_iam_role.deploy.arn
    example-staging-developer = module.permission_set_roles.by_name_without_path.DeveloperAccess
  }
}

[eks-auth]: https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html

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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_deploy_service_account"></a> [deploy\_service\_account](#module\_deploy\_service\_account) | ../deploy-service-account | n/a |
| <a name="module_developer_service_account"></a> [developer\_service\_account](#module\_developer\_service\_account) | ../developer-service-account | n/a |
| <a name="module_secret_provider_class"></a> [secret\_provider\_class](#module\_secret\_provider\_class) | ../secret-provider-class | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_service_account.pods](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Set to false to disable creation of the Kubernetes namespace | `bool` | `true` | no |
| <a name="input_deploy_cluster_roles"></a> [deploy\_cluster\_roles](#input\_deploy\_cluster\_roles) | Names of cluster roles for this serviceaccount (default: admin) | `list(string)` | <pre>[<br>  "admin"<br>]</pre> | no |
| <a name="input_deploy_group"></a> [deploy\_group](#input\_deploy\_group) | Name of the Kubernetes group allowed to deploy (default: NAMESPACE-deploy) | `string` | `null` | no |
| <a name="input_deploy_service_account"></a> [deploy\_service\_account](#input\_deploy\_service\_account) | Name of the Kubernetes service account (default: deploy) | `string` | `"deploy"` | no |
| <a name="input_developer_group"></a> [developer\_group](#input\_developer\_group) | Name of the Kubernetes group used by developers (default: NAMESPACE-developer) | `string` | `null` | no |
| <a name="input_developer_service_account"></a> [developer\_service\_account](#input\_developer\_service\_account) | Name of the Kubernetes service account (default: developer) | `string` | `"developer"` | no |
| <a name="input_enable_exec"></a> [enable\_exec](#input\_enable\_exec) | Set to true to allow running exec on pods | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to which this tenant deploys | `string` | n/a | yes |
| <a name="input_pod_iam_role"></a> [pod\_iam\_role](#input\_pod\_iam\_role) | ARN of the role which application pods should assume | `string` | n/a | yes |
| <a name="input_pod_service_account"></a> [pod\_service\_account](#input\_pod\_service\_account) | Name of the service account for pods | `string` | n/a | yes |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | Name of the Kubernetes secret to which environment variables will be written; defaults to secret provider class name | `string` | `null` | no |
| <a name="input_secret_provider_class"></a> [secret\_provider\_class](#input\_secret\_provider\_class) | Name of the SecretProviderClass resource (defaults to secretsmanager) | `string` | `"secretsmanager"` | no |
| <a name="input_secret_type"></a> [secret\_type](#input\_secret\_type) | Type of Kubernetes secret to create; defaults to opaque | `string` | `"opaque"` | no |
| <a name="input_secrets_manager_secrets"></a> [secrets\_manager\_secrets](#input\_secrets\_manager\_secrets) | Secrets to copy from AWS Secrets Manager | <pre>list(<br>    object({<br>      name                  = string,<br>      environment_variables = list(string),<br>      jmes_paths = optional(<br>        list(<br>          object({<br>            object_alias = string<br>            path         = string<br>          })<br>        ),<br>        []<br>      )<br>    })<br>  )</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deploy_group"></a> [deploy\_group](#output\_deploy\_group) | Name of the group bound to deploy roles |
| <a name="output_developer_group"></a> [developer\_group](#output\_developer\_group) | Name of the group bound to developer roles |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Kubernetes amepsace for this application |
| <a name="output_pod_service_account"></a> [pod\_service\_account](#output\_pod\_service\_account) | Name of the service account for application pods |
<!-- END_TF_DOCS -->
