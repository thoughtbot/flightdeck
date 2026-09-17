data "aws_region" "current" {}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = var.route_table_ids

  tags = merge(
    var.tags,
    {
      Name = join("-", concat(var.namespace, [var.name, "s3-endpoint"]))
    }
  )
}