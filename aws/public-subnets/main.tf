resource "aws_subnet" "this" {
  for_each = var.cidr_blocks

  assign_ipv6_address_on_creation = var.enable_ipv6
  availability_zone               = each.key
  cidr_block                      = each.value
  ipv6_cidr_block                 = local.ipv6_cidrs[each.key]
  map_public_ip_on_launch         = true
  vpc_id                          = var.vpc.id

  tags = merge(
    var.tags,
    {
      AvailabilityZone = each.key
      Name             = join("-", concat(var.namespace, ["public"]))
      Network          = "public"
    }
  )
}

resource "aws_route_table" "this" {
  vpc_id = var.vpc.id

  tags = merge(
    var.tags,
    { Name = join("-", concat(var.namespace, ["public"])) }
  )
}

resource "aws_internet_gateway" "this" {
  tags   = merge(var.tags, { Name = join("-", var.namespace) })
  vpc_id = var.vpc.id
}


resource "aws_route" "internet_gateway_ipv4" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
  route_table_id         = aws_route_table.this.id
}

resource "aws_route" "internet_gateway_ipv6" {
  count = var.enable_ipv6 ? 1 : 0

  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this.id
  route_table_id              = aws_route_table.this.id
}

resource "aws_route_table_association" "this" {
  for_each = var.cidr_blocks

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.this.id
}

locals {
  azs = sort(keys(var.cidr_blocks))
  cidrs = [
    for az in sort(keys(var.cidr_blocks)) :
    var.enable_ipv6 ?
    cidrsubnet(
      cidrsubnet(var.vpc.ipv6_cidr_block, 1, 0),
      7,
      index(local.azs, az)
    ) :
    null
  ]
  ipv6_cidrs = zipmap(local.azs, local.cidrs)
}
