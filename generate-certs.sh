#!/usr/bin/env bash
# Generate a self-signed certificate for local testing or custom mounts.
# Usage: ./generate-certs.sh <host-ip>
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSL_DIR="${SCRIPT_DIR}/ssl"
IP="${1:-}"

if [[ -z "${IP}" ]]; then
  echo "Usage: $0 <host-ip>"
  exit 1
fi

mkdir -p "${SSL_DIR}"

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout "${SSL_DIR}/key.pem" \
  -out "${SSL_DIR}/cert.pem" \
  -subj "/CN=${IP}" \
  -addext "subjectAltName=IP:${IP}"

chmod 600 "${SSL_DIR}/key.pem"
echo "Wrote ${SSL_DIR}/cert.pem and ${SSL_DIR}/key.pem"
