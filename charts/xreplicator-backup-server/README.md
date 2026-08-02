# xreplicator-backup-server Helm Chart

Published chart:

```text
oci://ghcr.io/xmigrate/charts/xreplicator-backup-server
```

Install the published release:

```bash
export VERSION=1.4.3
export NAMESPACE=xreplicator
export RELEASE=xreplicator
export CHART=oci://ghcr.io/xmigrate/charts/xreplicator-backup-server

kubectl create namespace "$NAMESPACE"

kubectl -n "$NAMESPACE" create secret generic xreplicator-license \
  --from-file=license.json=./license.json

kubectl -n "$NAMESPACE" create secret generic xreplicator-tls \
  --from-file=tls.crt=./server.crt \
  --from-file=tls.key=./server.key \
  --from-file=ca.crt=./ca.crt

helm upgrade --install "$RELEASE" "$CHART" \
  --version "$VERSION" \
  --namespace "$NAMESPACE" \
  --create-namespace \
  --set fullnameOverride=xreplicator \
  --set image.tag="$VERSION" \
  --set frontend.image.tag="$VERSION"
```

The chart deploys the backup server, web UI, and optional PostgreSQL and MinIO
services. Default runtime images:

```text
ghcr.io/xmigrate/xreplicator-backup-server:<version>
ghcr.io/xmigrate/xreplicator-frontend:<version>
```

For active-active, keep `replicaCount >= 2`, PostgreSQL metadata, and object
storage enabled. For a single-replica deployment:

```yaml
replicaCount: 1
server:
  metadataBackend: postgres
  storageBackend: object
  activeActive: false
```

Supported model switches:

```yaml
server:
  metadataBackend: sqlite   # sqlite or postgres
  storageBackend: local     # local or object
  activeActive: false

postgres:
  enabled: false

minio:
  enabled: false
```

To use external PostgreSQL and object storage:

```yaml
postgres:
  enabled: false
  dsnSecretName: xreplicator-external
  dsnSecretKey: postgres-dsn

minio:
  enabled: false

objectStorage:
  endpoint: s3.amazonaws.com
  bucket: xreplicator-backups
  useSSL: true
  accessKeySecretName: xreplicator-external
  accessKeySecretKey: object-access-key
  secretKeySecretName: xreplicator-external
  secretKeySecretKey: object-secret-key

internalAuth:
  secretName: xreplicator-external

frontend:
  webSessionSecretName: xreplicator-external
```
