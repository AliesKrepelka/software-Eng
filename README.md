# Athenaeum Docker + Supabase Workflow

This repo runs with Docker Compose using PostgreSQL + PostgREST (Supabase-style API), plus separate backend/frontend app containers from Docker Hub.

## Quick answer to your question

**With the current `docker-compose.yml` (image-based):**
- ✅ You can pull and run team images quickly.
- ✅ You can test the running app.
- ❌ You **cannot live-debug local source edits** automatically, because Compose is pulling prebuilt images (not mounting your source code into a dev container).

So your current flow is:
1. Edit and test code locally in your own dev setup.
2. Build/push new Docker image(s) to Docker Hub.
3. Run `docker compose pull backend frontend`.
4. Restart with `docker compose up -d`.

## 1) Configure image names (important)

Create `.env` from template:

```bash
cp .env.example .env
```

Then set the two image variables to match Docker Hub exactly:

```env
BACKEND_IMAGE=wesrodd/athenaeum-backend:latest
FRONTEND_IMAGE=wesrodd/athenaeum-frontend:latest
```

If you publish a different tag later, just update these values.

## 2) Start and stop containers

```bash
docker compose up -d
```

```bash
docker compose down
```

Check status/logs:

```bash
docker compose ps
docker compose logs -f --tail=100
```

## 3) Team update flow (always get latest images)

When a teammate pushes new frontend/backend images:

```bash
docker compose pull backend frontend
docker compose up -d
```

If DB/PostgREST versions changed too:

```bash
docker compose pull
docker compose up -d
```

## 4) Build and push updated images to Docker Hub

After your code changes are tested and ready:

```bash
# Backend
docker build -t wesrodd/athenaeum-backend:latest -f Dockerfile.backend .
docker push wesrodd/athenaeum-backend:latest

# Frontend
docker build -t wesrodd/athenaeum-frontend:latest -f Dockerfile.frontend .
docker push wesrodd/athenaeum-frontend:latest
```

If your repo uses different Dockerfile names, replace `Dockerfile.backend` / `Dockerfile.frontend` accordingly.

## 5) Git flow for group work (manual push + fetch latest first)

Before every manual git push:

```bash
git fetch --all --prune
git status
git rebase origin/$(git rev-parse --abbrev-ref HEAD)
```

Then push:

```bash
git push origin $(git rev-parse --abbrev-ref HEAD)
```

## 6) Service endpoints

- Frontend: http://localhost:8080
- Backend: http://localhost:4000
- PostgREST: http://localhost:3001
- PostgreSQL: localhost:5432

## 7) Hard reset (delete local DB data)

```bash
docker compose down -v
docker compose up -d
```

⚠️ This removes all local DB data.
