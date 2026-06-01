# frm-nginx — Portainer only (no VM SSH)

**Repo:** https://github.com/soheilbh/frm-nginx

You only need **Portainer** + **Git** (GitLab or private GitHub). No shell on the VM, no `/opt` folders.

The image **builds nginx config inside Docker** and **creates the TLS cert on first start** from `FRM_VM_IP`.

| URL | Backend (when frm-ai is running) |
|-----|----------------------------------|
| `https://<VM_IP>` | `frm-web:3000` |
| `https://<VM_IP>:8443` | `frm-api:8000` |

---

## Portainer — new stack (Git)

| Field | Value |
|--------|--------|
| **Name** | `frm-nginx` |
| **Build method** | **Git repository** |
| **Repository URL** | `https://github.com/soheilbh/frm-nginx` |
| **Repository reference** | `main` (your branch) |
| **Compose path** | `docker-compose.yml` |
| **Authentication** | Token if private repo |

### Environment variables (required)

| Name | Value |
|------|--------|
| `FRM_VM_IP` | Your VM IP on VPN, e.g. `10.52.10.192` |

Nothing else required.

### Deploy

Turn **Deploy** on. Portainer will **build** the image on the VM (needs internet to pull `nginx:1.27-alpine` once).

---

## After deploy

- Container `frm-nginx` running
- Network `frm_ai_frm-ai-network` created
- `https://<VM_IP>` works (cert warning once — self-signed)
- **502** until frm-ai stack is deployed later — normal

---

## Clerk (when app is ready)

Set application URL to `https://<VM_IP>`.

---

## No Git in Portainer?

Portainer **Web editor** cannot build this image unless your Portainer also has the Dockerfile context. Use **Git** (GitLab/GitHub) — simplest for Portainer-only access.

---

## Local Mac

Not required. This stack is for **remote Portainer** only.
