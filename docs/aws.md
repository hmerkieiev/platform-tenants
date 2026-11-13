# What changes on an account

This stand runs on kind so the tenant contract can be tested on a laptop.

On an account, the same contract sits on a different substrate. The cluster network is the VPC CNI, with network policy enforcement turned on, because policy is the only wall when Redis has no password. The public entry is a load balancer on the public subnets, not a host port. Addresses are written out explicitly: one /16 for the environment, `10.200.0.0/16`, taken from a /12 that belongs to the account. The tenant file does not choose those addresses, the CNI, or the load balancer.

Adopting a VPC that already has an internet gateway is a separate change from adding a tenant. The gateway stays. A tenant commit cannot replace it, because the tenant chart is not allowed to render cluster-scoped objects other than its own namespace.

CI on `main` assumes the role `platform-tenants-ci` through GitHub's OIDC provider. The trust is this repository and that one branch. The subject is the immutable form GitHub issues for this repository. The role ARN is a GitHub variable and the account id is a GitHub secret, so this tree still has neither. The workflows mask that secret before the first AWS call. `.github/workflows/aws-identity.yml` checks that the assumed role name is `platform-tenants-ci` and does not print the identifier.

`.github/workflows/aws-cluster.yml` is a manual run. It applies `terraform/cluster`, runs the tenant checks, and destroys that stack before the job ends. The first apply creates the network and the cluster with `install_platform` false. The second apply installs Traefik, which is the platform application: tenant Ingress objects name the class `traefik` and do not install a controller. Nodes sit in one zone behind one NAT. The controller Service is a network load balancer.

`terraform/tenant` opens one tenant. It creates the namespace `tenant-<name>` and records the host, the image, and the quota. `terraform/tenant/isolated` is a separate state that only installs `charts/tenant` into that namespace. It reads the tenant stack and has no VPC and no cluster resource. A second tenant is a second state of those two roots, not a second cluster. The workflow's checks still render the chart from the tenant files, so a new file and an image bump stay a chart apply. The role that applies the cluster is the role that calls the API.

This repository does not contain that account.
