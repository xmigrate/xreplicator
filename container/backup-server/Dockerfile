FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

ARG PACKAGE=backup.deb
COPY ${PACKAGE} /tmp/backup.deb
COPY entrypoint.sh /entrypoint.sh

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates tzdata netcat-openbsd && \
    (dpkg -i /tmp/backup.deb || apt-get -f install -y --no-install-recommends) && \
    rm -rf /var/lib/apt/lists/* /tmp/backup.deb && \
    groupadd --system --gid 10001 xreplicator && \
    useradd --system --uid 10001 --gid xreplicator --home-dir /nonexistent --shell /usr/sbin/nologin xreplicator && \
    ln -sf "$(command -v backup)" /app/backup && \
    chmod +x /entrypoint.sh && \
    mkdir -p /var/lib/xreplicator /etc/xreplicator && \
    chown -R xreplicator:xreplicator /var/lib/xreplicator /etc/xreplicator /app

USER xreplicator

EXPOSE 50051 9090

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD nc -z 127.0.0.1 50051 || exit 1

ENTRYPOINT ["/entrypoint.sh"]
