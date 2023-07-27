resource "aws_sns_topic" "alarms" {
  for_each = toset(var.sns_topic_names)

  kms_master_key_id = join("", aws_kms_key.sns[*].id)
  name              = each.value
  tags              = var.tags
}

resource "aws_sns_topic_policy" "alarms" {
  for_each = aws_sns_topic.alarms

  arn    = each.value.arn
  policy = data.aws_iam_policy_document.sns[each.key].json
}

resource "aws_kms_key" "sns" {
  count = var.enable_kms ? 1 : 0

  description = "SNS alarm topics"
  tags        = var.tags
}

data "aws_iam_policy_document" "sns" {
  for_each = aws_sns_topic.alarms

  statement {
    sid       = "AllowCloudWatch"
    resources = [each.value.arn]
    actions   = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["${local.cloudwatch_prefix}:alarm:*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }
  }

  statement {
    sid       = "AllowAlertManager"
    resources = [each.value.arn]
    actions   = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["aps.amazonaws.com"]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["${local.aps_prefix}:workspace/*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }
  }
}

resource "aws_kms_alias" "sns" {
  count = length(aws_kms_key.sns)

  name          = var.kms_alias_name
  target_key_id = aws_kms_key.sns[count.index].id
}

resource "aws_kms_key_policy" "sns" {
  count = length(aws_kms_key.sns)

  key_id = aws_kms_key.sns[count.index].id
  policy = data.aws_iam_policy_document.kms.json
}

data "aws_iam_policy_document" "kms" {
  statement {
    sid       = "AllowPublish"
    resources = ["*"]

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]

    principals {
      type = "Service"

      identifiers = [
        "aps.amazonaws.com",
        "cloudwatch.amazonaws.com"
      ]
    }
  }

  statement {
    sid       = "AllowAdmin"
    resources = ["*"]

    not_actions = ["kms:Decrypt"]

    principals {
      type        = "AWS"
      identifiers = local.admin_prinicipals
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  account_id        = data.aws_caller_identity.current.account_id
  region            = data.aws_region.current.name
  cloudwatch_prefix = "arn:aws:cloudwatch:${local.region}:${local.account_id}"
  aps_prefix        = "arn:aws:aps:${local.region}:${local.account_id}"

  admin_prinicipals = coalescelist(
    var.admin_principals,
    ["arn:aws:iam::${local.account_id}:root"]
  )
}
