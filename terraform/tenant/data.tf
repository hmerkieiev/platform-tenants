data "terraform_remote_state" "cluster" {
  backend = "local"

  config = {
    path = "${path.module}/../cluster/terraform.tfstate"
  }
}

locals {
  cluster_name     = data.terraform_remote_state.cluster.outputs.cluster_name
  region           = data.terraform_remote_state.cluster.outputs.region
  cluster_endpoint = data.terraform_remote_state.cluster.outputs.cluster_endpoint
  cluster_ca       = data.terraform_remote_state.cluster.outputs.cluster_ca
}
