# What changes on an account

This stand runs on kind so the tenant contract can be tested on a laptop.

On an account, the same contract sits on a different substrate. The cluster network is the VPC CNI, with network policy enforcement turned on, because policy is the only wall when Redis has no password. The public entry is an ALB on the public subnets, not a host port. Addresses are written out explicitly: one /16 for the environment, taken from a /12 that belongs to the account. The tenant file does not choose those addresses, the CNI, or the load balancer.

Adopting a VPC that already has an internet gateway is a separate change from adding a tenant. The gateway stays. A tenant commit cannot replace it, because the tenant chart is not allowed to render cluster-scoped objects other than its own namespace.

CI on `main` assumes the role `platform-tenants-ci` through GitHub's OIDC provider. The trust is this repository and that one branch. The role ARN is a GitHub variable, so this tree still has no account identifier. The role cannot create resources yet. `.github/workflows/aws-identity.yml` checks that the assume succeeds.

This repository does not contain that account and does not apply the cluster.
