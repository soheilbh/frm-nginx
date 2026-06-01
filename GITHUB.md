# Publish to GitHub

Local repo is initialized on branch `main` with an initial commit.

## Option A — GitHub CLI (fastest)

```bash
cd frm-nginx   # or full path to this folder
gh auth login
gh repo create frm-nginx --public \
  --description "HTTPS nginx reverse proxy for FRM AI (Portainer deploy)" \
  --source=. --remote=origin --push
```

If the name `frm-nginx` is taken, use `frm-nginx-proxy` instead.

## Option B — GitHub website

1. [github.com/new](https://github.com/new) → Repository name **`frm-nginx`** → Public → **Create** (no README).
2. In terminal:

```bash
cd frm-nginx
git remote add origin https://github.com/YOUR_USER/frm-nginx.git
git push -u origin main
```

## Portainer after push

| Field | Value |
|--------|--------|
| Repository URL | `https://github.com/YOUR_USER/frm-nginx` |
| Compose path | `docker-compose.yml` |
| Env | `FRM_VM_IP=<your VM IP>` |
