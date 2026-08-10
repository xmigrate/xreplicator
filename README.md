# xreplicator

This is the distribution and release repository for the xreplicator tool. Also if you want any community support, please use the Discussions section of this repository. For any commercial support, please contact `vishnu@xmigrate.cloud`.

## Product Overview

xreplicator is a production-grade block-level incremental backup system with **eBPF change tracking** for dramatically faster incrementals. It is designed for backup, restore, and disaster recovery using innovative incremental backup techniques, with a goal of **zero data loss**.

### Key Capabilities

- **eBPF-accelerated incrementals** that track only changed blocks at the kernel level
- **Automatic scheduling** for full and incremental backups
- **Deduplication and compression** to reduce storage
- **Recovery mode** for crash/power-loss scenarios
- **Multi-filesystem support** (ext4 and XFS)
- **Production-ready** operations (systemd integration, monitoring, graceful shutdown)

## Licensing And Support

- Always free for up to **5 VMs**.
- **1 year free** for companies impacted by geopolitical instability.
- Use **Discussions in this project** to get support for any issue you face.
- For a **community license** or **war license**, contact `vishnu@xmigrate.cloud`.

## Links

- Website: xmigrate.cloud
- Docs: xmigrate.cloud/docs

## Kubernetes Distribution

The backup server can run in Kubernetes. The Helm chart defaults to bundled
PostgreSQL and MinIO for a self-contained install. Customers can disable those
components and point the chart at external PostgreSQL and S3-compatible object
storage.

Distribution artifacts:

- Runtime image packaging: `container/backup-server`, `container/frontend`
- Raw Kubernetes manifests: `deploy/kubernetes`
- Docker Compose quickstart: `deploy/docker-compose`
- Helm chart: `charts/xreplicator-backup-server`
- GitHub Actions workflows:
  - Backup server image: `.github/workflows/backup-server-image.yaml`
  - Frontend image: `.github/workflows/frontend-image.yaml`
  - Helm chart package: `.github/workflows/helm-chart.yaml`

Image:

```text
ghcr.io/xmigrate/xreplicator-backup-server:<version>
ghcr.io/xmigrate/xreplicator-frontend:<version>
ghcr.io/xmigrate/xreplicator-backup-server:latest
ghcr.io/xmigrate/xreplicator-frontend:latest
```

Helm chart:

```text
ghcr.io/xmigrate/charts/xreplicator-backup-server:<version>
```

Published releases also include the packaged chart:

```text
xreplicator-backup-server-<version>.tgz
```

Install the published Helm chart:

```bash
export VERSION=1.4.3

helm upgrade --install xreplicator \
  oci://ghcr.io/xmigrate/charts/xreplicator-backup-server \
  --version "$VERSION" \
  --namespace xreplicator \
  --create-namespace \
  --set fullnameOverride=xreplicator \
  --set image.tag="$VERSION" \
  --set frontend.image.tag="$VERSION"
```

For a single-host trial, use Docker Compose:

```bash
cd deploy/docker-compose
cp .env.example .env
docker compose up -d
```

Active-active Kubernetes deployments use a StatefulSet so each replica has a
stable identity and peer-reachable DNS name. Single-replica Kubernetes
deployments are supported by setting `replicaCount: 1` and
`server.activeActive: false` in the Helm values.
