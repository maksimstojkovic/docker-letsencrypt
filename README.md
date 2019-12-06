# Let's Encrypt for Duck DNS

Automatically generates Let's Encrypt certificates using a lightweight Docker container without requiring any ports to be exposed for DNS challenges.

Variables:
* `DUCKDNS_TOKEN`: Duck DNS Account Token
* `DUCKDNS_DOMAIN`: Full Duck DNS domain (e.g. `test.duckdns.org`)
* `LETSENCRYPT_EMAIL`: Email used for certificate renewal notifications

Volumes:
* `<certs>:/etc/letsencrypt`: A named or hosted volume which allows SSL certificates to persist and be accessed by other containers

TODO:
* Implement tests so `depends_on` can be used in docker-compose to prevent other containers from initialising until certificates are ready
