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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | github.com/thoughtbot/terraform-alb-ingress | v0.5.0 |
| <a name="module_cluster_name"></a> [cluster\_name](#module\_cluster\_name) | ../cluster-name | n/a |
| <a name="module_network"></a> [network](#module\_network) | ../network-data | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | SNS topics or other actions to invoke for alarms | `list(object({ arn = string }))` | `[]` | no |
| <a name="input_alarm_evaluation_minutes"></a> [alarm\_evaluation\_minutes](#input\_alarm\_evaluation\_minutes) | Number of minutes of alarm state until triggering an alarm | `number` | `2` | no |
| <a name="input_alternative_domain_names"></a> [alternative\_domain\_names](#input\_alternative\_domain\_names) | Alternative domain names for the ALB | `list(string)` | `[]` | no |
| <a name="input_certificate_domain_name"></a> [certificate\_domain\_name](#input\_certificate\_domain\_name) | Override the domain name for the ACM certificate (defaults to primary domain) | `string` | `null` | no |
| <a name="input_cluster_names"></a> [cluster\_names](#input\_cluster\_names) | List of clusters that this ingress stack will forward to | `list(string)` | n/a | yes |
| <a name="input_create_aliases"></a> [create\_aliases](#input\_create\_aliases) | Set to false to disable creation of Route 53 aliases | `bool` | `true` | no |
| <a name="input_failure_threshold"></a> [failure\_threshold](#input\_failure\_threshold) | Percentage of failed requests considered an anomaly | `number` | `5` | no |
| <a name="input_hosted_zone_name"></a> [hosted\_zone\_name](#input\_hosted\_zone\_name) | Hosted zone for AWS Route53 | `string` | `null` | no |
| <a name="input_issue_certificates"></a> [issue\_certificates](#input\_issue\_certificates) | Set to false to disable creation of ACM certificates | `bool` | `true` | no |
| <a name="input_legacy_target_group_names"></a> [legacy\_target\_group\_names](#input\_legacy\_target\_group\_names) | Names of legacy target groups which should be included | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the AWS network in which ingress should be provided | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Prefix to apply to created resources | `list(string)` | `[]` | no |
| <a name="input_network_tags"></a> [network\_tags](#input\_network\_tags) | Tags for finding the AWS VPC and subnets | `map(string)` | `{}` | no |
| <a name="input_primary_domain_name"></a> [primary\_domain\_name](#input\_primary\_domain\_name) | Primary domain name for the ALB | `string` | n/a | yes |
| <a name="input_slow_response_threshold"></a> [slow\_response\_threshold](#input\_slow\_response\_threshold) | Response time considered extremely slow | `number` | `10` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to created resources | `map(string)` | `{}` | no |
| <a name="input_target_group_weights"></a> [target\_group\_weights](#input\_target\_group\_weights) | Weight for each target group (defaults to 100) | `map(number)` | `{}` | no |
| <a name="input_validate_certificates"></a> [validate\_certificates](#input\_validate\_certificates) | Set to false to disable validation via Route 53 | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb"></a> [alb](#output\_alb) | The load balancer |
| <a name="output_http_listener"></a> [http\_listener](#output\_http\_listener) | The HTTP listener |
| <a name="output_https_listener"></a> [https\_listener](#output\_https\_listener) | The HTTPS listener |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | Security group for the load balancer |
<!-- END_TF_DOCS -->