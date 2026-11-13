# This stack reads the tenant boundary. It has no VPC and no cluster resource.
data "terraform_remote_state" "tenant" {
  backend = "local"

  config = {
    path = "${path.module}/../terraform.tfstate"
  }
}

locals {
  tenant = data.terraform_remote_state.tenant.outputs
}
