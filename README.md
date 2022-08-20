# Let's Encrypt for Duck DNS

[![Build Status](https://github.com/maksimstojkovic/docker-letsencrypt/actions/workflows/docker-build.yml/badge.svg)](https://github.com/maksimstojkovic/docker-letsencrypt)
[![Docker Pulls](https://img.shields.io/docker/pulls/maksimstojkovic/letsencrypt)](https://hub.docker.com/r/maksimstojkovic/letsencrypt)
[![Docker Stars](https://img.shields.io/docker/stars/maksimstojkovic/letsencrypt)](https://hub.docker.com/r/maksimstojkovic/letsencrypt)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/maksimstojkovic/letsencrypt)](https://hub.docker.com/r/maksimstojkovic/letsencrypt)
[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/maksimstojkovic/letsencrypt)](https://hub.docker.com/r/maksimstojkovic/letsencrypt)

Automatically generates Let's Encrypt certificates using a lightweight Docker container without requiring any ports to be exposed for DNS challenges.

## Environment Variables

* `DUCKDNS_TOKEN`: Duck DNS account token (obtained from [Duck DNS](https://www.duckdns.org)) (*required*)
* `DUCKDNS_DOMAIN`: Full Duck DNS domain (e.g. `test.duckdns.org`) (*required*)
* `LETSENCRYPT_DOMAIN`: Domain to generate SSL cert for. By default the SSL certificate is generated for `DUCKDNS_DOMAIN` (optional)
* `LETSENCRYPT_WILDCARD`: `true` or `false`, indicating whether the SSL certificate should be for subdomains *only* of `LETSENCRYPT_DOMAIN` (i.e. `*.test.duckdns.org`), or for the main domain *only* (i.e. `test.duckdns.org`) (optional, default: `false`)
* `LETSENCRYPT_EMAIL`: Email used for certificate renewal notifications (optional)
* `LETSENCRYPT_CHAIN`: Preferred certificate chain (e.g. `ISRG Root X1`, see [https://letsencrypt.org/certificates](https://letsencrypt.org/certificates/) for more details) (optional)
* `TESTING`: `true` or `false`, indicating whether a staging SSL certificate should be generated or not (optional, default: `false`)
* `UID`: User ID to apply to Let's Encrypt files generated (optional, recommended, default: `0` - root)
* `GID`: Group ID to apply to Let's Encrypt files generated (optional, recommended, default: `0` - root)

## Notes

* The `DUCKDNS_DOMAIN` should already be pointing to the server with a dynamic IP. The [maksimstojkovic/duckdns](https://github.com/maksimstojkovic/docker-duckdns) image can be used to automatically update the IP address.
* The format of `DUCKDNS_DOMAIN` should be `<subdomain>.duckdns.org`, regardless of the value of `LETSENCRYPT_WILDCARD`.
* To use `LETSENCRYPT_DOMAIN` feature, the following DNS records need to be created for ACME authentication (records should not be proxied):

| Type  | Name                                   | Value                              | Condition                         |
|-------|----------------------------------------|------------------------------------|-----------------------------------|
| CNAME | `*.<LETSENCRYPT_DOMAIN>`               | `<DUCKDNS_DOMAIN>`                 | `LETSENCRYPT_WILDCARD` == `true`  |
| CNAME | `<LETSENCRYPT_DOMAIN>`                 | `<DUCKDNS_DOMAIN>`                 | `LETSENCRYPT_WILDCARD` == `false` |
| CNAME | `_acme-challenge.<LETSENCRYPT_DOMAIN>` | `_acme-challenge.<DUCKDNS_DOMAIN>` |                                   |

## Volumes

* `<certs>:/etc/letsencrypt`: A named or host volume which allows SSL certificates to persist and be accessed by other containers

**Note:** To use the `<certs>` host volume in another container, mount it as read-only for those containers. The `<certs>` host volume should be read-write enabled for the Letsencrypt container.
