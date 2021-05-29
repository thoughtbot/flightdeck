data "aws_vpc" "this" {
  tags = var.network_tags
}

data "aws_subnet_ids" "private" {
  tags   = merge(var.network_tags, var.private_tags)
  vpc_id = data.aws_vpc.this.id
}

data "aws_subnet" "private" {
  for_each = data.aws_subnet_ids.private.ids

  id = each.value
}

data "aws_subnet_ids" "public" {
  tags   = merge(var.network_tags, var.public_tags)
  vpc_id = data.aws_vpc.this.id
}

data "aws_subnet" "public" {
  for_each = data.aws_subnet_ids.public.ids

  id = each.value
}

locals {
  private_subnets = zipmap(
    values(data.aws_subnet.private).*.availability_zone,
    values(data.aws_subnet.private)
  )
  public_subnets = zipmap(
    values(data.aws_subnet.public).*.availability_zone,
    values(data.aws_subnet.public)
  )
}
