module "vpc" {
  count  = var.create_vpc ? 1 : 0
  source = "../vpc"

  cidr_block       = var.vpc_cidr_block
  enable_flow_logs = var.enable_flow_logs
  enable_ipv6      = var.enable_ipv6
  name             = var.name
  namespace        = var.namespace
  tags             = merge(var.tags, local.cluster_tags, var.vpc_tags)
}

data "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
  tags       = var.tags

  depends_on = [module.vpc]
}

module "nat_gateway" {
  count  = var.create_nat_gateways ? 1 : 0
  source = "../nat-gateway"

  availability_zones = var.nat_availability_zones
  name               = var.name
  namespace          = var.namespace
  public_subnets     = module.public_subnets.instances
  tags               = var.tags
}

module "private_subnets" {
  source = "../private-subnets"

  name        = var.name
  namespace   = var.namespace
  cidr_blocks = var.private_subnet_cidr_blocks
  vpc         = data.aws_vpc.this

  tags = merge(
    var.tags,
    local.cluster_tags,
    var.private_subnet_tags
  )
}

module "private_subnet_routes" {
  source = "../private-subnet-routes"

  nat_availability_zones = var.nat_availability_zones
  name                   = var.name
  namespace              = var.namespace
  private_subnets        = module.private_subnets.instances
  tags                   = merge(var.tags, var.private_subnet_tags)
  vpc                    = data.aws_vpc.this

  depends_on = [module.nat_gateway]
}

module "public_subnets" {
  source = "../public-subnets"

  name        = var.name
  namespace   = var.namespace
  cidr_blocks = var.public_subnet_cidr_blocks
  vpc         = data.aws_vpc.this

  tags = merge(
    var.tags,
    local.cluster_tags,
    var.public_subnet_tags
  )
}

module "public_subnet_routes" {
  source = "../public-subnet-routes"

  name      = var.name
  namespace = var.namespace
  subnets   = module.public_subnets.instances
  tags      = merge(var.tags, var.public_subnet_tags)
  vpc       = data.aws_vpc.this

  depends_on = [module.public_subnets, aws_internet_gateway.this]
}

resource "aws_internet_gateway" "this" {
  count = var.create_internet_gateway ? 1 : 0

  tags   = merge(var.tags, { Name = join("-", concat(var.namespace), [var.name]) })
  vpc_id = data.aws_vpc.this.id
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
