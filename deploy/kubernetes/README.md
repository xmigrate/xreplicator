# XReplicator Backup Server on Kubernetes

These manifests run the backup server as an active-active StatefulSet.
They also deploy the web UI as a separate frontend Deployment.

The default raw manifests include PostgreSQL and MinIO. For production
environments that already have managed PostgreSQL or object storage, edit
`secrets.example.yaml` and `backup-server.yaml` to point at the external
services instead, and skip `postgres-minio.yaml`.

Prepare/mount restore requires the backup-server pod to run privileged as root
with host `/dev` mounted. The raw manifests enable this by default so
dynamically-created loop devices are visible inside the container.

Apply:

```bash
kubectl apply -f namespace.yaml
kubectl apply -f secrets.example.yaml
kubectl apply -f postgres-minio.yaml
kubectl apply -f backup-server.yaml
kubectl apply -f frontend.yaml
```

Edit `secrets.example.yaml` before applying. Do not commit real secrets.

Agent endpoint:

```text
xreplicator-backup-server.xreplicator.svc.cluster.local:50051
```

Web UI endpoint:

```text
xreplicator-frontend.xreplicator.svc.cluster.local
```

For external users, expose the `xreplicator-frontend` Service with your HTTP
load balancer or ingress controller.

For external agents, expose the `xreplicator-backup-server` Service with your
cloud load balancer or ingress controller's TCP/L4 support.
