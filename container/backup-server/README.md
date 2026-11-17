# Backup Server Container

This image installs the released backup server `.deb` package and runs `backup server`.

For a manual run of **Backup Server Container Image**, enter the release version
(for example, `1.5.0` or `v1.5.0`) and leave `package_url` empty. The workflow
discovers the amd64 backup server `.deb` in this repository's release and
downloads it using the GitHub token. Set `package_url` only to override release
discovery with an explicit HTTPS download URL.

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
