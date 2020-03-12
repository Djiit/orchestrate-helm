{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "core-stack-worker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "core-stack-worker.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "core-stack-worker.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define serviceAccountName name
*/}}
{{- define "core-stack-worker.serviceAccountName" -}}
{{- if .Values.serviceAccount.name -}}
	{{ .Values.serviceAccount.name }}
{{- else -}}
	{{ include "core-stack-worker.fullname" . }}
{{- end -}}
{{- end -}}

{{/*
Define imageCredentials name.
*/}}
{{- define "core-stack-worker.imagePullSecretName" -}}
{{- if .Values.imageCredentials.create -}}
	{{ printf "%s-%s" (include "core-stack-worker.fullname" .) "registry" | trunc 63 | trimSuffix "-" }}
{{- else -}}
	{{ .Values.imageCredentials.name }}
{{- end -}}
{{- end -}}

{{- define "core-stack-worker.imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.imageCredentials.registry (printf "%s:%s" .Values.imageCredentials.username .Values.imageCredentials.password | b64enc) | b64enc }}
{{- end }}

{{/*
Define imageCredentials name for test.
*/}}
{{- define "core-stack-worker.imagePullSecretNameTest" -}}
{{- if .Values.testImageCredentials.create -}}
	{{ printf "%s-%s" (include "core-stack-worker.fullname" .) "registry-test" | trunc 63 | trimSuffix "-" }}
{{- else -}}
	{{ .Values.testImageCredentials.name }}
{{- end -}}
{{- end -}}

{{- define "core-stack-worker.imagePullSecretTest" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.testImageCredentials.registry (printf "%s:%s" .Values.testImageCredentials.username .Values.testImageCredentials.password | b64enc) | b64enc }}
{{- end }}