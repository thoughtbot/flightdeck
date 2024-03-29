resource "kubernetes_namespace" "this" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace

    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "kubernetes_service_account" "pods" {
  depends_on = [kubernetes_namespace.this]

  metadata {
    name      = var.pod_service_account
    namespace = var.namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = var.pod_iam_role
    }
  }
}

module "secret_provider_class" {
  depends_on = [kubernetes_namespace.this]
  source     = "../secret-provider-class"

  kubernetes_secret_name  = var.secret_name
  kubernetes_secret_type  = var.secret_type
  name                    = var.secret_provider_class
  namespace               = var.namespace
  secrets_manager_secrets = var.secrets_manager_secrets
}

module "deploy_role_bindings" {
  depends_on = [kubernetes_namespace.this]
  source     = "../deploy-role-bindings"

  cluster_roles = var.deploy_cluster_roles
  group         = coalesce(var.deploy_group, "${var.namespace}-deploy")
  namespace     = var.namespace
}

module "developer_role_bindings" {
  depends_on = [kubernetes_namespace.this]
  source     = "../developer-role-bindings"

  enable_exec = var.enable_exec
  group       = coalesce(var.developer_group, "${var.namespace}-developer")
  namespace   = var.namespace
}
