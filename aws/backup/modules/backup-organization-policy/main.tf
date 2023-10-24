resource "aws_organizations_delegated_administrator" "management" {
  account_id        = var.delegate_account_id
  service_principal = "backup.amazonaws.com"
}

resource "aws_backup_global_settings" "cross_account_backup" {
  global_settings = {
    "isCrossAccountBackupEnabled" = "true"
  }
}

resource "aws_organizations_resource_policy" "allow_delegated_backup_administrator" {
  content = data.aws_iam_policy_document.organization_backup_policy.json
}

data "aws_iam_policy_document" "organization_backup_policy" {
  statement {
    sid = "AllowOrganizationsRead"
    actions = [
      "organizations:Describe*",
      "organizations:List*"
    ]
    resources = ["*"]
    principals {
      identifiers = [var.delegate_account_id]
      type        = "AWS"
    }
  }
  statement {
    sid = "AllowBackupPoliciesCreation"
    actions = [
      "organizations:CreatePolicy"
    ]
    resources = ["*"]
    principals {
      identifiers = [var.delegate_account_id]
      type        = "AWS"
    }
    condition {
      test     = "StringEquals"
      variable = "organizations:PolicyType"
      values   = ["BACKUP_POLICY"]
    }
  }
  statement {
    sid = "AllowBackupPoliciesModification"
    actions = [
      "organizations:DescribePolicy",
      "organizations:UpdatePolicy",
      "organizations:DeletePolicy"
    ]
    resources = ["arn:aws:organizations::${data.aws_caller_identity.current.account_id}:policy/*/backup_policy/*", ]
    principals {
      identifiers = [var.delegate_account_id]
      type        = "AWS"
    }
    condition {
      test     = "StringEquals"
      variable = "organizations:PolicyType"
      values   = ["BACKUP_POLICY"]
    }
  }
  statement {
    sid = "AllowBackupPoliciesAttachmentAndDetachmentToAllAccountsAndOUs"
    actions = [
      "organizations:AttachPolicy",
      "organizations:DetachPolicy"
    ]
    resources = [
      "arn:aws:organizations::${data.aws_caller_identity.current.account_id}:root/*",
      "arn:aws:organizations::${data.aws_caller_identity.current.account_id}:ou/*",
      "arn:aws:organizations::${data.aws_caller_identity.current.account_id}:account/*",
      "arn:aws:organizations::${data.aws_caller_identity.current.account_id}:policy/*/backup_policy/*"
    ]
    principals {
      identifiers = [var.delegate_account_id]
      type        = "AWS"
    }
    condition {
      test     = "StringEquals"
      variable = "organizations:PolicyType"
      values   = ["BACKUP_POLICY"]
    }
  }
}

data "aws_caller_identity" "current" {}

