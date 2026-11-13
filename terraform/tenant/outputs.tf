output "namespace" {
  value = kubernetes_namespace.tenant.metadata[0].name
}

output "name" {
  value = var.name
}

output "host" {
  value = var.host
}

output "image" {
  value = var.image
}

output "quota" {
  value = var.quota
}

output "cluster_name" {
  value = local.cluster_name
}

output "region" {
  value = local.region
}

output "cluster_endpoint" {
  value = local.cluster_endpoint
}

output "cluster_ca" {
  value = local.cluster_ca
}
