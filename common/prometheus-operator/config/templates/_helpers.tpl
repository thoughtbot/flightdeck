{{/*
Expand the name of the chart.
*/}}
{{- define "config.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name
https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/templates/_helpers.tpl#L14
*/}}
{{- define "kube-prometheus-stack.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 26 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "kube-prometheus-stack" .Values.nameOverride -}}
{{- if contains $name .Values.kubePrometheusStackRelease -}}
{{- .Values.kubePrometheusStackRelease | trunc 26 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Values.kubePrometheusStackRelease $name | trunc 26 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Fullname suffixed with prometheus
https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/templates/_helpers.tpl#L32
*/}}
{{- define "kube-prometheus-stack.prometheus.fullname" -}}
{{- printf "%s-prometheus" (include "kube-prometheus-stack.fullname" .) -}}
{{- end }}

{{/*
Create a fully qualified stateful set name.
https://github.com/prometheus-operator/prometheus-operator/blob/main/pkg/prometheus/statefulset.go#L86
*/}}
{{- define "prometheus.statefulsetname" -}}
{{- if (eq .shard 0) }}
{{- include "prometheus.statefulsetbase" . }}
{{- else }}
{{- printf "%s-shard-%d" (include "prometheus.statefulsetbase" . | trunc 63 | trimSuffix "-") .shard }}
{{- end }}
{{- end }}


{{/*
Create a stateful set name without shard.
*/}}
{{- define "prometheus.statefulsetbase" -}}
{{- printf "prometheus-%s" (include "kube-prometheus-stack.prometheus.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "config.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "config.labels" -}}
helm.sh/chart: {{ include "config.chart" . }}
{{- if .Values.version }}
app.kubernetes.io/version: {{ .Values.version | quote }}
{{- end }}
app.kubernetes.io/name: {{ include "config.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
