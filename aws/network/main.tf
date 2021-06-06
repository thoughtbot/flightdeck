module "nat_gateway" {
  source = "../nat-gateway"

  availability_zones = var.nat_availability_zones
  name               = var.name
  namespace          = var.namespace
  private_subnets    = module.private_subnets.instances
  public_subnets     = module.public_subnets.instances
  tags               = var.tags
  vpc                = module.vpc.instance
}

module "vpc" {
  source = "../vpc"

  cidr_block       = var.vpc_cidr_block
  enable_flow_logs = var.enable_flow_logs
  enable_ipv6      = var.enable_ipv6
  name             = var.name
  namespace        = var.namespace
  tags             = merge(var.tags, local.cluster_tags, var.vpc_tags)
}

module "private_subnets" {
  source = "../private-subnets"

  name        = var.name
  namespace   = var.namespace
  cidr_blocks = var.private_subnet_cidr_blocks
  vpc         = module.vpc.instance

  tags = merge(
    var.tags,
    local.cluster_tags,
    { "kubernetes.io/role/internal-elb" = "1" },
    var.private_subnet_tags
  )
}

module "public_subnets" {
  source = "../public-subnets"

  name        = var.name
  namespace   = var.namespace
  cidr_blocks = var.public_subnet_cidr_blocks
  vpc         = module.vpc.instance

  tags = merge(
    var.tags,
    local.cluster_tags,
    { "kubernetes.io/role/elb" = "1" },
    var.public_subnet_tags
  )
}

resource "aws_sns_topic" "alarms" {
  name = join("-", concat(var.namespace, [var.name, "alarms"]))
  tags = var.tags
}

locals {
  cluster_tags = zipmap(
    [
      for name in var.cluster_names :
      join("/", [
        "kubernetes.io",
        "cluster",
        join(",", concat(var.namespace, [name]))
      ])
    ],
    [for name in var.cluster_names : "shared"]
  )
}
