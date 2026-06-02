# frm-nginx

Dockerized **nginx** reverse proxy with **HTTPS** for a two-service stack: a web frontend and a REST API.

## What it does

| Listener | Protocol | Upstream (Docker DNS) |
|----------|----------|---------------------|
| `1443` | HTTPS | `frm-web:3000` |
| `18443` | HTTPS | `frm-api:8000` |

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

- Self-signed certificates are suitable for internal or private networks, not public internet trust.
- If upstream services are not running, nginx will return **502 Bad Gateway** — expected until they are up.

## Portainer (Git stack)

This image is **built from the repo**, not pulled from a registry. The compose file sets `pull_policy: never` so `docker compose pull` does not try Docker Hub for `frm-nginx:local`.

If redeploy fails with **pull access denied for frm-nginx**:

1. Push the latest `docker-compose.yml` from this repo to GitHub.
2. In Portainer → stack **frm-nginx** → **Pull and redeploy** (or **Update the stack** from Git).
3. **Turn off** “Pull latest image” / “Re-pull images” if that option is shown — you need a **rebuild**, not a registry pull.
4. If your Portainer version has no rebuild toggle, use **Editor** → save (no change) → deploy with build enabled, or run on the VM:

   ```bash
   cd /path/to/frm-nginx && FRM_VM_IP=<VM_IP> docker compose up -d --build
   ```

Deleting and recreating the stack “works” only because the first deploy **builds** the image; later “Pull and redeploy” tries to **pull** `frm-nginx` from Docker Hub and fails.
