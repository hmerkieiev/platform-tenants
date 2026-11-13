terraform {
  required_version = ">= 1.10"

  # Own state. Destroying the workload does not destroy the namespace or the cluster.
  backend "local" {}

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.17, < 3.0"
    }
  }
}
