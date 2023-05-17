output "arns" {
  description = "ARN of the created SNS topics"

  value = zipmap(
    keys(aws_sns_topic.alarms),
    values(aws_sns_topic.alarms)[*].arn
  )
}

output "kms_key_id" {
  description = "ID of the created KMS key"
  value       = join("", aws_kms_key.sns[*].id)
}
