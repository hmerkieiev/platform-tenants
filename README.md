# platform-tenants

A local stand for one idea: a team gets a tenant on a shared cluster by committing one file, and that file cannot touch the cluster or a neighbor.

This is a portfolio example with invented tenant names. It is not an employer's platform, and it contains no account identifiers. Measurement and error budgets live in [sli-slo-baseline](https://github.com/hmerkieiev/sli-slo-baseline). This repository does not page on burn.

## The contract

An environment is the cluster. A tenant is a file in `tenants/`. A second tenant does not create a second cluster.

```yaml
name: cedar
host: cedar.demo.test
image: platform-tenants-app:1.0.0
quota:
  pods: "4"
  cpu: 500m
  memory: 256Mi
```

`charts/tenant` renders the namespace, the quota, a default-deny NetworkPolicy, Redis, the app, and an ingress. Platform addons (Calico, Traefik) are installed by `scripts/demo`. The tenant chart does not render them.

`gitops/project.yaml` is the same rule for Argo CD: a tenant Application may create a Namespace, and no other cluster-scoped kind. `gitops/applicationset.yaml` turns one file into one Application. The local demo applies the chart itself, so it can run before this repository has a remote.

## What a tenant may change

The four fields in that file. `scripts/platform tenant create` writes only the file.

```sh
scripts/platform tenant create birch \
  --host birch.demo.test \
  --image platform-tenants-app:1.0.0 \
  --pods 4 --cpu 500m --memory 256Mi
```

An image bump is a new tag in that file. The running process answers `<tenant> <version>`, and the version is baked into the image, so the tag is the release.

## What only the platform may change

The chart, the network policy, the Redis contract, the ingress class, and the cluster addons. A tenant file is rejected when it carries any other key, so it cannot set a CNI or a VPC CIDR. The rendered chart is rejected when it contains a ClusterRole or any namespace other than `tenant-<name>`.

Redis has no password. The wall is the policy: a pod may talk to pods in its own namespace, and it may make DNS queries. It may not open a neighbor's Redis. The app port accepts traffic only from the ingress namespace.

The fixed name is `redis-sessions.internal`. It resolves because the pod hostname is `redis-sessions` and the headless Service in that namespace is named `internal`. Tenant pods use `dnsPolicy: ClusterFirst` and `ndots` of 2. At `ndots` 1, a name that already contains a dot is looked up as a final name and misses the search path.

The name `internal` is reserved. A namespace with that name would make `redis-sessions.internal` a cluster-wide record and steal every tenant's Redis. The chart also prefixes namespaces with `tenant-`, so a tenant file cannot occupy `traefik` or `internal` even if the denylist were bypassed.

Quota has a floor of 2 pods, 200m, and 128Mi, because the tenant runs an app and Redis. The tag `latest` is not a release.

## Run

Docker, kubectl, Helm, and Python 3. `scripts/demo` downloads kind if it is missing. The first run pulls Calico, Traefik, and the Redis image.

```sh
scripts/demo
scripts/demo down
```

The script restores your previous kubectl context. While the cluster is up:

```sh
curl -H 'Host: cedar.demo.test' http://127.0.0.1:8090/
kubectl --context kind-platform-tenants get ns
```

Green means both of these held:

1. `birch` appeared from one new file, answered on `birch.demo.test`, and could not open cedar's Redis. Cedar was unchanged.
2. Cedar's image moved to `1.1.0`. Maple and birch stayed on `1.0.0`. The Traefik and Calico images stayed put.

`scripts/platform check` is the same contract without a cluster. It is the fast half of the script.

On an account, two Terraform roots replace the cluster bootstrap. `terraform/cluster` is the network, the cluster, and Traefik. `terraform/tenant` opens one namespace, and `terraform/tenant/isolated` installs that tenant's chart in its own state. The tenant file does not choose the CNI or the load balancer. See [docs/aws.md](docs/aws.md).

## License

[MIT](LICENSE)
