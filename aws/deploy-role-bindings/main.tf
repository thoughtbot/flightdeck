resource "kubernetes_cluster_role_binding" "cluster" {
  for_each = toset(var.cluster_roles)

  metadata {
    name = var.name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = each.value
  }

  subject {
    kind      = "Group"
    name      = var.group
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role" "cluster_crd" {
  metadata {
    name = "${var.name}-cluster-crd"
  }

  rule {
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "cluster_crd" {
  metadata {
    name = "${var.name}-cluster-crd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "${var.name}-cluster-crd"
  }

  subject {
    kind      = "Group"
    name      = var.group
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [kubernetes_cluster_role.cluster_crd]
}

resource "kubernetes_role_binding" "crd" {
  metadata {
    name      = kubernetes_role.deploy_crd.metadata[0].name
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "${var.name}-crd"
  }

  subject {
    kind      = "Group"
    name      = var.group
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_role" "deploy_crd" {
  metadata {
    name      = "${var.name}-crd"
    namespace = var.namespace
  }

  rule {
    api_groups = ["monitoring.coreos.com"]
    resources  = ["servicemonitors", "prometheusrules"]
    verbs      = ["*"]
  }

  rule {
    api_groups = ["networking.istio.io"]
    resources  = ["virtualservices"]
    verbs      = ["*"]
  }

  rule {
    api_groups = ["sloth.slok.dev"]
    resources  = ["prometheusservicelevels"]
    verbs      = ["*"]
  }
}
