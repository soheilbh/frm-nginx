#!/usr/bin/env bash
# Optional: generate certs on a machine with openssl (not needed for Portainer deploy).
# Usage:  ./generate-certs.sh 10.52.10.50
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSL_DIR="${SCRIPT_DIR}/ssl"
IP="${1:-}"

if [[ -z "${IP}" ]]; then
  echo "Usage: $0 <VM_IP>"
  echo "Example: $0 10.52.10.50"
  exit 1
fi

mkdir -p "${SSL_DIR}"

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout "${SSL_DIR}/key.pem" \
  -out "${SSL_DIR}/cert.pem" \
  -subj "/CN=${IP}" \
  -addext "subjectAltName=IP:${IP}"

chmod 600 "${SSL_DIR}/key.pem"
echo "Wrote ${SSL_DIR}/cert.pem and key.pem for IP ${IP}"
