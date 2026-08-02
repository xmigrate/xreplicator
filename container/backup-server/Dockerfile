FROM alpine:3.20

RUN apk add --no-cache ca-certificates tzdata netcat-openbsd

RUN addgroup -g 10001 -S xreplicator && adduser -u 10001 -S -G xreplicator xreplicator

WORKDIR /app

ARG BINARY=backup
COPY ${BINARY} /app/backup
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /app/backup /entrypoint.sh && \
    mkdir -p /var/lib/xreplicator /etc/xreplicator && \
    chown -R xreplicator:xreplicator /var/lib/xreplicator /etc/xreplicator /app

USER xreplicator

EXPOSE 50051 9090

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD nc -z 127.0.0.1 50051 || exit 1

ENTRYPOINT ["/entrypoint.sh"]
