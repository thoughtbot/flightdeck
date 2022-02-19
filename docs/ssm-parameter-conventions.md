# SSM Parameter Conventions

In order to make it easier to combine the modules created by Flightdeck, modules
will automatically create and search for [SSM parameters]. Flightdeck does not
store secrets in SSM parameter store, and treats the values in parameters it
creates as non-sensitive (ie, they may be printed during Terraform runs).

If you use the included network, ingress, cluster, and platform modules, these
parameters will automatically be created and consumed as needed.

## Created Parameters

The following SSM parameters are populated by Flightdeck:

### Cluster

The [cluster module](../aws/cluster/README.md) creates the following:

__`/flightdeck/CLUSTERNAME/oidc_issuer`__:

The URL of the IAM OIDC issuer created for service account roles.

Example: `oidc.eks.us-east-2.amazonaws.com/id/ABCDEF0123456789ABCDEF0123456789`

__`/flightdeck/CLUSTERNAME/node_role_arn`__:

ARN of the IAM role created for nodes running this cluster. You can attach
additional policies to this role if you want them to be available for all pods
running in your cluster. This can be useful for granting permission to access
ECR repositories and other shared resources.

Example: `arn:aws:iam::123456789012:role/mycluster-production-v1-nodes`

## Expected Parameters

The [platform module](../aws/platform) expects the following:

### Platform

__`/flightdeck/CLUSTERNAME/oidc_issuer`__:

The URL of the IAM OIDC issuer for the cluster to which the workload platform is
being deployed. The OIDC issuer is used create roles for service accounts for
platform components, such as the load balancer controller.

__`/flightdeck/CLUSTERNAME/node_role_arn`__:

ARN of the IAM role created for nodes running this cluster. This parameter is
used to ensure the nodes remain in the cluster's `aws-auth` ConfigMap.

### Service Account Role

The [service account role module](../aws/service-account-role) expects:

__`/flightdeck/CLUSTERNAME/oidc_issuer`__:

The URL of the IAM OIDC issuer for the cluster to which the workload platform is
being deployed. The OIDC issuer is required for pods using your service account
to assume the role you're creating.

[SSM parameters]: https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html
