output "instance" {
  description = "Script to build Docker images"
  value       = { policies = [aws_iam_policy.build.arn], shell = local.shell }
}
