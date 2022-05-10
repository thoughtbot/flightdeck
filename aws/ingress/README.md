# AWS Ingress

Creates an ingress stack powered by AWS Application Load Balancer targeting
Istio ingress in Flightdeck clusters. A target group will be created for each
cluster running in the configured network.

![Ingress Stack Diagram](../../docs/aws-ingress-stack.png)

## Example

```terraform
module "ingress" {
  providers = {
    # You can use different provider instances when using multiple accounts.
    aws.cluster = aws
    aws.route53 = aws
  }

  source = "github.com/thoughtbot/flightdeck//aws/ingress?ref=v0.4.0"

  # Unique name for the Application Load Balancer
  name = "example-production-ingress"

  # Names of clusters to target from this load balancer.
  # Clusters should be added here before they're created.
  cluster_names = ["example-production-v1"]

  # Name of a Route 53 hosted zone to which records should be added.
  # You can leave this out if you're managing DNS and certificates separately.
  # If provided, DNS aliases and ACM certificate validation are automatic.
  hosted_zone_name    = "example.com"

  # Primary domain name for the ACM certificate.
  primary_domain_name = "example.com"

  # Any other domains which should be routed to this load balancer.
  # These domains will have DNS aliases and will be listed on the certificate.
  alternative_domain_names = ["www.example.com"]

  # Any extra tags you want to apply to all created resources.
  tags = { Module = "ingress/production" }
}
```

## Migrations

If you're migrating to a new Flightdeck cluster (or migrating to Flightdeck from
a non-Flightdeck deployment) you can use multiple target groups to slowly shift
traffic from the old deployment to the new cluster.

![Migration Diagram](../../docs/aws-ingress-migration.png)

First add a new target group for the new cluster with a weight of zero:

```terraform
module "ingress" {
  cluster_names = ["example-production-v1", "example-production-v2"]

  target_group_weights = {
    example-production-v1 = 100
    example-production-v2 = 0
  }
}
```

Once applications are deployed to the new cluster, add a small weight:

```terraform
module "ingress" {
  cluster_names = ["example-production-v1", "example-production-v2"]

  target_group_weights = {
    example-production-v1 = 95
    example-production-v2 = 5
  }
}
```

You can gradually increase the weight and reapply until all traffic targets the
new cluster. Then, de-provision the old cluster and remove its target group:

```terraform
module "ingress" {
  cluster_names = ["example-production-v2"]

  target_group_weights = {
    example-production-v2 = 100
  }
}
```
