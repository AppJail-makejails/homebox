ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/core:${FREEBSD_RELEASE}

ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="HomeBox" \
    org.opencontainers.image.description="Inventory and organization system built for the Home User" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/homebox" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/homebox" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    pkg update; \
    pkg install -U homebox; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/* /var/db/pkg/repos/*; \
    fi

ENV HBOX_MODE=production
ENV HBOX_STORAGE_CONN_STRING=file:///?no_tmp_dir=true
ENV HBOX_STORAGE_PREFIX_PATH=data
ENV HBOX_DATABASE_SQLITE_PATH=/data/homebox.db?_pragma=busy_timeout=2000&_pragma=journal_mode=WAL&_fk=1&_time_format=sqlite

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh && \
    mkdir -p /data

EXPOSE 7745

VOLUME ["/data"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/data/config.yml"]
