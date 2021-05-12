# AWS Cluster

Creates a Kubernetes cluster capable of running the Flightdeck platform using
Terraform and EKS.

Components:

* [VPC](../vpc)
* [NAT gateway](../nat-gateway)
* [EKS cluster](../eks-cluster)
* [Node groups](../eks-node-group)

An [OIDC provider](../k8s-oidc-provider) is configured to enable [IRSA].

[IRSA]: https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/setting-up-enable-IAM.html
