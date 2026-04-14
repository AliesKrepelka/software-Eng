# Athenaeum Docker + Supabase Workflow

You now have **two modes**:

1. **Image mode (team stable)** → always pull latest Docker Hub images.
2. **Live-debug mode (local dev)** → live-debug backend code while keeping frontend on stable image at `localhost:8080`.

---


## 0) If you previously had a broken init.sql

If Postgres was initialized with bad data/scripts before this fix, reset once:

```bash
docker compose down -v
docker compose up -d
```

## 1) First-time setup

```bash
cp .env.example .env
```

Confirm these values in `.env`:

```env
BACKEND_IMAGE=wesrodd/athenaeum-backend:latest
FRONTEND_IMAGE=wesrodd/athenaeum-frontend:latest
BACKEND_SRC=./backend
```

---

## 2) Image mode (pull latest images)

Use this for teammates or clean validation:

```bash
docker compose pull
docker compose up -d
```

Because `pull_policy: always` is enabled for `backend` and `frontend`, Compose always checks for latest tags before running those services.

---

## 3) Live-debug mode (edit code and auto-reload)

This mode uses the dev overlay file (`docker-compose.dev.yml`) to bind-mount local source and run dev commands.

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml pull backend frontend
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```

What this gives you:
- backend runs `npm run dev` (for nodemon-style live reload)
- frontend stays on Docker Hub image, so `localhost:8080` remains stable
- local changes in `BACKEND_SRC` are reflected live

---

## 4) Push tested changes back to Docker Hub

After validating your local live-debug changes:

```bash
# Backend
docker build -t wesrodd/athenaeum-backend:latest -f Dockerfile.backend .
docker push wesrodd/athenaeum-backend:latest

# Frontend
docker build -t wesrodd/athenaeum-frontend:latest -f Dockerfile.frontend .
docker push wesrodd/athenaeum-frontend:latest
```

Then teammates update with:

```bash
docker compose pull backend frontend
docker compose up -d
```

---

## 5) Helpful commands

```bash
docker compose ps
docker compose logs -f --tail=100
docker compose down
docker compose down -v
```

⚠️ `down -v` deletes local DB data.

---


## 6) If `localhost:8080` is not loading

Run:

```bash
docker compose ps
docker compose logs frontend --tail=200
```

Common fixes:
- make sure `frontend` container is `Up`
- run `docker compose pull frontend && docker compose up -d frontend`
- avoid overriding frontend in dev mode (this repo now keeps frontend image-based by default)

## 7) Endpoints

- Frontend: http://localhost:8080
- Backend: http://localhost:4000
- PostgREST: http://localhost:3001
- PostgreSQL: localhost:5432
