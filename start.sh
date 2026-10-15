#!/bin/sh
set -eu
: "${PROXY_PORT:=443}"
: "${PROXY_SECRET:?Set PROXY_SECRET in the local .env file}"
case "$PROXY_SECRET" in
  *[!0-9a-fA-F]*|'') echo 'PROXY_SECRET must be hexadecimal.' >&2; exit 1 ;;
esac
if [ "${#PROXY_SECRET}" -lt 32 ]; then echo 'PROXY_SECRET must be at least 32 hex characters.' >&2; exit 1; fi
curl -fsSL https://core.telegram.org/getProxySecret -o proxy-secret
curl -fsSL https://core.telegram.org/getProxyConfig -o proxy-multi.conf
exec ./mtproto-proxy -u nobody -p 8888 -H "$PROXY_PORT" -S "$PROXY_SECRET" --aes-pwd proxy-secret proxy-multi.conf -M 1
