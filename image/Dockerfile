FROM debian:12
RUN set -ex; export DEBIAN_FRONTEND=noninteractive; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    curl ca-certificates \
    procps binutils gettext-base inetutils-ping \
    openjdk-17-jre-headless; \
  curl --output-dir /tmp -sSLO https://dl.ui.com/unifi/8.6.9/unifi_sysvinit_all.deb; \
  dpkg --ignore-depends mongodb-server,logrotate --install /tmp/unifi_sysvinit_all.deb; \
  rm -rf /var/lib/apt/lists/* /tmp/*.deb
USER unifi
WORKDIR /usr/lib/unifi
COPY docker-entrypoint.sh /usr/local/bin/
