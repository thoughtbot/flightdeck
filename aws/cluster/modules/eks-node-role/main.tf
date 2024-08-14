resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  name               = join("-", concat(var.namespace, [var.name, "nodes"]))
  tags               = var.tags
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "${local.policy_prefix}/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "${local.policy_prefix}/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_policy" {
  policy_arn = "${local.policy_prefix}/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "eks_cloudwatch_agent_policy" {
  policy_arn = "${local.policy_prefix}/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "eks_ssm_instance_policy" {
  policy_arn = "${local.policy_prefix}/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "eks_ssm_instance_policy" {
  policy_arn = "${local.policy_prefix}/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "eks_xray_writeonly_policy" {
  policy_arn = "${local.policy_prefix}/AWSXrayWriteOnlyAccess"
  role       = aws_iam_role.this.name
}

locals {
  policy_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"
}

data "aws_partition" "current" {}
