<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.4 |

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Helm chart to install | `string` | `null` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Helm repository containing the chart | `string` | `null` | no |
| <a name="input_chart_values"></a> [chart\_values](#input\_chart\_values) | Overrides to pass to the Helm chart | `list(string)` | `[]` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of chart to install | `string` | `null` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes namespace in which resources will be written | `string` | `"default"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the release | `string` | `"sonarqube"` | no |

## chart_values Input

The list of Helm values that can be configured via `chart_values` input. For default values, refer to [Artifact Hub](https://artifacthub.io/packages/helm/sonarqube/sonarqube?modal=values).

| Parameter | Description | Default |
|-----------|-------------|---------|
| `deploymentType` | Deployment type (Deployment or StatefulSet) | `"Deployment"` |
| `replicaCount` | Number of SonarQube replicas | `1` |
| `revisionHistoryLimit` | How many revisions to retain | `10` |
| `deploymentStrategy` | Deployment strategy type | `Recreate` |
| `community.enabled` | Enable Community Edition | `true` |
| `community.buildNumber` | Community Edition build number | `"25.12.0.117093"` |
| `image.repository` | Image repository | `"sonarqube"` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `securityContext.fsGroup` | Pod security context fsGroup | `1000` |
| `containerSecurityContext` | Container security context | (see values.yaml) |
| `elasticsearch.configureNode` | Configure Elasticsearch node | `false` |
| `elasticsearch.bootstrapChecks` | Enable Elasticsearch bootstrap checks | `true` |
| `service.type` | Kubernetes Service type | `"ClusterIP"` |
| `service.externalPort` | Service external port | `9000` |
| `service.internalPort` | Service internal port | `9000` |
| `httpProxySecret` | Secret containing http proxy config | `""` |
| `httpProxy` | HTTP proxy URL | `""` |
| `networkPolicy.enabled` | Enable NetworkPolicy creation | `false` |
| `sonarWebContext` | Context path for SonarQube web | `""` |
| `ingress-nginx.enabled` | Enable ingress-nginx chart | `false` |
| `httproute.enabled` | Enable Gateway API HTTPRoute | `false` |
| `ingress.enabled` | Enable Ingress creation | `false` |
| `ingress.hosts` | Ingress hosts configuration | `[]` |
| `ingress.tls` | Ingress TLS configuration | `[]` |
| `affinity` | Pod affinity rules | `{}` |
| `tolerations` | Pod tolerations | `[]` |
| `nodeSelector` | Pod node selector | `{}` |
| `readinessProbe` | Readiness probe configuration | (see values.yaml) |
| `livenessProbe` | Liveness probe configuration | (see values.yaml) |
| `startupProbe` | Startup probe configuration | (see values.yaml) |
| `initContainers` | Init containers configuration | (see values.yaml) |
| `extraInitContainers` | Extra init containers | `{}` |
| `extraContainers` | Extra main containers | `[]` |
| `extraVolumes` | Extra volumes for the Pod | `[]` |
| `extraVolumeMounts` | Extra volume mounts for containers | `[]` |
| `caCerts.enabled` | Enable custom CA certs | `false` |
| `initSysctl.enabled` | Enable Sysctl init container | `false` |
| `initFs.enabled` | Enable InitFs init container | `false` |
| `prometheusExporter.enabled` | Enable Prometheus JMX Exporter | `false` |
| `prometheusMonitoring.podMonitor.enabled` | Enable Prometheus Operator PodMonitor | `false` |
| `plugins.install` | List of plugins to install | `[]` |
| `jvmOpts` | Additional JVM options | `""` |
| `monitoringPasscode` | Passcode for liveness/readiness probes | `""` |
| `env` | Environment variables | `[]` |
| `annotations` | Pod annotations | `{}` |
| `resources` | Pod resource requests/limits | (see values.yaml) |
| `persistence.enabled` | Enable persistence | `false` |
| `persistence.storageClass` | Storage class for PVC | `null` |
| `persistence.accessMode` | PVC access mode | `ReadWriteOnce` |
| `persistence.size` | PVC size | `5Gi` |
| `emptyDir` | Config for emptyDir if persistence disabled | `{}` |
| `jdbcOverwrite.enabled` | Enable external JDBC configuration | `true` |
| `jdbcOverwrite.jdbcUrl` | JDBC URL for external database | `""` |
| `jdbcOverwrite.jdbcUsername` | JDBC username | `""` |
| `jdbcOverwrite.jdbcSecretName` | Secret name containing DB password | `""` |
| `postgresql.enabled` | Enable embedded PostgreSQL | `false` |
| `podLabels` | Additional labels for pods | `{}` |
| `tests.enabled` | Enable test hook | `true` |
| `serviceAccount.create` | Create Service Account | `false` |
| `serviceAccount.name` | Service Account name | `""` |
| `extraConfig` | Extra secrets/configmaps to mount | `{}` |
| `terminationGracePeriodSeconds` | Pod termination grace period | `60` |
<!-- END_TF_DOCS -->
