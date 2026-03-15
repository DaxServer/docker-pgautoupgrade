FROM docker.io/postgis/postgis:18-3.6-alpine AS postgis
FROM docker.io/pgautoupgrade/pgautoupgrade:18.3-alpine AS pgautoupgrade

# Original entrypoint overwritten in /usr/local/bin, so copy elsewhere
RUN cp /usr/local/bin/docker-entrypoint.sh /docker-entrypoint.sh

# Copy in PostGIS libs / bins
COPY --from=postgis /_pgis*.* /
COPY --from=postgis /usr/lib /usr/lib
COPY --from=postgis /usr/local /usr/local

# Squash image
FROM scratch
COPY --from=pgautoupgrade / /
ENV \
    PGTARGET=18 \
    PGDATA=/var/lib/postgresql/data
WORKDIR /var/lib/postgresql
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["postgres"]
