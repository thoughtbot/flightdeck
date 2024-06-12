output "aws_waf_arn" {
  description = "The arn for AWS WAF WebACL."
  value       = aws_wafv2_web_acl.main.arn
}

output "waf_logs_sns_topic_arn" {
  description = "The arn for the SNS topic to receive the AWS WAF logs"
  value       = aws_sns_topic.waf_logs_sns_subscription.arn
}
