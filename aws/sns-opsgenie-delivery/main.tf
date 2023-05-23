resource "aws_sns_topic_subscription" "sns_opsgenie_delivery" {
  count = var.sns_opsgenie_api_key == null ? 0 : 1

  endpoint  = "https://api.opsgenie.com/v1/json/amazonsns?apiKey=${var.sns_opsgenie_api_key}"
  protocol  = "https"
  topic_arn = var.source_sns_topic_arn
}

resource "aws_sns_topic_subscription" "cloudwatch_opsgenie_delivery" {
  count = var.cloudwatch_opsgenie_api_key == null ? 0 : 1

  endpoint  = "https://api.opsgenie.com/v1/json/cloudwatch?apiKey=${var.cloudwatch_opsgenie_api_key}"
  protocol  = "https"
  topic_arn = var.source_sns_topic_arn
}