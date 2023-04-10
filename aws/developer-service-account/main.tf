resource "kubernetes_role_binding" "developer_access" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "developer"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.group
  }
}

resource "kubernetes_role" "developer_access" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  # Read-only access to non-sensitive resources
  rule {
    api_groups = ["", "apps", "batch"]
    resources = [
      "configmaps",
      "cronjobs",
      "daemonsets",
      "deployments",
      "jobs",
      "pods",
      "pods/log",
      "replicasets",
      "services",
    ]
    verbs = ["get", "list", "watch"]
  }

  # View Prometheus Operator resources
  rule {
    api_groups = ["monitoring.coreos.com"]
    resources  = ["servicemonitors"]
    verbs      = ["get", "list", "watch"]
  }

  # View Istio resources
  rule {
    api_groups = ["networking.istio.io"]
    resources  = ["virtualservices"]
    verbs      = ["get", "list", "watch"]
  }

  # View Sloth SLOs
  rule {
    api_groups = ["sloth.slok.dev"]
    resources  = ["prometheusservicelevels"]
    verbs      = ["get", "list", "watch"]
  }

  # Exec into pods for debugging
  dynamic "rule" {
    for_each = var.enable_exec ? [true] : []

    content {
      api_groups = [""]
      resources  = ["pods/exec"]
      verbs      = ["get", "create"]
    }
  }
}
