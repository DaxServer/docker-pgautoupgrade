FROM docker.io/postgis/postgis:18-3.6-alpine AS postgis
FROM docker.io/pgautoupgrade/pgautoupgrade:18.3-alpine AS pgautoupgrade

# Save files that PostGIS copy will overwrite
RUN cp /usr/local/bin/docker-entrypoint.sh /docker-entrypoint.sh && \
    mkdir /tmp/readline && \
    find /usr/lib -name 'libreadline*' -o -name 'libhistory*' | xargs -I{} cp {} /tmp/readline/

# Copy in PostGIS libs / bins
COPY --from=postgis /_pgis*.* /
COPY --from=postgis /usr/lib /usr/lib
COPY --from=postgis /usr/local /usr/local

# Restore readline - PostGIS brings an older version incompatible with pgautoupgrade's bash
RUN cp /tmp/readline/* /usr/lib/

# Squash image
FROM scratch
COPY --from=pgautoupgrade / /
ENV PGTARGET=18
ENV PGDATA=/var/lib/postgresql/${PGTARGET}/docker
WORKDIR /var/lib/postgresql
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["postgres"]
