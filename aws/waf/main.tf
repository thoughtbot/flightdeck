resource "aws_wafv2_web_acl" "main" {
  name        = var.name
  description = "${var.name} WAFv2 ACL"
  scope       = var.waf_scope

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    sampled_requests_enabled   = true
    metric_name                = "${var.name}-cloudfront-web-acl"
  }

  dynamic "rule" {
    for_each = var.rate_limit
    content {
      name     = "${rule.value["name"]}-IP-Ratelimit"
      priority = rule.value["priority"]

      dynamic "action" {
        for_each = rule.value["count_override"] == true ? [1] : []
        content {
          count {}
        }
      }
      dynamic "action" {
        for_each = rule.value["count_override"] == false ? [1] : []
        content {
          block {}
        }
      }
      statement {
        rate_based_statement {
          limit              = rule.value["Limit"]
          aggregate_key_type = "IP"

          dynamic "scope_down_statement" {
            for_each = length(rule.value["country_list"]) > 0 ? [1] : []
            content {
              geo_match_statement {
                country_codes = rule.value["country_list"]
              }
            }
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "${rule.value["name"]}-IP-Ratelimit"
      }
    }
  }

  rule {
    name     = "${var.name}-allowed-ip-list"
    priority = 0

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.allowed_ip_list.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled   = true
      metric_name                = "${var.name}-allowed-ip-list"
    }
  }

  rule {
    name     = "${var.name}-blocked-ip-list"
    priority = 1

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.block_ip_list.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled   = true
      metric_name                = "${var.name}-blocked-ip-list"
    }
  }

  dynamic "rule" {
    for_each = var.aws_managed_rule_groups
    content {
      name     = rule.value["name"]
      priority = rule.value["priority"]

      dynamic "override_action" {
        for_each = rule.value["count_override"] == true ? [1] : []
        content {
          count {}
        }
      }
      dynamic "override_action" {
        for_each = rule.value["count_override"] == false ? [1] : []
        content {
          none {}
        }
      }
      statement {
        managed_rule_group_statement {
          name        = rule.value["name"]
          vendor_name = "AWS"

          dynamic "scope_down_statement" {
            for_each = length(rule.value["country_list"]) > 0 ? [1] : []
            content {
              geo_match_statement {
                country_codes = rule.value["country_list"]
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = rule.value["name"]
      }
    }
  }
}

resource "aws_wafv2_web_acl_association" "this" {
  count = var.waf_scope == "REGIONAL" ? 1 : 0

  resource_arn = var.resource_arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}

resource "aws_ssm_parameter" "aws_waf_acl" {
  name        = "/cloudfront/aws-waf/web-acl/${var.name}"
  description = "ARN for the AWS WAF - ${var.name}"
  type        = "SecureString"
  value       = aws_wafv2_web_acl.main.arn
}

resource "aws_wafv2_web_acl_logging_configuration" "main" {
  log_destination_configs = [aws_cloudwatch_log_group.aws_waf_log_group.arn]
  resource_arn            = aws_wafv2_web_acl.main.arn

  depends_on = [aws_cloudwatch_log_group.aws_waf_log_group]
}

resource "aws_cloudwatch_log_group" "aws_waf_log_group" {
  name              = "aws-waf-logs-waf/${var.name}/logs"
  retention_in_days = 120
}

resource "aws_wafv2_ip_set" "allowed_ip_list" {
  name               = "${var.name}-allowed-ip-set"
  scope              = var.waf_scope
  ip_address_version = "IPV4"
  addresses          = var.allowed_ip_list
}

resource "aws_wafv2_ip_set" "block_ip_list" {
  name               = "${var.name}-blocked-ip-set"
  scope              = var.waf_scope
  ip_address_version = "IPV4"
  addresses          = var.block_ip_list
}