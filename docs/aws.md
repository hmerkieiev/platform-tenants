# What changes on an account

This stand runs on kind so the tenant contract can be tested on a laptop.

On an account, the same contract sits on a different substrate. The cluster network is the VPC CNI, with network policy enforcement turned on, because policy is the only wall when Redis has no password. The public entry is a load balancer on the public subnets, not a host port. Addresses are written out explicitly: one /16 for the environment, `10.200.0.0/16`, taken from a /12 that belongs to the account. The tenant file does not choose those addresses, the CNI, or the load balancer.

Adopting a VPC that already has an internet gateway is a separate change from adding a tenant. The gateway stays. A tenant commit cannot replace it, because the tenant chart is not allowed to render cluster-scoped objects other than its own namespace.

CI on `main` assumes the role `platform-tenants-ci` through GitHub's OIDC provider. The trust is this repository and that one branch. The subject is the immutable form GitHub issues for this repository. The role ARN is a GitHub variable, so this tree still has no account identifier. `.github/workflows/aws-identity.yml` checks that the assume succeeds.

`.github/workflows/aws-cluster.yml` is a manual run. It raises one cluster from `platform/eksctl.yaml`, applies cedar and maple, adds birch from one file, bumps cedar's image, and deletes the cluster before the job ends. Nodes sit in one zone behind one NAT. The ingress controller is published with a network load balancer. A tenant file still names only its image tag; the account registry is added when the manifest is applied.

This repository does not contain that account.
