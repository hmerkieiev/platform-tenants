resource "helm_release" "tenant" {
  name             = local.tenant.name
  namespace        = local.tenant.namespace
  chart            = abspath("${path.module}/../../../charts/tenant")
  create_namespace = false
  timeout          = 300

  values = [yamlencode({
    name            = local.tenant.name
    host            = local.tenant.host
    image           = local.tenant.image
    quota           = local.tenant.quota
    createNamespace = false
  })]
}
