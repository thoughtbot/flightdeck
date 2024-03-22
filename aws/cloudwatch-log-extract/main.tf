
locals {
  function_name = "transform-cloudwatch-log-${random_id.unique_id.dec}"
}

resource "aws_cloudwatch_log_subscription_filter" "cloudwatch_log_filter" {
  name            = "cloudwatch_log_filter-${random_id.unique_id.dec}"
  log_group_name  = data.aws_cloudwatch_log_group.log_group.name
  filter_pattern  = var.log_group_filter_pattern
  destination_arn = aws_lambda_function.sql_query_update.arn

  depends_on = [ aws_lambda_permission.allow_cloudwatch_logs ]
}

resource "aws_lambda_function" "sql_query_update" {
  function_name    = local.function_name
  description      = "Lambda function to extract cloudwatch logs to be sent to SNS"
  filename         = data.archive_file.function.output_path
  handler          = "lambda_function.lambda_handler"
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.8"
  source_code_hash = data.archive_file.function.output_base64sha256
  timeout          = 60

  environment {
    variables = {
      capture_group          = jsonencode(var.log_message_filter.capture_group)
      regex_pattern          = var.log_message_filter.regex_pattern
      message_attributes     = jsonencode(var.message_attributes)
      destinationSnsTopicArn = var.destination_sns_topic_arn
    }
  }
  depends_on = [
    aws_cloudwatch_log_group.lambda_logs,
    aws_iam_role.lambda_role
  ]
}

data "aws_iam_policy_document" "assume_role_policy_doc" {
  statement {
    sid    = "AllowAwsToAssumeRole"
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${local.function_name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_doc.json
}

resource "aws_iam_role_policy" "logs_role_policy" {
  name   = "${local.function_name}-policy"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_filter_policy.json
}

resource "random_id" "unique_id" {
  byte_length = 3
}

data "archive_file" "function" {
  output_path = "lambda_function.zip"
  source_file = "${path.module}/lambda-script/lambda_function.py"
  type        = "zip"
}

data "aws_cloudwatch_log_group" "log_group" {
  name = var.source_cloudwatch_log_group
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = 14
}

data "aws_iam_policy_document" "lambda_filter_policy" {
  statement {
    sid       = "snspublishnotifiations"
    effect    = "Allow"
    resources = [var.destination_sns_topic_arn]
    actions   = ["sns:Publish"]
  }

  statement {
    sid       = "cloudwatchlambdalogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
    actions = [
      "logs:*"
    ]
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_logs" {
  statement_id  = "AllowExecutionFromCloudwatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sql_query_update.function_name
  principal     = "logs.${data.aws_region.current.name}.amazonaws.com"
  source_arn    = data.aws_cloudwatch_log_group.log_group.arn
}

data "aws_region" "current" {}

