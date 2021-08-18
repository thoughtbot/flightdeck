module "alb" {
  providers = { aws.cluster = aws.cluster, aws.route53 = aws.route53 }
  source    = "git@github.com:thoughtbot/terraform-alb-ingress.git?ref=v0.2.0"

  alarm_actions            = module.network.alarm_actions
  alarm_evaluation_minutes = var.alarm_evaluation_minutes
  alternative_domain_names = var.alternative_domain_names
  create_aliases           = var.create_aliases
  description              = "Flightdeck cluster load balancer"
  failure_threshold        = var.failure_threshold
  hosted_zone_name         = var.hosted_zone_name
  issue_certificates       = var.issue_certificates
  name                     = "${local.network_name}-ingress"
  namespace                = var.namespace
  primary_domain_name      = var.primary_domain_name
  slow_response_threshold  = var.slow_response_threshold
  subnets                  = module.network.public_subnets
  tags                     = var.tags
  target_groups            = local.target_groups
  target_group_weights     = var.target_group_weights
  validate_certificates    = var.validate_certificates
  vpc                      = module.network.vpc
}

module "network" {
  source = "../network-data"

  alarm_topic_name = var.alarm_topic_name
  tags             = var.network_tags
}

locals {
  network_name = coalesce(var.name, module.network.vpc.tags.Name)

  target_groups = zipmap(
    module.network.cluster_names,
    [
      for cluster in module.network.cluster_names :
      {
        # This is the health check endpoint for istio-ingressgateway
        health_check_path = "/healthz/ready"
        health_check_port = 15021
        name              = cluster
      }
    ]
  )
}
