locals {
  name = join("-", concat(var.namespace, [var.name]))
}

resource "aws_eks_cluster" "this" {
  enabled_cluster_log_types = var.enabled_cluster_log_types
  name                      = local.name
  role_arn                  = aws_iam_role.control_plane.arn
  tags                      = var.tags
  version                   = var.k8s_version

  vpc_config {
    security_group_ids = [aws_security_group.control_plane.id]
    subnet_ids         = concat(var.private_subnet_ids, var.public_subnet_ids)
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_key.arn
    }
    resources = "secrets"
  }

  depends_on = [
    # Ensure that IAM Role permissions are created before and deleted after EKS
    # Cluster handling. Otherwise, EKS will not be able to properly delete EKS
    # managed EC2 infrastructure such as Security Groups.
    aws_iam_role_policy_attachment.control_plane,

    # Ensure EKS doesn't automatically create the log group before we create it
    # and set retention.
    aws_cloudwatch_log_group.eks
  ]
}

resource "aws_iam_role" "control_plane" {
  name = join("-", [local.name, "control-plane"])

  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
}

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "control_plane" {
  role = aws_iam_role.control_plane.name

  policy_arn = join(
    "/",
    [
      "arn:${data.aws_partition.current.partition}:iam::aws:policy",
      "AmazonEKSClusterPolicy"
    ]
  )
}

resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${local.name}/cluster"
  retention_in_days = var.log_retention_in_days
}

resource "aws_security_group" "control_plane" {
  description = "Security group for Kubernetes control plane"
  name        = join("-", [local.name, "control-plane"])
  tags        = var.tags
  vpc_id      = var.vpc.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow outbound traffic"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.control_plane.id
  to_port           = 0
  type              = "egress"
}

resource "aws_kms_key" "eks_key" {
  description         = "KMS Key for EKS cluster ${var.name} secrets encryption"
  key_usage           = "ENCRYPT_DECRYPT"
  enable_key_rotation = true
}

resource "aws_kms_alias" "eks_key_alias" {
  target_key_id = aws_kms_key.eks_key
  name_prefix   = "alias/${var.name}"
}

data "aws_partition" "current" {
}
