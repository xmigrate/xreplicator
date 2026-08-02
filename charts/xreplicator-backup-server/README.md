# xreplicator-backup-server Helm Chart

Install:

```bash
helm upgrade --install xreplicator-backup-server ./charts/xreplicator-backup-server \
  --namespace xreplicator --create-namespace
```

By default, the chart installs PostgreSQL and MinIO inside the cluster. Create
only the TLS and license secrets before installing. The chart also deploys the
web UI as a separate frontend service.

Default images:

```text
ghcr.io/xmigrate/xreplicator-backup-server:latest
ghcr.io/xmigrate/xreplicator-frontend:latest
```

```bash
kubectl -n xreplicator create secret generic xreplicator-license \
  --from-file=license.json=./license.json

kubectl -n xreplicator create secret generic xreplicator-tls \
  --from-file=tls.crt=./server.crt \
  --from-file=tls.key=./server.key \
  --from-file=ca.crt=./ca.crt
```

For active-active, keep `replicaCount >= 2`, PostgreSQL metadata, and object
storage enabled. For a single-replica Kubernetes deployment, set:

```yaml
replicaCount: 1
server:
  activeActive: false
  storageBackend: local
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
