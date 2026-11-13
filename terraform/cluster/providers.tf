provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project    = "platform-tenants"
      ManagedBy  = "terraform"
      Repository = "platform-tenants"
      Stack      = "cluster"
    }
  }
}

# The endpoint is unknown until the cluster exists. Apply once with install_platform = false.
provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)

    exec {
      api_version = local.kube_exec.api_version
      command     = local.kube_exec.command
      args        = local.kube_exec.args
    }
  }
}
