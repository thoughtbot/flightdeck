locals {
  function_name = "alertmanager-sentry-integration-${random_id.unique_id.dec}"
}

resource "aws_sns_topic" "alertmanager_sns_topic" {
  name = "${var.name}-alertmanager-sns-topic"
}

resource "aws_sns_topic_policy" "alertmanager_sns_topic" {
  arn    = aws_sns_topic.alertmanager_sns_topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_topic_subscription" "prometheus_alertmanager_sns" {
  endpoint      = "https://api.opsgenie.com/v1/json/amazonsns?apiKey=${var.opsgenie_sns_api_key}"
  filter_policy = jsonencode(var.opsgenie_sns_subscription_filter)
  protocol      = "https"
  topic_arn     = aws_sns_topic.alertmanager_sns_topic.arn
}

resource "aws_lambda_function" "alertmanger_sentry_notification" {
  function_name    = local.function_name
  description      = "Lambda function to forward messages to Sentry"
  filename         = data.archive_file.function.output_path
  handler          = "lambda_function.lambda_handler"
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.8"
  source_code_hash = data.archive_file.function.output_base64sha256
  timeout          = 60
  layers           = [aws_lambda_layer_version.sentry_sdk_layer.arn]

  environment {
    variables = {
      sentrySecretName  = var.sentry_secret_name
      sentryEnvironment = var.sentry_environment
    }
  }
  depends_on = [
    aws_cloudwatch_log_group.lambda_logs,
    aws_iam_role.lambda_role
  ]
}

resource "random_id" "unique_id" {
  byte_length = 3
}

data "archive_file" "function" {
  output_path = "lambda_function.zip"
  source_file = "${path.module}/lambda-script/lambda_function.py"
  type        = "zip"
}

resource "aws_iam_role" "lambda_role" {
  name               = "${local.function_name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_doc.json
}

resource "aws_iam_role_policy" "logs_role_policy" {
  name   = "${local.function_name}-policy"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lamada_role_policy.json
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.alertmanger_sentry_notification.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.alertmanager_sns_topic.arn
}

resource "aws_sns_topic_subscription" "lambda" {
  endpoint      = aws_lambda_function.alertmanger_sentry_notification.arn
  filter_policy = jsonencode(var.sentry_sns_subscription_filter)
  protocol      = "lambda"
  topic_arn     = aws_sns_topic.alertmanager_sns_topic.arn
}

resource "aws_lambda_layer_version" "sentry_sdk_layer" {

  compatible_runtimes = ["python3.8"]
  description         = "Lambda layer to package sentry sdk dependency"
  filename            = "${path.module}/lambda-script/sentry_sdk.zip"
  layer_name          = "${local.function_name}-layer"
  source_code_hash    = filebase64sha256("${path.module}/lambda-script/sentry_sdk.zip")
}

data "aws_iam_policy_document" "lamada_role_policy" {
  statement {
    sid       = "cloudwatchlambdalogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
    actions = [
      "logs:*"
    ]
  }

  statement {
    sid = "lambdaReadSecrets"
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue"
    ]
    resources = ["arn:aws:secretsmanager:*:${data.aws_caller_identity.this.account_id}:secret:${var.sentry_secret_name}*"]
  }

  statement {
    sid = "lambdaDecryptSecrets"
    actions = [
      "kms:Decrypt"
    ]
    resources = ["arn:aws:kms:*:${data.aws_caller_identity.this.account_id}:key/*", ]
  }
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

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "AlertManagerSNSTopicPolicy"

  statement {
    actions = [
      "SNS:Publish",
      "SNS:GetTopicAttributes",
    ]

    effect = "Allow"

    condition {
      test     = "ArnEquals"
      variable = "AWS:SourceArn"

      values = [
        data.aws_prometheus_workspace.prometheus_workspace.arn
      ]
    }

    principals {
      type        = "Service"
      identifiers = ["aps.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.alertmanager_sns_topic.arn,
    ]

    sid = "AlertManagerSNSTopicPolicy"
  }
}

data "aws_prometheus_workspace" "prometheus_workspace" {
  workspace_id = var.prometheus_workspace_id
}

data "aws_region" "this" {}

data "aws_caller_identity" "this" {}
