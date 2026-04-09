# Athenaeum Docker + Supabase Workflow

This repo runs with Docker Compose using PostgreSQL + PostgREST (Supabase-style API), plus separate backend/frontend app containers from Docker Hub.

## ✅ Your Docker Hub screenshot check

From your screenshot, I can confirm this part is good:
- `wesrodd/athenaeum-frontend` exists.

But your second repo appears to be named:
- `wesrodd/athenaeum-backend-test`

So if your real backend image is `athenaeum-backend-test`, set that explicitly in `.env` (see below), otherwise Compose will try `wesrodd/athenaeum-backend:latest`.

## 1) Configure image names (important)

Create `.env` from template:

```bash
cp .env.example .env
```

Then set the two image variables to match Docker Hub exactly:

```env
BACKEND_IMAGE=wesrodd/athenaeum-backend-test:latest
FRONTEND_IMAGE=wesrodd/athenaeum-frontend:latest
```

If you later rename/publish a non-test backend image, just update `BACKEND_IMAGE`.

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

## 3) Team update flow (manual push + always pull latest images)

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

## 4) Live edits vs Docker Hub images

Because this Compose file uses published Docker Hub images, local code edits are not live-mounted.

Expected flow:
1. edit code
2. build + push image(s)
3. teammates `docker compose pull` + restart

## 5) Git flow for group work

Before every manual push:

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
