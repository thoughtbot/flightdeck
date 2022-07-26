data "aws_vpc" "this" {
  tags = merge(var.tags, var.vpc_tags)
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = merge(var.tags, var.private_tags)
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = merge(var.tags, var.public_tags)
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

locals {
  cluster_names = [
    for tag in keys(data.aws_vpc.this.tags) :
    split("/", tag)[2]
    if length(regexall("^kubernetes\\.io/cluster/", tag)) == 1
  ]
}
