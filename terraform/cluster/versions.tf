terraform {
  required_version = ">= 1.10"

  # Local state. This tree has no account identifier, so it has no remote bucket.
  # The manual workflow applies this stack and destroys it before the job ends.
  backend "local" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0, < 7.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.17, < 3.0"
    }
  }
}
