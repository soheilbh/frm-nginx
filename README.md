# frm-nginx

Dockerized **nginx** reverse proxy with **HTTPS** for a two-service stack: a web frontend and a REST API.

## What it does

| Listener | Protocol | Upstream (Docker DNS) |
|----------|----------|---------------------|
| `443` | HTTPS | `frm-web:3000` |
| `8443` | HTTPS | `frm-api:8000` |
| `80` | HTTP | Redirects to HTTPS |

On first start, the container generates a **self-signed TLS certificate** for the IP you provide via `FRM_VM_IP`. Browsers will show a certificate warning until you trust the cert or replace it with one from your CA.

## Requirements

- Docker with Compose v2
- Upstream containers `frm-web` and `frm-api` on the **same Docker network** as this service
- One environment variable: **`FRM_VM_IP`** — IP address used as the certificate Common Name and Subject Alternative Name (typically the host reachable by clients)

## Run

```bash
export FRM_VM_IP=<host-ip>
docker compose up -d --build
```

Or pass the variable inline:

```bash
FRM_VM_IP=<host-ip> docker compose up -d --build
```

## Environment

| Variable | Required | Description |
|----------|----------|-------------|
| `FRM_VM_IP` | Yes | IP address for the self-signed certificate |

## Docker network

Compose defines network `frm_ai_frm-ai-network`. Other stacks can attach to it as an external network so nginx can reach the upstream services by name.

## Files

| File | Purpose |
|------|---------|
| `Dockerfile` | nginx image with bundled config and entrypoint |
| `nginx.conf` | Reverse proxy rules |
| `docker-entrypoint.sh` | Creates TLS cert if missing, then starts nginx |
| `generate-certs.sh` | Optional: generate cert/key files locally (not used by the default image flow) |

## Optional: generate certificates locally

```bash
./generate-certs.sh <host-ip>
```

Writes `ssl/cert.pem` and `ssl/key.pem`. The default container path generates certs inside the container at runtime instead.

## Notes

- Self-signed certificates are suitable for internal or VPN-only access, not public internet trust.
- If upstream services are not running, nginx will return **502 Bad Gateway** — expected until they are up.
