#!/bin/sh
set -eu

IP="${FRM_VM_IP:-}"
if [ -z "$IP" ]; then
  echo "ERROR: FRM_VM_IP is required (IP address for the TLS certificate)."
  exit 1
fi

mkdir -p /etc/nginx/ssl
if [ ! -f /etc/nginx/ssl/cert.pem ]; then
  echo "Generating self-signed certificate for ${IP} ..."
  openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/key.pem \
    -out /etc/nginx/ssl/cert.pem \
    -subj "/CN=${IP}" \
    -addext "subjectAltName=IP:${IP}"
  chmod 600 /etc/nginx/ssl/key.pem
fi

exec "$@"
