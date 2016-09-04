#!/bin/sh -e
if [ -z "$COMMON_NAME" ]; then
  echo 'Environment variable COMMON_NAME is required'
  exit 1
fi
if [ -z "$WEB_SERVICE" ]; then
  WEB_SERVICE=reverse-proxy
fi

set -x
cd "`dirname $0`"
mkdir -p "$WEB_SERVICE/cert"
docker-compose build acmesmith
docker-compose run --rm acmesmith autorenew
docker-compose run --rm acmesmith show-certificate "$COMMON_NAME" > "$WEB_SERVICE/cert/cert.pem"
docker-compose run --rm acmesmith show-private-key "$COMMON_NAME" > "$WEB_SERVICE/cert/key.pem"
docker-compose build "$WEB_SERVICE"
docker-compose up -d "$WEB_SERVICE"
