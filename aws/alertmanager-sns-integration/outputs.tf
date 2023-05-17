output "alertmanager_sns_topic_arn" {
  description = "SNS topic arn for Alertmanager"
  value       = aws_sns_topic.alertmanager_sns_topic.arn
}

output "alertmanager_sentry_lambda_role_arn" {
  description = "IAM role arn for the Lambda function that will send alertmanager messages from SNS to Sentry."
  value       = "aws_iam_role.lambda_role.arn"
}