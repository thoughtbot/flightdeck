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

  rule {
    name     = "${var.name}-IP-Ratelimit"
    priority = var.rate_limit["Priority"]

    action {
      count {}
    }

    statement {
      rate_based_statement {
        limit              = var.rate_limit["Limit"]
        aggregate_key_type = "IP"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled   = true
      metric_name                = "${var.name}-IP-Ratelimit"
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
      statement {
        managed_rule_group_statement {
          name        = rule.value["name"]
          vendor_name = "AWS"
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