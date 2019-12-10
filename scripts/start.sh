#!/bin/sh

# Check variables DUCKDNS_TOKEN, DUCKDNS_DOMAIN
if [ -z "$DUCKDNS_TOKEN" ]; then
	echo ERROR: Variable DUCKDNS_TOKEN is unset
	exit 1
fi

if [ -z "$DUCKDNS_DOMAIN" ]; then
	echo ERROR: Variable DUCKDNS_DOMAIN is unset
	exit 1
fi

# Print email notice if applicable
if [ -z "$LETSENCRYPT_EMAIL" ]; then
	echo NOTICE: You will not receive SSL certificate expiration notices
fi

# Set certificate url based on LETSENCRYPT_WILDCARD value
if [ "$LETSENCRYPT_WILDCARD" = "true" ]; then
  echo NOTICE: A wildcard SSL certificate will be created
  export LETSENCRYPT_DOMAIN=*.${DUCKDNS_DOMAIN}
  export WILDCARD_STR="true"
else
  export LETSENCRYPT_DOMAIN=${DUCKDNS_DOMAIN}
  export WILDCARD_STR="false"
fi

# Print variables
echo DUCKDNS_TOKEN: $DUCKDNS_TOKEN
echo DUCKDNS_DOMAIN: $DUCKDNS_DOMAIN
echo LETSENCRYPT_EMAIL: $LETSENCRYPT_EMAIL
echo LETSENCRYPT_WILDCARD: $WILDCARD_STR \(Input: \"${LETSENCRYPT_WILDCARD}\"\)

# Start automatic ssl certificate generation
/bin/sh /scripts/cert.sh
