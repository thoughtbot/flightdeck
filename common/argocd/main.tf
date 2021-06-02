resource "helm_release" "this" {
  chart      = var.chart_name
  name       = var.name
  namespace  = var.k8s_namespace
  repository = var.chart_repository
  version    = var.chart_version
  values     = concat(local.chart_values, var.chart_values)

  depends_on = [kubernetes_secret.argocd]
}

data "github_repository" "source" {
  for_each = toset(var.github_repositories)

  name = each.value
}

resource "github_repository_deploy_key" "this" {
  for_each = var.install_to_github ? toset(var.github_repositories) : []

  key        = tls_private_key.this[each.key].public_key_openssh
  read_only  = true
  repository = each.value
  title      = "Argo CD"
}

resource "github_repository_webhook" "this" {
  for_each = var.install_to_github ? toset(var.github_repositories) : []

  events     = ["push"]
  repository = each.value

  configuration {
    content_type = "json"
    secret       = random_id.github_secret.hex
    url          = "https://${var.host}/argocd/api/webhook"
  }
}

resource "tls_private_key" "this" {
  for_each = toset(var.github_repositories)

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
      "server.secretkey"      = random_id.secret_key.b64_url
      "webhook.github.secret" = random_id.github_secret.hex
    },
    var.extra_secrets
  )
}

resource "kubernetes_secret" "github" {
  for_each = toset(var.github_repositories)

  metadata {
    name      = each.key
    namespace = var.k8s_namespace
  }

  data = {
    "id_rsa"     = tls_private_key.this[each.key].private_key_pem
    "id_rsa.pub" = tls_private_key.this[each.key].public_key_openssh
  }
}

resource "random_id" "secret_key" {
  byte_length = 32
}

resource "random_id" "github_secret" {
  byte_length = 32
}

locals {
  chart_values = [
    yamlencode({
      "configs" = {
        "secret" = {
          "createSecret" = false
        }
      }
      "dex" = {
        "enabled" = false
      }

      # https://argoproj.github.io/argo-cd/operator-manual/custom_tools/
      repoServer = {
        initContainers = [
          for version in var.kustomize_versions :
          {
            args = [
              join(" ", [
                "wget -qO-",
                "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${version}/kustomize_v${version}_linux_amd64.tar.gz",
                "| tar -xvzf -",
                "&& mv kustomize /custom-tools/kustomize-${version}"
              ])
            ]
            command = [
              "sh",
              "-c",
            ]
            image = "alpine:3.8"
            name  = "download-tools"
            volumeMounts = [
              {
                mountPath = "/custom-tools"
                name      = "custom-tools"
              },
            ]
          }
        ]
        volumeMounts = [
          {
            mountPath = "/custom-tools"
            name      = "custom-tools"
          },
        ]
        volumes = [
          {
            emptyDir = {}
            name     = "custom-tools"
          },
        ]
      }
      "server" = {
        "additionalApplications" = [
          for repository in data.github_repository.source :
          {
            destination = {
              namespace = "argocd"
              server    = "https://kubernetes.default.svc"
            }
            finalizers = [
              "resources-finalizer.argocd.argoproj.io",
            ]
            name      = "bootstrap-${repository.name}"
            namespace = "flightdeck"
            project   = "default"
            source = {
              directory = {
                recurse = true
              }
              path           = "argocd"
              repoURL        = repository.ssh_clone_url
              targetRevision = "main"
            }
            syncPolicy = {
              automated = {
                prune = true
              }
            }
          }
        ]
        "config" = merge(
          {
            "admin.enabled" = "false"
            "repositories"  = yamlencode(local.repositories)
          },
          zipmap(
            [
              for version in var.kustomize_versions :
              "kustomize.version.v${version}"
            ],
            [
              for version in var.kustomize_versions :
              "/custom-tools/kustomize-${version}"
            ]
          )
        )
        "extraArgs" = [
          "--insecure",
          "--rootpath",
          "/argocd",
          "--basehref",
          "/argocd",
        ]
        "rbacConfig" = {
          "policy.csv" = join("\n", [
            file("${path.module}/policy.csv"),
            var.policy
          ])
        }
      }
    })
  ]

  repositories = [
    for name, repository in data.github_repository.source :
    {
      url = repository.ssh_clone_url
      sshPrivateKeySecret = {
        key  = "id_rsa"
        name = name
      }
    }
  ]
}
