data "github_repository" "source" {
  for_each = var.github_repositories

  name = each.value.name
}

resource "github_repository_deploy_key" "this" {
  for_each = var.install_to_github ? var.github_repositories : {}

  key        = tls_private_key.this[each.key].public_key_openssh
  read_only  = true
  repository = each.value.name
  title      = "Argo CD"
}

resource "github_repository_webhook" "this" {
  for_each = var.install_to_github ? var.github_repositories : {}

  events     = ["push"]
  repository = each.value.name

  configuration {
    content_type = "json"
    secret       = random_id.github_secret.hex
    url          = "https://${var.host}/api/webhook"
  }
}

resource "tls_private_key" "this" {
  for_each = var.github_repositories

  algorithm = "RSA"
}

resource "kubernetes_secret" "argocd" {
  metadata {
    name      = "argocd-secret"
    namespace = var.k8s_namespace

    labels = {
      "app.kubernetes.io/name" : "argocd-secret"
      "app.kubernetes.io/part-of" : "argocd"
    }
  }

  data = merge(
    {
      "admin.password"        = bcrypt(random_password.admin.result)
      "admin.passwordMtime"   = time_rotating.admin_password.id
      "server.secretkey"      = random_id.secret_key.b64_url
      "webhook.github.secret" = random_id.github_secret.hex
    },
    var.extra_secrets
  )
}

resource "kubernetes_secret" "github" {
  for_each = var.github_repositories

  metadata {
    name      = each.key
    namespace = var.k8s_namespace
  }

  data = {
    "id_rsa"     = tls_private_key.this[each.key].private_key_pem
    "id_rsa.pub" = tls_private_key.this[each.key].public_key_openssh
  }
}

resource "random_password" "admin" {
  keepers = {
    rotation = time_rotating.admin_password.id
  }

  length  = 16
  special = true
}

resource "time_rotating" "admin_password" {
  rotation_days = 90
}

resource "random_id" "secret_key" {
  byte_length = 32
}

resource "random_id" "github_secret" {
  byte_length = 32
}
