provider "helm" {
  kubernetes {
    host                   = local.tenant.cluster_endpoint
    cluster_ca_certificate = base64decode(local.tenant.cluster_ca)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks", "get-token",
        "--cluster-name", local.tenant.cluster_name,
        "--region", local.tenant.region,
      ]
    }
  }
}
