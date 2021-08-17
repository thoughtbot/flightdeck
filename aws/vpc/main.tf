resource "aws_vpc" "this" {
  assign_generated_ipv6_cidr_block = var.enable_ipv6
  cidr_block                       = var.cidr_block
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = merge(
    var.tags,
    {
      Name = join("-", concat(var.namespace, [var.name]))
    }
  )
}

resource "aws_flow_log" "vpc" {
  count = var.enable_flow_logs ? 1 : 0

  iam_role_arn    = join("", aws_iam_role.flow_logs.*.arn)
  log_destination = join("", aws_cloudwatch_log_group.flow_logs.*.arn)
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id
}

resource "aws_iam_role" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  assume_role_policy = data.aws_iam_policy_document.flow_logs_assume_role.json
  name               = join("-", concat(var.namespace, [var.name, "flow-logs"]))
}

data "aws_iam_policy_document" "flow_logs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  policy_arn = join("", aws_iam_policy.flow_logs.*.arn)
  role       = join("", aws_iam_role.flow_logs.*.name)
}

resource "aws_iam_policy" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  name   = join("-", concat(var.namespace, [var.name, "flow-logs"]))
  policy = data.aws_iam_policy_document.flow_logs.json
}

data "aws_iam_policy_document" "flow_logs" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  name = join("/", concat([""], var.namespace, [var.name, "flow-logs"]))
}
