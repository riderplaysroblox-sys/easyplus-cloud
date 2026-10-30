-- Run in Supabase SQL Editor. This starter table is intentionally simple.
create table if not exists public.overlay_state (
  id integer primary key check (id = 1),
  mode text not null default 'idle' check (mode in ('idle','playing')),
  alert jsonb,
  updated_at timestamptz not null default now()
);
insert into public.overlay_state(id,mode,alert) values(1,'idle',null) on conflict(id) do nothing;
alter table public.overlay_state enable row level security;
-- IMPORTANT: replace these permissive policies with authenticated dashboard-only
-- write access before deploying publicly. Overlay needs read access only.
create policy "overlay state readable by anon" on public.overlay_state
  for select to anon using (true);
create policy "temporary demo writes by anon" on public.overlay_state
  for all to anon using (true) with check (true);
alter publication supabase_realtime add table public.overlay_state;
