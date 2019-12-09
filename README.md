# Let's Encrypt for Duck DNS

Automatically generates Let's Encrypt certificates using a lightweight Docker container without requiring any ports to be exposed for DNS challenges.

Variables:

* `DUCKDNS_TOKEN`: Duck DNS Account Token
* `DUCKDNS_DOMAIN`: Full Duck DNS domain (e.g. `test.duckdns.org`)
* `LETSENCRYPT_EMAIL`: Email used for certificate renewal notifications (optional)
* `LETSENCRYPT_WILDCARD`: `true` or `false`, indicating whether the SSL certificate should be for all subdomains of `DUCKDNS_DOMAIN` (i.e. `*.test.duckdns.org`), or just the main domain (i.e. `test.duckdns.org`)

**Note:** The format of `DUCKDNS_DOMAIN` should be the same regardless of the value of `LETSENCRYPT_WILDCARD`.

Volumes:

* `<certs>:/etc/letsencrypt`: A named or hosted volume which allows SSL certificates to persist and be accessed by other containers

**Note:** If a hosted volume is used, the volume should be mounted in an unused directory in another container to prevent access conflicts.

#### TODO:
* Implement tests so `depends_on` can be used in docker-compose to prevent other containers from initialising until certificates are ready
