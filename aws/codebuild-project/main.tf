locals {
  name = join("-", distinct(concat(var.namespace, [var.name, "ci"])))
}

resource "aws_codebuild_project" "this" {
  name          = local.name
  build_timeout = "20"
  service_role  = aws_iam_role.codebuild.arn
  tags          = var.tags

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:4.0"
    privileged_mode = true
    type            = "LINUX_CONTAINER"
  }

  source {
    git_clone_depth     = 1
    type                = "GITHUB"
    location            = "https://github.com/${var.github_repository_name}.git"
    report_build_status = var.report_build_status

    auth {
      type     = "OAUTH"
      resource = aws_codebuild_source_credential.github_access_token.arn
    }

    buildspec = templatefile(
      "${path.module}/buildspec.yml",
      {
        bucket = aws_s3_bucket.this.id
      }
    )
  }
}

resource "aws_codebuild_webhook" "project" {
  count = var.enable_github_webhook ? 1 : 0

  project_name = aws_codebuild_project.this.name

  dynamic "filter_group" {
    for_each = var.github_deploy_branches

    content {
      filter {
        type    = "EVENT"
        pattern = "PUSH"
      }

      filter {
        type    = "HEAD_REF"
        pattern = "^refs/heads/${filter_group.value}$"
      }
    }
  }

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "^refs/tags/.*"
    }
  }

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_CREATED,PULL_REQUEST_UPDATED"
    }
  }

  depends_on = [aws_codebuild_source_credential.github_access_token]
}

data "aws_ssm_parameter" "github_access_token" {
  name = var.github_access_token_parameter
}

resource "aws_codebuild_source_credential" "github_access_token" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = data.aws_ssm_parameter.github_access_token.value
}

resource "aws_iam_role" "codebuild" {
  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}

resource "aws_iam_role_policy_attachment" "this" {
  count = length(flatten(var.scripts.*.policies))

  policy_arn = flatten(var.scripts.*.policies)[count.index]
  role       = aws_iam_role.codebuild.name
}

data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "codebuild" {
  name   = local.name
  role   = aws_iam_role.codebuild.id
  policy = data.aws_iam_policy_document.codebuild.json
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
  statement {
    actions   = ["*"]
    resources = [aws_s3_bucket.this.arn, "${aws_s3_bucket.this.arn}/*"]
  }
}

resource "aws_s3_bucket" "this" {
  bucket        = local.name
  tags          = var.tags
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "this" {
  bucket           = aws_s3_bucket.this.id
  content_base64   = base64gzip(join("\n\n", var.scripts.*.shell))
  content_encoding = "gzip"
  content_type     = "text/x-shellscript"
  force_destroy    = true
  key              = "build.sh.gz"
  tags             = merge(var.tags)
}
