# Athenaeum Docker + Supabase Workflow

This repo is set up to run with Docker Compose using PostgreSQL + PostgREST (Supabase-style API), plus backend and frontend containers.

## ✅ Will this work for a team using **separate frontend/backend Docker Hub images**?

Yes — this setup is made for that exact model:

- `backend` uses `wesrodd/athenaeum-backend:latest`
- `frontend` uses `wesrodd/athenaeum-frontend:latest`
- your group just needs the same repo files and Docker installed

Services in `docker-compose.yml` are separate containers and can be updated independently by pulling newer images before restart.

## 1) Start and stop containers reliably

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

## 2) Image-based workflow for group mates (recommended)

When someone on the team pushes a new Docker image:

```bash
docker compose pull backend frontend
docker compose up -d
```

If DB/PostgREST image versions also changed:

```bash
docker compose pull
docker compose up -d
```

## 3) Live edits vs Docker Hub images (important)

Current `docker-compose.yml` uses published images (`wesrodd/athenaeum-*`).
That means **local code edits will not appear live** until you build and push a new image tag.

So the flow is:
1. Edit code locally
2. Build/push updated image(s)
3. Teammates run `docker compose pull ...` and restart

## 4) Git workflow for team collaboration (manual push + always fetch latest)

Use this every time before you push:

```bash
git fetch --all --prune
git status
git rebase origin/$(git rev-parse --abbrev-ref HEAD)
```

Then push manually only when ready:

```bash
git push origin $(git rev-parse --abbrev-ref HEAD)
```

## 5) First-time setup

```bash
cp .env.example .env
```

Then start services:

```bash
docker compose up -d
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
