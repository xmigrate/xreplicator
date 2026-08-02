#!/bin/sh
set -eu

: "${XREPLICATOR_LISTEN_ADDR:=0.0.0.0:50051}"
: "${XREPLICATOR_REPOSITORY_PATH:=/var/lib/xreplicator/repository}"
: "${XREPLICATOR_FIXED_BLOCK_SIZE_MB:=16}"
: "${XREPLICATOR_LOG_LEVEL:=info}"
: "${XREPLICATOR_METADATA_BACKEND:=postgres}"
: "${XREPLICATOR_STORAGE_BACKEND:=object}"
: "${XREPLICATOR_ACTIVE_ACTIVE:=true}"
: "${XREPLICATOR_METRICS_LISTEN_ADDR:=:9090}"
: "${XREPLICATOR_TLS_ENABLED:=true}"
: "${XREPLICATOR_TLS_SERVER_NAME:=backup-server.xmigrate.com}"
: "${XREPLICATOR_TLS_REQUIRE_CLIENT_CERT:=true}"
: "${XREPLICATOR_STAGING_PACK_WORKERS:=0}"
: "${XREPLICATOR_STAGING_IDLE_PACK_WORKERS:=2}"
: "${XREPLICATOR_DR_WORKERS:=1}"
: "${XREPLICATOR_LICENSE_FILE:=/etc/xreplicator/license/license.json}"
: "${XREPLICATOR_CONFIG_FILE:=/tmp/xreplicator-server.yaml}"

if [ -z "${XREPLICATOR_INSTANCE_ID:-}" ]; then
  XREPLICATOR_INSTANCE_ID="$(hostname)"
fi

if [ -z "${XREPLICATOR_ADVERTISE_ADDR:-}" ]; then
  if [ -n "${POD_NAME:-}" ] && [ -n "${XREPLICATOR_HEADLESS_SERVICE:-}" ] && [ -n "${POD_NAMESPACE:-}" ]; then
    XREPLICATOR_ADVERTISE_ADDR="${POD_NAME}.${XREPLICATOR_HEADLESS_SERVICE}.${POD_NAMESPACE}.svc.cluster.local:50051"
  else
    XREPLICATOR_ADVERTISE_ADDR="${XREPLICATOR_LISTEN_ADDR}"
  fi
fi

cat > "${XREPLICATOR_CONFIG_FILE}" <<EOF
server:
  listen_addr: "${XREPLICATOR_LISTEN_ADDR}"
  advertise_addr: "${XREPLICATOR_ADVERTISE_ADDR}"
  repository_path: "${XREPLICATOR_REPOSITORY_PATH}"
  fixed_block_size_mb: ${XREPLICATOR_FIXED_BLOCK_SIZE_MB}
  log_level: "${XREPLICATOR_LOG_LEVEL}"
  instance_id: "${XREPLICATOR_INSTANCE_ID}"
  mount_tmp_dir: "${XREPLICATOR_REPOSITORY_PATH}/mounts"

metadata:
  backend: "${XREPLICATOR_METADATA_BACKEND}"
  postgres_dsn: "${XREPLICATOR_POSTGRES_DSN:-}"
  postgres_max_open_conns: ${XREPLICATOR_POSTGRES_MAX_OPEN_CONNS:-50}
  postgres_max_idle_conns: ${XREPLICATOR_POSTGRES_MAX_IDLE_CONNS:-50}

storage:
  backend: "${XREPLICATOR_STORAGE_BACKEND}"
  local_path: "${XREPLICATOR_REPOSITORY_PATH}/storage"
  secrets_mode: "${XREPLICATOR_OBJECT_SECRETS_MODE:-standalone}"
  object:
    name: "${XREPLICATOR_OBJECT_NAME:-server-repository}"
    provider: "${XREPLICATOR_OBJECT_PROVIDER:-s3}"
    endpoint: "${XREPLICATOR_OBJECT_ENDPOINT:-}"
    bucket: "${XREPLICATOR_OBJECT_BUCKET:-}"
    prefix: "${XREPLICATOR_OBJECT_PREFIX:-repo}"
    use_ssl: ${XREPLICATOR_OBJECT_USE_SSL:-true}
    credentials:
      static:
        access_key: "${XREPLICATOR_OBJECT_ACCESS_KEY:-}"
        secret_key: "${XREPLICATOR_OBJECT_SECRET_KEY:-}"
        session_token: "${XREPLICATOR_OBJECT_SESSION_TOKEN:-}"

