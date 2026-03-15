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
readline libs are also saved to `/tmp/readline/` and restored after the copy — PostGIS alpine ships
an older readline that lacks symbols bash was compiled against (`rl_print_keybinding`, etc.).

## PGDATA

pgautoupgrade for PostgreSQL 18 uses `PGDATA=/var/lib/postgresql/18/docker` (not the traditional `/var/lib/postgresql/data`).
The `FROM scratch` squash stage loses all ENV vars from the base image, so `PGDATA` must be explicitly redeclared.
The fallback in the entrypoint is `/var/lib/postgresql/data` (wrong), causing a fresh init while real data sits untouched
at the correct path.

## Local Testing

`postgis/postgis:18-3.6-alpine` has no arm64 variant — build and run with `--platform linux/amd64` on Apple Silicon.
