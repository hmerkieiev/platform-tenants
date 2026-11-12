{{- define "tenant.assert" -}}
{{- if not (regexMatch "^[a-z][a-z0-9]{2,15}$" .Values.name) -}}
{{- fail "name must be a short lowercase word" -}}
{{- end -}}
{{- if has .Values.name (list "internal" "default" "platform" "kube-system" "kube-public" "kube-node-lease" "ingress-nginx" "calico-system" "argocd") -}}
{{- fail "that name is reserved by the platform" -}}
{{- end -}}
{{- if not (regexMatch "^[a-z0-9-]+\\.demo\\.test$" .Values.host) -}}
{{- fail "host must be under demo.test" -}}
{{- end -}}
{{- if not (regexMatch "^[a-z0-9][a-z0-9._/-]*:[A-Za-z0-9][A-Za-z0-9._-]*$" .Values.image) -}}
{{- fail "image needs a pinned tag" -}}
{{- end -}}
{{- if eq (last (splitList ":" .Values.image)) "latest" -}}
{{- fail "latest is not a release" -}}
{{- end -}}
{{- if or (not .Values.quota.pods) (not .Values.quota.cpu) (not .Values.quota.memory) -}}
{{- fail "quota pods, cpu, and memory are required" -}}
{{- end -}}
{{- end -}}

{{/* The prefix keeps a tenant from occupying a platform namespace, including internal. */}}
{{- define "tenant.ns" -}}
{{- include "tenant.assert" . -}}
{{- printf "tenant-%s" .Values.name -}}
{{- end -}}

{{- define "tenant.labels" -}}
app.kubernetes.io/instance: {{ .Values.name }}
app.kubernetes.io/part-of: platform-tenants
app.kubernetes.io/managed-by: platform-tenants
{{- end -}}
