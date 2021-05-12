variable "bucket" {
  type        = string
  description = "Name for AWS bucket for Terraform state"
}

variable "dynamodb_table" {
  type        = string
  description = "Name for DynamoDB table for locks"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to created resources"
  default     = {}
}
