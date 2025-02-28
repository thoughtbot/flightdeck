output "aws_waf_arn" {
  description = "The arn for AWS WAF WebACL."
  value       = aws_wafv2_web_acl.main.arn
}

