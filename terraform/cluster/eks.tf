resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.kubernetes_version
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids              = sort(concat([for subnet in aws_subnet.public : subnet.id], [for subnet in aws_subnet.private : subnet.id]))
    endpoint_public_access  = true
    endpoint_private_access = true
  }

  # The caller that creates the cluster is the role that then uses kubectl.
  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster,
    aws_route_table_association.public,
    aws_route_table_association.private,
  ]
}
