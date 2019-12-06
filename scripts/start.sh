#!/bin/sh

# Check variables DUCKDNS_TOKEN, DUCKDNS_DOMAIN, LETSENCRYPT_EMAIL
if [ -z "$DUCKDNS_TOKEN" ]; then
	echo ERROR: Variable DUCKDNS_TOKEN is unset
	exit 1
fi

if [ -z "$DUCKDNS_DOMAIN" ]; then
	echo ERROR: Variable DUCKDNS_DOMAIN is unset
	exit 1
fi

if [ -z "$LETSENCRYPT_EMAIL" ]; then
	echo ERROR: Variable LETSENCRYPT_EMAIL is unset
	exit 1
fi

# Print variables
echo DUCKDNS_TOKEN: $DUCKDNS_TOKEN
echo DUCKDNS_DOMAIN: $DUCKDNS_DOMAIN
echo LETSENCRYPT_EMAIL: $LETSENCRYPT_EMAIL

# Start automatic ssl certificate generation
/bin/sh /scripts/cert.sh
