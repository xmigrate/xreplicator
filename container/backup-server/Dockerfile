FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

ARG PACKAGE=backup.deb
COPY ${PACKAGE} /tmp/backup.deb
COPY entrypoint.sh /entrypoint.sh

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates tzdata netcat-openbsd systemd && \
    mv /usr/bin/systemctl /usr/bin/systemctl.real && \
    printf '#!/bin/sh\nexit 0\n' > /usr/bin/systemctl && \
    chmod +x /usr/bin/systemctl && \
    apt-get install -y --no-install-recommends lvm2 && \
    dpkg -i /tmp/backup.deb && \
    mv /usr/bin/systemctl.real /usr/bin/systemctl && \
    rm -rf /var/lib/apt/lists/* /tmp/backup.deb && \
    groupadd --system --gid 10001 xreplicator && \
    useradd --system --uid 10001 --gid xreplicator --home-dir /nonexistent --shell /usr/sbin/nologin xreplicator && \
    ln -sf "$(command -v xreplicator)" /app/backup && \
    chmod +x /entrypoint.sh && \
    mkdir -p /var/lib/xreplicator /etc/xreplicator && \
    chown -R xreplicator:xreplicator /var/lib/xreplicator /etc/xreplicator /app

USER xreplicator

EXPOSE 50051 9090

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD nc -z 127.0.0.1 50051 || exit 1

ENTRYPOINT ["/entrypoint.sh"]
