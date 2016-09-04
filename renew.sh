#!/bin/sh -e
if [ -z "$COMMON_NAME" ]; then
  echo 'Environment variable COMMON_NAME is not set'
  exit 1
fi

set -x
cd "`dirname $0`"
mkdir -p cert
docker-compose build acmesmith
docker-compose run --rm acmesmith autorenew
docker-compose run --rm acmesmith show-certificate "$COMMON_NAME" > cert/cert.pem
docker-compose run --rm acmesmith show-private-key "$COMMON_NAME" > cert/key.pem
docker-compose build ssl-proxy
docker-compose up -d ssl-proxy
