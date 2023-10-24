resource "aws_organizations_policy" "backup_policy" {
  name        = "{var.name}-backup-policy"
  content     = jsonencode(local.backup_plans)
  description = "{var.name}-backup-policy"
  type        = "BACKUP_POLICY"
}

resource "aws_organizations_policy_attachment" "account" {
  policy_id = aws_organizations_policy.backup_policy.id
  target_id = local.parent_roots_id
}

data "aws_organizations_organization" "org" {}

data "aws_caller_identity" "current" {}

locals {
  parent_roots_id = data.aws_organizations_organization.org.roots[0].id

  advanced_backup_setting = {
    ec2 = {
      windows_vss = {
        "@@assign" = "enabled"
      }
    }
  }

  backup_copy_actions = {
    "arn:aws:backup:${var.secondary_vault_region}:$account:backup-vault:${var.vault_name}" = {
      target_backup_vault_arn = {
        "@@assign" = "arn:aws:backup:${var.secondary_vault_region}:$account:backup-vault:${var.vault_name}"
      }
      lifecycle = local.backup_lifecycle
    },
    "arn:aws:backup:${var.target_resource_region}:${data.aws_caller_identity.current.account_id}:backup-vault:${var.vault_name}" = {
      target_backup_vault_arn = {
        "@@assign" = "arn:aws:backup:${var.target_resource_region}:${data.aws_caller_identity.current.account_id}:backup-vault:${var.vault_name}"
      }
      lifecycle = local.backup_lifecycle
    },
  }

  backup_cron_schedule = {
    "@@assign" = var.backup_cron_schedule
  }

  backup_delete_after = {
    "@@assign" = var.backup_delete_after
  }

  backup_lifecycle = {
    delete_after_days               = local.backup_delete_after
    move_to_cold_storage_after_days = local.cold_storage_after
  }

  backup_plans = {
    plans = local.backup_policies
  }

  backup_policies = {
    "${var.name}-backup-policy" = local.backup_policy
  }

  backup_policy = {
    regions = {
      "@@append" = [var.target_resource_region]
    }
    rules = {
      "${var.name}-backup-rule" = local.backup_rule
    }
    selections               = local.backup_selections
    advanced_backup_settings = local.advanced_backup_setting
  }

  backup_rule = {
    target_backup_vault_name       = local.target_vault_name
    schedule_expression            = local.backup_cron_schedule
    start_backup_window_minutes    = local.start_window_minutes
    lifecycle                      = local.backup_lifecycle
    complete_backup_window_minutes = local.completion_window
    copy_actions                   = local.backup_copy_actions
  }

  backup_selections = {
    tags = local.backup_tag_selections
  }

  backup_tag_selections = {
    for key, value in var.backup_selection_tags :
    key => {
      iam_role_arn = {
        "@@assign" = "arn:aws:iam::$account:role/${var.backup_selection_role_name}"
      },
      tag_key = {
        "@@assign" = key
      },
      tag_value = {
        "@@assign" = value
      }
    }
  }

  cold_storage_after = {
    "@@assign" = var.cold_storage_after
  }

  completion_window = {
    "@@assign" = var.completion_window
  }

  start_window_minutes = {
    "@@assign" = var.start_window_minutes
  }

  target_vault_name = {
    "@@assign" = var.vault_name
  }
}


