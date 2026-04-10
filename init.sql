-- Minimal bootstrap SQL for Postgres + PostgREST.
-- Safe to run on first initialization only.

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
    CREATE ROLE anon NOLOGIN;
  END IF;
END
$$;
