resource "aws_nat_gateway" "this" {
  for_each = toset(var.availability_zones)

  allocation_id = aws_eip.nat[each.value].id
  subnet_id     = var.public_subnets[each.value].id

  tags = merge(
    var.tags,
    {
      AvailabilityZone = each.value
      Name             = join("-", concat(var.namespace, [var.name, each.value]))
    }
  )
}

resource "aws_eip" "nat" {
  for_each = toset(var.availability_zones)

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      AvailabilityZone = each.value
      Name             = join("-", concat(var.namespace, [var.name, each.value]))
    }
  )
}
