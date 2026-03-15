# docker-pgautoupgrade

Custom Docker image combining [pgautoupgrade](https://hub.docker.com/r/pgautoupgrade/pgautoupgrade) with PostGIS.

## Image

- Base: `pgautoupgrade/pgautoupgrade:18.3-alpine`
- PostGIS: `postgis/postgis:18-3.6-alpine`
- Published to: `ghcr.io/daxserver/docker-pgautoupgrade` via GitHub Actions on push to main

## Dockerfile Pattern

The `COPY --from=postgis /usr/lib /usr/lib` and `COPY --from=postgis /usr/local /usr/local` steps intentionally
overwrite pgautoupgrade's directories — this is how PostGIS extensions are merged in per the
[pgautoupgrade wiki](https://github.com/pgautoupgrade/docker-pgautoupgrade/wiki/Including-Extensions-(PostGIS)).
The entrypoint is saved to `/docker-entrypoint.sh` first because `/usr/local/bin` gets overwritten.
