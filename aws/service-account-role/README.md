# AWS Service Account Role

This module creates an [IAM role] which can be assumed by pods in your cluster,
provided access to AWS resources for your application. Without creating a role
for your service account, your pods will be limited to the permissions available
to the nodes running in the cluster.

Roles created by this module IAM role suitable for use in an EKS cluster using
[IRSA]. This module relies on Flightdeck's [SSM parameter conventions] to find
the OIDC provider for the assigned clusters.

To use this role, you must provide:

- A list of cluster names from which this role will be assumable
- A list of service account names in `namespace:serviceaccount` format
- A unique name for the created IAM role

Additionally, you may provide policy documents which will be attached directly
to the role as well as ARNs for managed policies.

Example:

```
module "role" {
  source = "github.com/thoughtbot/flightdeck//aws/service-account-role"

  # Must match the names of clusters created using the [cluster module]
  cluster_names    = ["mycluster-production-v1", "mycluster-production-v2"]
  name             = "myservice-production"
  service_accounts = ["myservice-production:myservice"]

  # If you have modules which produce managed policies, you can attach them here
  managed_policy_arns = [
    module.custom.policy_arn
  ]
}
```

You can combine this module with the [service account policy module] to grant
access to AWS services for your pods.

[iam role]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
[irsa]: https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/setting-up-enable-IAM.html
[cluster module]: ../cluster/README.md
[ssm parameter conventions]: ../../docs/ssm-parameter-conventions.md
[service account policy module]: ../service-account-policy
