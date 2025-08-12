{{- define "cast-service.name" -}}
cast-service
{{- end -}}

{{- define "cast-service.fullname" -}}
{{- printf "%s-%s" .Release.Name "cast-service" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
