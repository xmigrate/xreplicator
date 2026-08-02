# XReplicator Frontend Container

Build from the frontend source directory:

```bash
docker build --platform linux/amd64 -t ghcr.io/xmigrate/xreplicator-frontend:dev -f container/frontend/Dockerfile /path/to/replicator/web/frontend
```

The GitHub Actions workflow expects a release asset or manual `source_url`
containing the contents of `replicator/web/frontend`.
