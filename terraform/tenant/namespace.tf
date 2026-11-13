resource "kubernetes_namespace" "tenant" {
  metadata {
    name = "tenant-${var.name}"
    labels = {
      "platform-tenants/tenant"            = var.name
      "pod-security.kubernetes.io/enforce" = "baseline"
      "app.kubernetes.io/instance"         = var.name
      "app.kubernetes.io/part-of"          = "platform-tenants"
      "app.kubernetes.io/managed-by"       = "platform-tenants"
    }
  }
}
