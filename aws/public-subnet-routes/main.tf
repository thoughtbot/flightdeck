data "aws_internet_gateway" "vpc" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc.id]
  }
}

resource "aws_route_table" "this" {
  vpc_id = var.vpc.id

  tags = merge(
    var.tags,
    {
      Name = join("-", concat(var.namespace, [var.name, "public"]))
    }
  )
}

resource "aws_route" "internet_gateway_ipv4" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.vpc.id
  route_table_id         = aws_route_table.this.id
}

resource "aws_route" "internet_gateway_ipv6" {
  count = var.enable_ipv6 ? 1 : 0

  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = data.aws_internet_gateway.vpc.id
  route_table_id              = aws_route_table.this.id
}

resource "aws_route_table_association" "this" {
  for_each = var.subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.this.id
}
