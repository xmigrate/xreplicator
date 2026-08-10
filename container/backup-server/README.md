# Backup Server Container

This image installs the released backup server `.deb` package and runs `backup server`.

Build locally:

```bash
cp /path/to/backup-server.deb ./container/backup-server/backup.deb
docker build --platform linux/amd64 -t ghcr.io/xmigrate/xreplicator-backup-server:dev ./container/backup-server
```

The container renders `server.yaml` from environment variables at startup so
Kubernetes can provide stable StatefulSet pod identities and peer DNS names.

Minimum HA configuration:

- `XREPLICATOR_POSTGRES_DSN`
- `XREPLICATOR_OBJECT_ENDPOINT`
- `XREPLICATOR_OBJECT_BUCKET`
- `XREPLICATOR_OBJECT_ACCESS_KEY`
- `XREPLICATOR_OBJECT_SECRET_KEY`
- TLS secret mounted at `/etc/xreplicator/tls`
- license secret mounted at `/etc/xreplicator/license/license.json`