staging:
  pack_workers: ${XREPLICATOR_STAGING_PACK_WORKERS}
  idle_pack_workers: ${XREPLICATOR_STAGING_IDLE_PACK_WORKERS}
  high_watermark_percent: ${XREPLICATOR_STAGING_HIGH_WATERMARK_PERCENT:-90}
  low_watermark_percent: ${XREPLICATOR_STAGING_LOW_WATERMARK_PERCENT:-80}
  pack_cache_max_bytes: ${XREPLICATOR_PACK_CACHE_MAX_BYTES:-0}
  pack_gc_interval: "${XREPLICATOR_PACK_GC_INTERVAL:-10m}"
  pack_gc_safety_age: "${XREPLICATOR_PACK_GC_SAFETY_AGE:-24h}"
  pack_gc_batch_size: ${XREPLICATOR_PACK_GC_BATCH_SIZE:-10}

ha:
  active_active: ${XREPLICATOR_ACTIVE_ACTIVE}

observability:
  metrics_listen_addr: "${XREPLICATOR_METRICS_LISTEN_ADDR}"

tls:
  enabled: ${XREPLICATOR_TLS_ENABLED}
  cert_file: "${XREPLICATOR_TLS_CERT_FILE:-/etc/xreplicator/tls/tls.crt}"
  key_file: "${XREPLICATOR_TLS_KEY_FILE:-/etc/xreplicator/tls/tls.key}"
  ca_file: "${XREPLICATOR_TLS_CA_FILE:-/etc/xreplicator/tls/ca.crt}"
  server_name: "${XREPLICATOR_TLS_SERVER_NAME}"
  peer_cert_file: "${XREPLICATOR_TLS_PEER_CERT_FILE:-/etc/xreplicator/tls/tls.crt}"
  peer_key_file: "${XREPLICATOR_TLS_PEER_KEY_FILE:-/etc/xreplicator/tls/tls.key}"
  require_client_cert: ${XREPLICATOR_TLS_REQUIRE_CLIENT_CERT}
  insecure_skip_verify: ${XREPLICATOR_TLS_INSECURE_SKIP_VERIFY:-false}

security:
  immutable_retention_window: "${XREPLICATOR_IMMUTABLE_RETENTION_WINDOW:-720h}"
  audit_retention_days: ${XREPLICATOR_AUDIT_RETENTION_DAYS:-365}
  block_churn_anomaly:
    enabled: ${XREPLICATOR_BLOCK_CHURN_ANOMALY_ENABLED:-true}
    high_change_percent: ${XREPLICATOR_BLOCK_CHURN_HIGH_CHANGE_PERCENT:-80}
    min_history: ${XREPLICATOR_BLOCK_CHURN_MIN_HISTORY:-3}

dr:
  workers: ${XREPLICATOR_DR_WORKERS}

license:
  file_path: "${XREPLICATOR_LICENSE_FILE}"

cloud:
  config_path: "${XREPLICATOR_REPOSITORY_PATH}/cloud-config.yaml"

tenancy:
  config_path: "${XREPLICATOR_REPOSITORY_PATH}/orgs.db"

notifications:
  enabled: false

restore_verification:
  enabled: false
  verify_after_backup: false
EOF

exec /app/backup server --config "${XREPLICATOR_CONFIG_FILE}" --license "${XREPLICATOR_LICENSE_FILE}" --instance-id "${XREPLICATOR_INSTANCE_ID}"
