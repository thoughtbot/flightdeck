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
  source = "github.com/thoughtbot/flightdeck//aws/workload-platform?ref=v0.6.0"

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
