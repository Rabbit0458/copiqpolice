-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Bookmarks utilisateur
--  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-089
--
--  Table simple : un utilisateur peut bookmarker des cas pratiques.
--  Synchro multi-device via Supabase Realtime.
-- ════════════════════════════════════════════════════════════════════════════

create extension if not exists "uuid-ossp";

-- ─────────────────────────────────────────────────────────────────────────────
--  Table principale
-- ─────────────────────────────────────────────────────────────────────────────

create table if not exists public.cas_pratique_user_bookmarks (
  user_id       uuid not null references auth.users(id) on delete cascade,
  case_id       uuid not null references public.cas_pratique_cases(id) on delete cascade,
  bookmarked_at timestamptz not null default now(),
  note          text, -- annotation libre courte

  primary key (user_id, case_id)
);

comment on table public.cas_pratique_user_bookmarks is
  'Cas pratiques mis en favoris par chaque utilisateur. Sync multi-device.';

create index if not exists idx_cp_bookmarks_user_date
  on public.cas_pratique_user_bookmarks(user_id, bookmarked_at desc);

create index if not exists idx_cp_bookmarks_case
  on public.cas_pratique_user_bookmarks(case_id);

-- ─────────────────────────────────────────────────────────────────────────────
--  RLS — un user gère uniquement ses propres bookmarks
-- ─────────────────────────────────────────────────────────────────────────────

alter table public.cas_pratique_user_bookmarks enable row level security;

drop policy if exists "cp_bookmarks_select_own"
  on public.cas_pratique_user_bookmarks;
create policy "cp_bookmarks_select_own"
  on public.cas_pratique_user_bookmarks
  for select
  to authenticated
  using (user_id = auth.uid());

drop policy if exists "cp_bookmarks_insert_own"
  on public.cas_pratique_user_bookmarks;
create policy "cp_bookmarks_insert_own"
  on public.cas_pratique_user_bookmarks
  for insert
  to authenticated
  with check (user_id = auth.uid());

drop policy if exists "cp_bookmarks_update_own"
  on public.cas_pratique_user_bookmarks;
create policy "cp_bookmarks_update_own"
  on public.cas_pratique_user_bookmarks
  for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

drop policy if exists "cp_bookmarks_delete_own"
  on public.cas_pratique_user_bookmarks;
create policy "cp_bookmarks_delete_own"
  on public.cas_pratique_user_bookmarks
  for delete
  to authenticated
  using (user_id = auth.uid());

-- ─────────────────────────────────────────────────────────────────────────────
--  Vue enrichie : mes favoris avec métadonnées du cas
-- ─────────────────────────────────────────────────────────────────────────────

create or replace view public.cp_my_bookmarks as
  select
    b.user_id,
    b.case_id,
    b.bookmarked_at,
    b.note,
    c.slug as case_slug,
    c.title as case_title,
    c.year as case_year,
    c.theme_id,
    c.difficulty
  from public.cas_pratique_user_bookmarks b
  join public.cas_pratique_cases c on c.id = b.case_id
  where b.user_id = auth.uid()
  order by b.bookmarked_at desc;

grant select on public.cp_my_bookmarks to authenticated;

-- ─────────────────────────────────────────────────────────────────────────────
--  Fonction toggle : ajout / retrait atomique (idempotent)
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.cp_toggle_bookmark(p_case_id uuid)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user uuid := auth.uid();
  v_exists boolean;
begin
  if v_user is null then
    raise exception 'not_authenticated';
  end if;

  select exists(
    select 1 from public.cas_pratique_user_bookmarks
    where user_id = v_user and case_id = p_case_id
  ) into v_exists;

  if v_exists then
    delete from public.cas_pratique_user_bookmarks
    where user_id = v_user and case_id = p_case_id;
    return false; -- nouvel état : non-bookmarké
  else
    insert into public.cas_pratique_user_bookmarks (user_id, case_id)
    values (v_user, p_case_id)
    on conflict (user_id, case_id) do nothing;
    return true; -- nouvel état : bookmarké
  end if;
end;
$$;

revoke all on function public.cp_toggle_bookmark(uuid) from public, anon;
grant execute on function public.cp_toggle_bookmark(uuid) to authenticated;
