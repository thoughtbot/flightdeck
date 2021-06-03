locals {
  shell = templatefile(
    "${path.module}/build.sh",
    {
      account_id      = data.aws_caller_identity.current.account_id
      aws_region      = data.aws_region.current.name
      base_image      = var.base_image
      build_args      = join(" ", var.build_args)
      dockerfile      = var.dockerfile
      repository_name = var.repository.name
    }
  )

  name = join("-", distinct(concat(var.namespace, [var.name])))
}

resource "aws_ecr_repository" "mirror" {
  name                 = "${var.repository.name}-base"
  image_tag_mutability = "IMMUTABLE"
  tags                 = var.tags
}


resource "aws_iam_policy" "build" {
  name   = local.name
  policy = data.aws_iam_policy_document.build.json
}

data "aws_iam_policy_document" "build" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:ListImages"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [var.repository.arn, aws_ecr_repository.mirror.arn]
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
