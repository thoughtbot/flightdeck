resource "aws_nat_gateway" "this" {
  for_each = toset(var.availability_zones)

  allocation_id = aws_eip.nat[each.value].id
  subnet_id     = var.public_subnets[each.value].id

  tags = merge(
    var.tags,
    {
      AvailabilityZone = each.value
      Name             = join("-", concat(var.namespace, [var.name, each.value]))
      Network          = join("-", concat(var.namespace, [var.name]))
    }
  )
}

resource "aws_eip" "nat" {
  for_each = toset(var.availability_zones)

  vpc = true

  tags = merge(
    var.tags,
    {
      AvailabilityZone = each.value
      Name             = join("-", concat(var.namespace, [var.name, each.value]))
      Network          = join("-", concat(var.namespace, [var.name]))
    }
  )
}

resource "aws_route_table" "nat" {
  for_each = toset(var.availability_zones)

  vpc_id = var.vpc.id

  tags = merge(
    var.tags,
    {
      AvailabilityZone = each.value
      Name             = join("-", concat(var.namespace, [var.name, each.value]))
      Network          = join("-", concat(var.namespace, [var.name]))
    }
  )
}

resource "aws_route" "nat" {
  for_each = aws_route_table.nat

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
  route_table_id         = each.value.id
}

resource "aws_route_table_association" "nat" {
  for_each = var.private_subnets

  subnet_id = each.value.id

  route_table_id = (
    contains(var.availability_zones, each.key) ?
    aws_route_table.nat[each.key].id :
    aws_route_table.nat[var.availability_zones[0]].id
  )
}
