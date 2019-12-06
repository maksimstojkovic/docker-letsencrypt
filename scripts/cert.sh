#!/bin/sh

# Initial check for certificates
#TODO check if `certbot certonly` can automatically skip renewal (eliminated need for document here operator)
certbot certonly --manual --preferred-challenges dns --manual-auth-hook /scripts/auth \
	--manual-cleanup-hook /scripts/cleanup -m "${LETSENCRYPT_EMAIL}" --no-eff-email \
	-d "${LETSENCRYPT_DOMAIN}" --agree-tos --manual-public-ip-logging-ok << EOF
1
EOF

# Loop generation at a random time every 12 hours
while :; do
	# Generate random delay within 12 hours of seconds
	# sleep the required time
	# Run renew command
done
