#!/bin/sh

# Check variables DUCKDNS_TOKEN, DUCKDNS_DOMAIN
if [ -z "$DUCKDNS_TOKEN" ]; then
	echo "ERROR: Variable DUCKDNS_TOKEN is unset"
	exit 1
fi

if [ -z "$DUCKDNS_DOMAIN" ]; then
	echo "ERROR: Variable DUCKDNS_DOMAIN is unset"
	exit 1
fi

# Print email notice if applicable
if [ -z "$LETSENCRYPT_EMAIL" ]; then
	echo "INFO: You will not receive SSL certificate expiration notices"
fi

# Set certificate url based on LETSENCRYPT_WILDCARD value
if [ "$LETSENCRYPT_WILDCARD" = "true" ]; then
  echo "INFO: A wildcard SSL certificate will be created"
  LETSENCRYPT_DOMAIN="*.$DUCKDNS_DOMAIN"
else
  LETSENCRYPT_DOMAIN="$DUCKDNS_DOMAIN"
  LETSENCRYPT_WILDCARD="false"
fi

# Set user and group ID's for files
if [ -z "$UID" ]; then
	echo "INFO: No UID specified, using root UID of 0"
  UID=0
fi

if [ -z "$GID" ]; then
	echo "INFO: No GID specified, using root GID of 0"
  GID=0
fi

# Print variables
echo "DUCKDNS_TOKEN: $DUCKDNS_TOKEN"
echo "DUCKDNS_DOMAIN: $DUCKDNS_DOMAIN"
echo "LETSENCRYPT_EMAIL: $LETSENCRYPT_EMAIL"
echo "LETSENCRYPT_WILDCARD: $LETSENCRYPT_WILDCARD"
echo "TESTING: $TESTING"
echo "UID: $UID"
echo "GID: $GID"

if [ -z "$LETSENCRYPT_EMAIL" ]; then
  EMAIL_PARAM="--register-unsafely-without-email"
else
  EMAIL_PARAM="-m $LETSENCRYPT_EMAIL --no-eff-email"
fi

if [ "$TESTING" = "true" ]; then
  echo "INFO: Generating staging certificate"
  TEST_PARAM="--test-cert"
else
  unset TEST_PARAM
fi

echo "certbot certonly --manual --preferred-challenges dns --manual-auth-hook \
  /scripts/auth.sh --manual-cleanup-hook /scripts/cleanup.sh \
  $EMAIL_PARAM -d $LETSENCRYPT_DOMAIN \
  --agree-tos --manual-public-ip-logging-ok --keep $TEST_PARAM"

# Create certificates
certbot certonly --manual --preferred-challenges dns --manual-auth-hook \
  /scripts/auth.sh --manual-cleanup-hook /scripts/cleanup.sh \
  $EMAIL_PARAM -d $LETSENCRYPT_DOMAIN \
  --agree-tos --manual-public-ip-logging-ok --keep $TEST_PARAM

chown -R $UID:$GID /etc/letsencrypt

# Check for successful certificate generation
if [ ! -d "/etc/letsencrypt/live/${DUCKDNS_DOMAIN}" ] || \
   [ ! -f "/etc/letsencrypt/live/${DUCKDNS_DOMAIN}/fullchain.pem" ] || \
   [ ! -f "/etc/letsencrypt/live/${DUCKDNS_DOMAIN}/privkey.pem" ]; then
  echo "ERROR: Failed to create SSL certificates"
  exit 1
fi

# Check if certificates require renewal twice a day
while :; do
  # Wait for a random period within the next 12 hours
  LETSENCRYPT_DELAY=$(shuf -i 1-720 -n 1)
  echo "Sleeping for $(($LETSENCRYPT_DELAY / 60)) hour(s) and $(($LETSENCRYPT_DELAY % 60)) minute(s)"
  sleep $((${LETSENCRYPT_DELAY} * 60)) # Convert to seconds

  echo "INFO: Attempting SSL certificate renewal"
  certbot --manual-public-ip-logging-ok renew
  chown -R $UID:$GID /etc/letsencrypt
done
