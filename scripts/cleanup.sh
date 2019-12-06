#!/bin/sh
[[ "$(curl -s "https://www.duckdns.org/update?domains=${CERTBOT_DOMAIN%.duckdns.org}&token=${DUCKDNS_TOKEN}&txt=${CERTBOT_VALIDATION}&clear=true")" = "OK" ]]
