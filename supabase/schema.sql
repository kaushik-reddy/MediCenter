-- ============================================================
--  MediCenter — Supabase database schema
--  Run this once in the Supabase dashboard:
--    Database → SQL Editor → New query → paste → Run.
--  Safe to re-run (uses IF NOT EXISTS / OR REPLACE / DROP IF EXISTS).
-- ============================================================

create extension if not exists "pgcrypto";

-- ------------------------------------------------------------
--  profiles — one row per authenticated user
-- ------------------------------------------------------------
create table if not exists public.profiles (
  id          uuid primary key references auth.users (id) on delete cascade,
  name        text,
  email       text,
  phone       text,
  avatar_url  text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- ------------------------------------------------------------
--  medications — the user's medicines & supplements
-- ------------------------------------------------------------
create table if not exists public.medications (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users (id) on delete cascade,
  name        text not null,
  dose        text not null default '1 Tablet',
  food        text not null default 'After Food',
  food_icon   text not null default 'food'  check (food_icon in ('food','moon')),
  time_label  text not null default '09:00 AM',           -- display time, e.g. "09:00 AM"
  color       text not null default 'green' check (color in ('green','purple')),
  kind        text not null default 'tablet' check (kind in ('tablet','capsule','softgel')),
  category    text not null default 'medication' check (category in ('medication','supplement')),
  stock       integer not null default 0,
  total       integer not null default 0,
  days        boolean[] not null default '{true,true,true,true,true,true,true}', -- Mon..Sun
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
create index if not exists medications_user_id_idx on public.medications (user_id);

-- ------------------------------------------------------------
--  dose_logs — every scheduled dose and its outcome (history + analytics)
-- ------------------------------------------------------------
create table if not exists public.dose_logs (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references auth.users (id) on delete cascade,
  medication_id  uuid references public.medications (id) on delete set null,
  name           text not null,
  detail         text,
  time_label     text,                                    -- display time, e.g. "09:00 AM"
  scheduled_for  timestamptz,                             -- actual scheduled datetime
  status         text not null default 'pending'
                   check (status in ('taken','upcoming','pending','late','missed','skipped','snoozed')),
  taken_at       timestamptz,
  mood           smallint check (mood between 0 and 4),   -- optional mood check-in (0..4)
  note           text,
  created_at     timestamptz not null default now()
);
create index if not exists dose_logs_user_id_idx        on public.dose_logs (user_id);
create index if not exists dose_logs_scheduled_for_idx  on public.dose_logs (scheduled_for);

-- ------------------------------------------------------------
--  notifications — reminders / alerts shown in the app
-- ------------------------------------------------------------
create table if not exists public.notifications (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users (id) on delete cascade,
  icon        text not null default 'bell'
                check (icon in ('bell','check','star','pill','clock','megaphone','gear','shield')),
  title       text not null,
  subtitle    text,
  group_label text not null default 'Today',
  action      text check (action in ('take','reschedule')),
  unread      boolean not null default true,
  created_at  timestamptz not null default now()
);
create index if not exists notifications_user_id_idx on public.notifications (user_id);

-- ============================================================
--  Row Level Security — each user only sees / edits their own rows
-- ============================================================
alter table public.profiles      enable row level security;
alter table public.medications   enable row level security;
alter table public.dose_logs     enable row level security;
alter table public.notifications enable row level security;

-- profiles (keyed by id = auth.uid())
drop policy if exists "profiles_select_own" on public.profiles;
drop policy if exists "profiles_insert_own" on public.profiles;
drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_select_own" on public.profiles for select using (auth.uid() = id);
create policy "profiles_insert_own" on public.profiles for insert with check (auth.uid() = id);
create policy "profiles_update_own" on public.profiles for update using (auth.uid() = id);

-- medications
drop policy if exists "medications_owner_all" on public.medications;
create policy "medications_owner_all" on public.medications
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- dose_logs
drop policy if exists "dose_logs_owner_all" on public.dose_logs;
create policy "dose_logs_owner_all" on public.dose_logs
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- notifications
drop policy if exists "notifications_owner_all" on public.notifications;
create policy "notifications_owner_all" on public.notifications
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ============================================================
--  Auto-create a profile row when a new auth user signs up
-- ============================================================
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, email, name)
  values (new.id, new.email, coalesce(new.raw_user_meta_data->>'name', ''))
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ============================================================
--  Keep updated_at fresh on profiles & medications
-- ============================================================
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at before update on public.profiles
  for each row execute function public.set_updated_at();

drop trigger if exists medications_set_updated_at on public.medications;
create trigger medications_set_updated_at before update on public.medications
  for each row execute function public.set_updated_at();

-- ============================================================
--  Done. Tables: profiles, medications, dose_logs, notifications.
-- ============================================================
