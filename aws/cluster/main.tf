module "eks_cluster" {
  source = "../eks-cluster"

  name            = local.cluster_name
  namespace       = var.namespace
  private_subnets = module.private_subnets.instances
  public_subnets  = module.public_subnets.instances
  tags            = var.tags
  vpc             = module.vpc.instance
}

module "vpc" {
  source = "../vpc"

  cidr_block = var.vpc_cidr_block
  namespace  = var.namespace
  tags       = merge(var.tags, local.cluster_tags, var.vpc_tags)
}

module "private_subnets" {
  source = "../private-subnets"

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


module "aws_k8s_oidc_provider" {
  source = "../k8s-oidc-provider"

  cluster = module.eks_cluster.instance
}

resource "aws_ssm_parameter" "oidc_issuer" {
  name  = join("/", concat([""], var.namespace, [var.name, "oidc_issuer"]))
  type  = "SecureString"
  value = module.aws_k8s_oidc_provider.issuer
}

resource "aws_ssm_parameter" "vpc_id" {
  name  = join("/", concat([""], var.namespace, [var.name, "vpc_id"]))
  type  = "SecureString"
  value = module.vpc.instance.id
}

locals {
  cluster_name = join("-", concat(var.namespace, [var.name]))
  cluster_tags = { ("kubernetes.io/cluster/${local.cluster_name}") = "shared" }
}
