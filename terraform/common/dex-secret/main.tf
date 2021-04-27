resource "kubernetes_secret" "dex" {
  metadata {
    name      = "dex"
    namespace = var.k8s_namespace
  }

  data = zipmap(
    [
      for client in var.clients :
      "${upper(client)}_SECRET"
    ],
    values(random_password.client).*.result
  )
}

resource "random_password" "client" {
  for_each = var.clients

  length  = 24
  special = false
}
