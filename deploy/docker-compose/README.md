# Docker Compose Quickstart

This quickstart runs the XReplicator frontend, backup server, PostgreSQL, and
MinIO on one Docker host.

It is intended for trials and labs. Use the Helm chart or Kubernetes manifests
for production Kubernetes deployments.

## Prerequisites

- Docker with Docker Compose
- An XReplicator license at `license/license.json`
- TLS files at `tls/ca.crt`, `tls/tls.crt`, and `tls/tls.key`

For a local test certificate:

```bash
mkdir -p tls license
openssl req -x509 -newkey rsa:4096 -nodes -days 365 \
  -keyout tls/tls.key \
  -out tls/tls.crt \
  -subj "/CN=backup-server.xmigrate.com" \
  -addext "subjectAltName=DNS:backup-server.xmigrate.com,DNS:backup-server,IP:127.0.0.1"
cp tls/tls.crt tls/ca.crt
```

Place your license JSON at:

```text
license/license.json
```

## Start

```bash
cp .env.example .env
docker compose up -d
```

The services listen on:

```text
Frontend:      http://localhost:3000
Backup gRPC:   localhost:50051
Metrics:       http://localhost:9090
MinIO API:     http://localhost:9000
MinIO console: http://localhost:9001
PostgreSQL:    localhost:5432
```

Agents should use `localhost:50051` for a local test host. If the agent
validates the server name, use `backup-server.xmigrate.com` and map it to the
Docker host address.

## Stop

```bash
docker compose down
```

To remove local data:

```bash
docker compose down -v
```
