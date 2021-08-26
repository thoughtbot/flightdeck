data "aws_vpc" "this" {
  tags = merge(var.tags, var.vpc_tags)
}

data "aws_subnet_ids" "private" {
  tags   = merge(var.tags, var.private_tags)
  vpc_id = data.aws_vpc.this.id
}

data "aws_subnet" "private" {
  for_each = data.aws_subnet_ids.private.ids

  id = each.value
}

data "aws_subnet_ids" "public" {
  tags   = merge(var.tags, var.public_tags)
  vpc_id = data.aws_vpc.this.id
}

data "aws_subnet" "public" {
  for_each = data.aws_subnet_ids.public.ids

  id = each.value
}

data "aws_sns_topic" "alarms" {
  name = (
    var.alarm_topic_name == null ?
    "${data.aws_vpc.this.tags.Name}-alarms" :
    var.alarm_topic_name
  )
}

locals {
  cluster_names = [
    for tag in keys(data.aws_vpc.this.tags) :
    split("/", tag)[2]
    if length(regexall("^kubernetes\\.io/cluster/", tag)) == 1
  ]

  private_subnets = zipmap(
    values(data.aws_subnet.private).*.availability_zone,
    values(data.aws_subnet.private)
  )

  public_subnets = zipmap(
    values(data.aws_subnet.public).*.availability_zone,
    values(data.aws_subnet.public)
  )
}
