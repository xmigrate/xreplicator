# XReplicator Frontend Container

Build from the packaged standalone web directory:

```bash
tar xzf xreplicator-web-1.4.3.tar.gz
docker build --platform linux/amd64 -t ghcr.io/xmigrate/xreplicator-frontend:dev -f container/frontend/Dockerfile web
```

The GitHub Actions workflow expects a release asset or manual `source_url`
containing the standalone `web` package from the Replicator release pipeline.
