#!/bin/sh

# Check variables DUCKDNS_TOKEN, DUCKDNS_DOMAIN, LETSENCRYPT_EMAIL, LETSENCRYPT_WILDCARD
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

if [ -z "$LETSENCRYPT_WILDCARD" ]; then
	echo ERROR: Variable LETSENCRYPT_WILDCARD is unset
	exit 1
fi

# Set certificate url based on LETSENCRYPT_WILDCARD value
if [ "$LETSENCRYPT_WILDCARD" = "true" ]; then
  export LETSENCRYPT_DOMAIN=*.${DUCKDNS_DOMAIN}
elif [ "$LETSENCRYPT_WILDCARD" = "false" ]; then
  export LETSENCRYPT_DOMAIN=${DUCKDNS_DOMAIN}
else
  echo ERROR: Invalid value for LETSENCRYPT_WILDCARD
  exit 1
fi

# Print variables
echo DUCKDNS_TOKEN: $DUCKDNS_TOKEN
echo DUCKDNS_DOMAIN: $DUCKDNS_DOMAIN
echo LETSENCRYPT_EMAIL: $LETSENCRYPT_EMAIL
echo LETSENCRYPT_WILDCARD: $LETSENCRYPT_WILDCARD

# Start automatic ssl certificate generation
/bin/sh /scripts/cert.sh
