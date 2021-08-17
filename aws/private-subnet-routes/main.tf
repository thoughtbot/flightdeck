data "aws_nat_gateway" "vpc" {
  for_each = toset(var.nat_availability_zones)

  tags   = { AvailabilityZone = each.value }
  vpc_id = var.vpc.id
}

resource "aws_route_table" "nat" {
  for_each = toset(var.nat_availability_zones)

  vpc_id = var.vpc.id

  tags = merge(
    var.tags,
    {
      AvailabilityZone = each.value
      Name             = join("-", concat(var.namespace, [var.name, each.value]))
    }
  )
}

resource "aws_route" "nat" {
  for_each = aws_route_table.nat

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = data.aws_nat_gateway.vpc[each.key].id
  route_table_id         = each.value.id
}

resource "aws_route_table_association" "nat" {
  for_each = var.private_subnets

  subnet_id = each.value.id

  route_table_id = (
    contains(var.nat_availability_zones, each.key) ?
    aws_route_table.nat[each.key].id :
    aws_route_table.nat[var.nat_availability_zones[0]].id
  )
}
