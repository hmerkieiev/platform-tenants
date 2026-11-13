# The platform application. Tenant charts name the class traefik and do not install this.
resource "helm_release" "traefik" {
  count = var.install_platform ? 1 : 0

  name             = "traefik"
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  version          = var.traefik_chart_version
  namespace        = "traefik"
  create_namespace = true
  timeout          = 600

  values = [yamlencode({
    deployment = {
      replicas = 2
    }
    ingressClass = {
      enabled        = true
      isDefaultClass = true
      name           = "traefik"
    }
    providers = {
      kubernetesIngress = {
        ingressClass = "traefik"
      }
      kubernetesGateway = {
        enabled = false
      }
    }
    gateway = {
      enabled = false
    }
    gatewayClass = {
      enabled = false
    }
    ports = {
      web = {
        asDefault = true
      }
      websecure = {
        expose = {
          default = false
        }
      }
    }
    service = {
      annotations = {
        "service.beta.kubernetes.io/aws-load-balancer-type"   = "nlb"
        "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
      }
      spec = {
        type = "LoadBalancer"
        # Local drops health checks that land on the node without a pod.
        externalTrafficPolicy = "Cluster"
      }
    }
  })]

  depends_on = [
    aws_eks_addon.vpc_cni,
    aws_eks_addon.coredns,
    aws_eks_node_group.nodes,
  ]
}
