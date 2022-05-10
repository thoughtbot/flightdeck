# Target Groups

Generates target group definitions for forwarding traffic to Flightdeck
clusters.

You can use this with [ALB Ingress] or another module to create a load balancer
with target groups.

![Ingress Stack Diagram](../../docs/aws-ingress-stack.png)

## Example

```terraform
module "target_groups" {
  providers = {
  source = "git@github.com:thoughtbot/flightdeck//aws/target-groups"

  # Names of clusters to target from this load balancer.
  # Clusters should be added here before they're created.
  cluster_names = ["example-production-v1"]
}

module "ingress" {
  providers = {
    # You can use different provider instances when using multiple accounts.
    aws.cluster = aws
    aws.route53 = aws
  }

  source = "git@github.com:thoughtbot/terraform-alb-ingress.git?ref=v0.4.0"

  # Pass the target group definitions from the previous step
  target_groups = module.target_groups.by_cluster

  # Unique name for the Application Load Balancer
  name = "example-production-ingress"

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
module "target_groups" {
  cluster_names = ["example-production-v1", "example-production-v2"]
}

module "ingress" {
  target_groups = module.target_groups.by_cluster

  target_group_weights = {
    example-production-v1 = 100
    example-production-v2 = 0
  }
}
```

Once applications are deployed to the new cluster, add a small weight:

```terraform
module "target_groups" {
  cluster_names = ["example-production-v1", "example-production-v2"]
}

module "ingress" {
  target_groups = module.target_groups.by_cluster

  target_group_weights = {
    example-production-v1 = 95
    example-production-v2 = 5
  }
}
```

You can gradually increase the weight and reapply until all traffic targets the
new cluster. Then, de-provision the old cluster and remove its target group:

```terraform
module "target_groups" {
  cluster_names = ["example-production-v2"]
}

module "ingress" {
  target_groups = module.target_groups.by_cluster

  target_group_weights = {
    example-production-v2 = 100
  }
}
```

[alb ingress]: https://github.com/thoughtbot/terraform-alb-ingress
