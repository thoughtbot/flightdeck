output "target_group_arn" {
  description = "ARN of the target group created for Istio"
  value       = aws_alb_target_group.this.arn
}
