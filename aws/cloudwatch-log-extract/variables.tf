variable "source_cloudwatch_log_group" {
  description = "The name of the log group to associate the subscription filter with"
  type        = string
}

variable "log_message_filter" {
  description = "Filter regex pattern to pick out items from a Cloudwatch log to be sent to destination endpoint. Pass in a valid regex pattern with capture groups, and a capture_group map stating the label for each capture_group"
  type = object({
    regex_pattern = string,
    capture_group = map(string)
  })
  default = {
    regex_pattern = "",
    capture_group = {}
  }
}

variable "destination_sns_topic_arn" {
  description = "The ARN of the destination SNS topic to deliver matching log events to."
  type        = string
}

variable "message_attributes" {
  description = "Message attributes to be included with messages publised to SNS"
  type        = map(string)
  default     = {}
}

variable "log_group_filter_pattern" {
  description = "CloudWatch Logs filter pattern for subscribing to a filtered stream of log events"
  type        = string
  default     = ""
}