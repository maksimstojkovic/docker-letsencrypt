#!/bin/sh

# Initial check for certificates
certbot certonly --manual --preferred-challenges dns --manual-auth-hook \
  /scripts/auth.sh --manual-cleanup-hook /scripts/cleanup.sh \
  -m "${LETSENCRYPT_EMAIL}" --no-eff-email -d "${DUCKDNS_DOMAIN}" \
  --agree-tos --manual-public-ip-logging-ok << EOF
1
EOF

# Basic check for successful certificate generation
if [ ! -d "/etc/letsencrypt/live" ]; then
  echo ERROR: Failed to create SSL certificates
  exit 1
fi

# Check if certificates require renewal twice a day
while :; do
  # Wait for a random period within the next 12 hours
  LETSENCRYPT_DELAY=$(shuf -i 1-720 -n 1)
  echo Sleeping for $(($LETSENCRYPT_DELAY / 60)) hour\(s\) and $(($LETSENCRYPT_DELAY % 60)) minute\(s\)
  sleep $((${LETSENCRYPT_DELAY} * 60))

  echo Attempting SSL certificate renewal
  certbot --manual-public-ip-logging-ok renew
done
