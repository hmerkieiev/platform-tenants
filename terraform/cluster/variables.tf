variable "region" {
  description = "Region for the cluster. Nodes stay in the first AZ."
  type        = string
  default     = "eu-north-1"
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
  default     = "platform-tenants"
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version in standard support."
  type        = string
  default     = "1.35"
}

variable "vpc_cidr" {
  description = "One /16 for this environment. The tenant file cannot change it."
  type        = string
  default     = "10.200.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDRs by AZ. Load balancers land here."
  type        = map(string)
  default = {
    "eu-north-1a" = "10.200.0.0/24"
    "eu-north-1b" = "10.200.1.0/24"
  }
}

variable "private_subnets" {
  description = "Private subnet CIDRs by AZ. The VPC CNI gives every pod an address from these."
  type        = map(string)
  default = {
    "eu-north-1a" = "10.200.32.0/19"
    "eu-north-1b" = "10.200.64.0/19"
  }
}

variable "node_az" {
  description = "The only AZ that runs nodes. The control plane still needs two AZ subnets."
  type        = string
  default     = "eu-north-1a"
}

variable "install_platform" {
  description = "Install Traefik. The first apply is false, so the API exists before Helm connects."
  type        = bool
  default     = true
}

variable "traefik_chart_version" {
  description = "Traefik chart. The kind demo pins the same version in platform/versions.env."
  type        = string
  default     = "42.4.0"
}
