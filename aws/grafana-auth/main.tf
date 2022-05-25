module "secret" {
  source = "github.com/thoughtbot/terraform-aws-secrets//secret?ref=v0.3.1"

  admin_principals = var.admin_principals
  description      = "Grafana API Key: ${var.name}"
  name             = var.name
  read_principals  = var.read_principals
  resource_tags    = var.tags
  trust_tags       = var.trust_tags

  initial_value = jsonencode({
    GRAFANA_API_KEY = var.initial_api_key
  })
}

module "rotation" {
  source = "github.com/thoughtbot/terraform-aws-secrets//secret-rotation-function?ref=v0.3.1"

  handler       = "lambda_function.lambda_handler"
  role_arn      = module.secret.rotation_role_arn
  rotation_days = 15
  runtime       = "python3.8"
  secret_arn    = module.secret.arn
  source_file   = "${path.module}/rotation/lambda_function.py"

  variables = {
    WORKSPACE_URL = var.workspace_url
  }
}

data "aws_secretsmanager_secret_version" "latest_version" {
  depends_on = [module.secret]

  secret_id = module.secret.arn
}
