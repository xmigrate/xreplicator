{{- define "xreplicator-backup-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "xreplicator-backup-server.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "xreplicator-backup-server.name" . -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "xreplicator-backup-server.labels" -}}
app.kubernetes.io/name: {{ include "xreplicator-backup-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}

{{- define "xreplicator-backup-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "xreplicator-backup-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "xreplicator-backup-server.secretName" -}}
{{- include "xreplicator-backup-server.fullname" . -}}
{{- end -}}

{{- define "xreplicator-backup-server.postgresName" -}}
{{- printf "%s-postgres" (include "xreplicator-backup-server.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "xreplicator-backup-server.minioName" -}}
{{- printf "%s-minio" (include "xreplicator-backup-server.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "xreplicator-backup-server.frontendName" -}}
{{- printf "%s-frontend" (include "xreplicator-backup-server.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "xreplicator-backup-server.frontendLabels" -}}
app.kubernetes.io/name: {{ include "xreplicator-backup-server.frontendName" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}

{{- define "xreplicator-backup-server.frontendSelectorLabels" -}}
app.kubernetes.io/name: {{ include "xreplicator-backup-server.frontendName" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "xreplicator-backup-server.postgresSecretName" -}}
{{- default (include "xreplicator-backup-server.secretName" .) .Values.postgres.dsnSecretName -}}
{{- end -}}

{{- define "xreplicator-backup-server.objectAccessSecretName" -}}
{{- default (include "xreplicator-backup-server.secretName" .) .Values.objectStorage.accessKeySecretName -}}
{{- end -}}

{{- define "xreplicator-backup-server.objectSecretSecretName" -}}
{{- default (include "xreplicator-backup-server.secretName" .) .Values.objectStorage.secretKeySecretName -}}
{{- end -}}

{{- define "xreplicator-backup-server.internalSecretName" -}}
{{- default (include "xreplicator-backup-server.secretName" .) .Values.internalAuth.secretName -}}
{{- end -}}

{{- define "xreplicator-backup-server.webSecretName" -}}
{{- default (include "xreplicator-backup-server.secretName" .) .Values.frontend.webSessionSecretName -}}
{{- end -}}

{{- define "xreplicator-backup-server.postgresDsn" -}}
{{- printf "postgres://%s:%s@%s:5432/%s?sslmode=disable" .Values.postgres.username .Values.postgres.password (include "xreplicator-backup-server.postgresName" .) .Values.postgres.database -}}
{{- end -}}

{{- define "xreplicator-backup-server.objectEndpoint" -}}
{{- if .Values.objectStorage.endpoint -}}
{{- .Values.objectStorage.endpoint -}}
{{- else if .Values.minio.enabled -}}
{{- printf "%s:9000" (include "xreplicator-backup-server.minioName" .) -}}
{{- else -}}
{{- "" -}}
{{- end -}}
{{- end -}}
