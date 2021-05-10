resource "kubernetes_secret" "dex" {
  metadata {
    name      = var.name
    namespace = var.k8s_namespace
  }

  data = zipmap(
    [
      for client in keys(var.static_clients) :
      "${upper(client)}_SECRET"
    ],
    values(random_password.client).*.result
  )
}

resource "random_password" "client" {
  for_each = var.static_clients

  length  = 24
  special = false
}

resource "helm_release" "dex" {
  chart     = "${path.module}/chart"
  name      = var.name
  namespace = var.k8s_namespace
  values    = concat([local.chart_values], var.chart_values)
}

locals {
  chart_values = yamlencode({
    config = {
      staticClients = [
        for client in keys(var.static_clients) :
        {
          id           = client,
          name         = var.static_clients[client].name,
          redirectURIs = var.static_clients[client].redirectURIs,
          secretEnv    = "${upper(client)}_SECRET"
        }
      ]
    },
    deployment = {
      envFrom = [
        {
          secretRef = {
            name = kubernetes_secret.dex.metadata[0].name
          }
        }
      ]
    }
  })
}
