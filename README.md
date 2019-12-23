# Let's Encrypt for Duck DNS

[![Build Status](https://github.com/silentdigit/docker-letsencrypt/workflows/docker%20build/badge.svg)](https://github.com/silentdigit/docker-letsencrypt)
[![Docker Pulls](https://img.shields.io/docker/pulls/silentdigit/letsencrypt)](https://hub.docker.com/repository/docker/silentdigit/letsencrypt)
[![Docker Stars](https://img.shields.io/docker/stars/silentdigit/letsencrypt)](https://hub.docker.com/repository/docker/silentdigit/letsencrypt)
[![Image Size](https://images.microbadger.com/badges/image/silentdigit/letsencrypt.svg)](https://hub.docker.com/repository/docker/silentdigit/letsencrypt)
[![Image Version](https://images.microbadger.com/badges/version/silentdigit/letsencrypt.svg)](https://hub.docker.com/repository/docker/silentdigit/letsencrypt)
[![Image Commit](https://images.microbadger.com/badges/commit/silentdigit/letsencrypt.svg)](https://github.com/silentdigit/docker-letsencrypt)

Automatically generates Let's Encrypt certificates using a lightweight Docker container without requiring any ports to be exposed for DNS challenges.

## Variables

* `DUCKDNS_TOKEN`: Duck DNS account token (obtained from [Duck DNS](https://www.duckdns.org))
* `DUCKDNS_DOMAIN`: Full Duck DNS domain (e.g. `test.duckdns.org`)
* `LETSENCRYPT_EMAIL`: Email used for certificate renewal notifications (optional)
* `LETSENCRYPT_WILDCARD`: `true` or `false`, indicating whether the SSL certificate should be for subdomains *only* of `DUCKDNS_DOMAIN` (i.e. `*.test.duckdns.org`), or for the main domain *only* (i.e. `test.duckdns.org`) (default: `false`)
* `TESTING`: `true` or `false`, indicating whether a staging SSL certificate should be generated or not (default: `false`)

**Note:** The format of `DUCKDNS_DOMAIN` should be the same regardless of the value of `LETSENCRYPT_WILDCARD`.

## Volumes

* `<certs>:/etc/letsencrypt`: A named or hosted volume which allows SSL certificates to persist and be accessed by other containers

**Note:** If a hosted volume is used, the volume should be mounted in an unused directory in another container to prevent access conflicts.
