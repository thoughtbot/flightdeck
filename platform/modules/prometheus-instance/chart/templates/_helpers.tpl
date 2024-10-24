{{/*
Expand the name of the chart.
*/}}
{{- define "prometheus.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "prometheus.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/* Prometheus custom resource instance name */}}
{{- define "prometheus.crname" -}}
{{- if .Values.cleanPrometheusOperatorObjectNames }}
{{- include "prometheus.fullname" . }}
{{- else }}
{{- print (include "prometheus.fullname" .) "-prometheus" }}
{{- end }}
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
{{- printf "prometheus-%s" (include "prometheus.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "prometheus.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "prometheus.labels" -}}
helm.sh/chart: {{ include "prometheus.chart" . }}
{{ include "prometheus.selectorLabels" . }}
{{- if .Values.version }}
app.kubernetes.io/version: {{ .Values.version | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "prometheus.selectorLabels" -}}
app.kubernetes.io/name: {{ include "prometheus.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "prometheus.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "prometheus.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
