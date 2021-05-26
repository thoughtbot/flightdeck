data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_vpc" "cluster" {
  tags = local.cluster_tags
}

data "aws_eks_cluster_auth" "token" {
  name = local.cluster.name
}

data "aws_subnet_ids" "private" {
  tags   = merge(local.cluster_tags, { "kubernetes.io/role/internal-elb" = "1" })
  vpc_id = data.aws_vpc.cluster.id
}

data "aws_subnet" "private" {
  for_each = data.aws_subnet_ids.private.ids

  id = each.value
}

locals {
  cluster      = data.aws_eks_cluster.this
  cluster_tags = { ("kubernetes.io/cluster/${var.cluster_name}") = "shared" }
}
