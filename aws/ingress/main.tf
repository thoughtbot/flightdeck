module "alb" {
  providers = { aws.alb = aws.cluster, aws.route53 = aws.route53 }
  source    = "github.com/thoughtbot/terraform-alb-ingress?ref=v0.8.0"

  alarm_actions              = var.alarm_actions
  alarm_evaluation_minutes   = var.alarm_evaluation_minutes
  create_domain_aliases      = var.create_aliases ? local.domain_names : []
  description                = "Flightdeck cluster load balancer"
  failure_threshold          = var.failure_threshold
  hosted_zone_name           = var.hosted_zone_name
  issue_certificate_domains  = var.issue_certificates ? local.domain_names : []
  legacy_target_group_names  = var.legacy_target_group_names
  name                       = join("-", concat(var.namespace, [var.name]))
  primary_certificate_domain = coalesce(var.certificate_domain_name, var.primary_domain_name)
  security_group_name        = join("-", concat(var.namespace, [var.name]))
  slow_response_threshold    = var.slow_response_threshold
  subnet_ids                 = module.network.public_subnet_ids
  tags                       = var.tags
  target_groups              = local.target_groups
  target_group_weights       = var.target_group_weights
  validate_certificates      = var.validate_certificates
  vpc_id                     = module.network.vpc.id

  depends_on = [module.network]
}

module "network" {
  source = "../network-data"

  tags = merge(local.cluster_tags, var.network_tags)
}

module "cluster_name" {
  for_each = toset(var.cluster_names)
  source   = "../cluster-name"

  name = each.value
}

locals {
  cluster_tags = merge(
    values(module.cluster_name).*.shared_tags...
  )

  # terraform-alb-ingress v0.8.0 replaced the old create_aliases/issue_certificates
  # booleans with explicit domain lists; this reconstructs the same "primary +
  # alternatives" bundling the old boolean-driven behavior used.
  domain_names = concat([var.primary_domain_name], var.alternative_domain_names)

  target_groups = zipmap(
    var.cluster_names,
    [
      for cluster in var.cluster_names :
      {
        # This is the health check endpoint for istio-ingressgateway
        health_check_path = "/healthz/ready"
        health_check_port = 15021
        name              = cluster
      }
    ]
  )
}

module "waf" {
  count  = var.enable_waf ? 1 : 0
  source = "../waf"

  name                    = "${var.name}-waf"
  resource_arn            = module.alb.instance.arn
  aws_managed_rule_groups = var.waf_aws_managed_rule_groups
  rate_limit_rules        = var.waf_rate_limit

  allowed_ip_list = var.waf_allowed_ip_list
  block_ip_list   = var.waf_block_ip_list

  depends_on = [module.alb]
}
