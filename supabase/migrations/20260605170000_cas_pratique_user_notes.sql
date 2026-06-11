-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Annotations privées sur sa copie
--  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-091
--
--  Permet à l'utilisateur d'ajouter des annotations privées sur sa propre
--  copie corrigée (par question ou par rubric point).
--
--  Cas d'usage :
--   • "À revoir avant le concours"
--   • "Important : article 122-5"
--   • "Confondu avec état de nécessité — attention"
--
--  Recherchable via full-text français.
-- ════════════════════════════════════════════════════════════════════════════

create extension if not exists "uuid-ossp";
create extension if not exists "pg_trgm";

-- ─────────────────────────────────────────────────────────────────────────────
--  Table principale
-- ─────────────────────────────────────────────────────────────────────────────

create table if not exists public.cas_pratique_user_notes (
  id            uuid primary key default uuid_generate_v4(),
  user_id       uuid not null references auth.users(id) on delete cascade,

  -- Ce qu'on annote (au moins un des deux non-null)
  attempt_id    uuid references public.cas_pratique_attempts(id) on delete cascade,
  question_id   uuid references public.cas_pratique_questions(id) on delete cascade,
  rubric_point_id uuid references public.cas_pratique_rubric_points(id) on delete set null,
  case_id       uuid references public.cas_pratique_cases(id) on delete cascade,

  -- Le contenu de l'annotation
  body          text not null check (char_length(body) between 1 and 2000),

  -- Tags libres ("revoir", "important", "concours")
  tags          text[] not null default array[]::text[],

  -- Couleur d'highlight pour l'UI (#FFD400, #1147D9, etc.)
  color         text,

  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

comment on table public.cas_pratique_user_notes is
  'Annotations privées sur sa propre copie (correction details). Recherchables.';

create index if not exists idx_cp_notes_user_recent
  on public.cas_pratique_user_notes(user_id, created_at desc);

create index if not exists idx_cp_notes_attempt
  on public.cas_pratique_user_notes(attempt_id)
  where attempt_id is not null;

create index if not exists idx_cp_notes_question
  on public.cas_pratique_user_notes(question_id)
  where question_id is not null;

create index if not exists idx_cp_notes_case
  on public.cas_pratique_user_notes(case_id)
  where case_id is not null;

create index if not exists idx_cp_notes_tags
  on public.cas_pratique_user_notes using gin(tags);

-- Trigram pour recherche full-text approximative
create index if not exists idx_cp_notes_body_trgm
  on public.cas_pratique_user_notes using gin(body gin_trgm_ops);

-- ─────────────────────────────────────────────────────────────────────────────
--  Trigger updated_at
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.cp_notes_set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists trg_cp_notes_updated_at
  on public.cas_pratique_user_notes;
create trigger trg_cp_notes_updated_at
  before update on public.cas_pratique_user_notes
  for each row execute function public.cp_notes_set_updated_at();

-- ─────────────────────────────────────────────────────────────────────────────
--  RLS : un user gère exclusivement ses propres notes
-- ─────────────────────────────────────────────────────────────────────────────

alter table public.cas_pratique_user_notes enable row level security;

drop policy if exists "cp_notes_select_own" on public.cas_pratique_user_notes;
create policy "cp_notes_select_own"
  on public.cas_pratique_user_notes
  for select
  to authenticated
  using (user_id = auth.uid());

drop policy if exists "cp_notes_insert_own" on public.cas_pratique_user_notes;
create policy "cp_notes_insert_own"
  on public.cas_pratique_user_notes
  for insert
  to authenticated
  with check (user_id = auth.uid());

drop policy if exists "cp_notes_update_own" on public.cas_pratique_user_notes;
create policy "cp_notes_update_own"
  on public.cas_pratique_user_notes
  for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

drop policy if exists "cp_notes_delete_own" on public.cas_pratique_user_notes;
create policy "cp_notes_delete_own"
  on public.cas_pratique_user_notes
  for delete
  to authenticated
  using (user_id = auth.uid());

-- ─────────────────────────────────────────────────────────────────────────────
--  Vue enrichie : notes avec contexte du cas
-- ─────────────────────────────────────────────────────────────────────────────

create or replace view public.cp_my_notes_enriched as
  select
    n.id,
    n.user_id,
    n.attempt_id,
    n.question_id,
    n.rubric_point_id,
    n.case_id,
    n.body,
    n.tags,
    n.color,
    n.created_at,
    n.updated_at,
    c.slug as case_slug,
    c.title as case_title,
    c.year as case_year,
    q.position as question_position
  from public.cas_pratique_user_notes n
  left join public.cas_pratique_cases c on c.id = n.case_id
  left join public.cas_pratique_questions q on q.id = n.question_id
  where n.user_id = auth.uid()
  order by n.created_at desc;

grant select on public.cp_my_notes_enriched to authenticated;

-- ─────────────────────────────────────────────────────────────────────────────
--  Fonction : recherche dans les notes (trigram fuzzy)
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.cp_search_notes(
  p_query text,
  p_limit integer default 30
)
returns setof public.cp_my_notes_enriched
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user uuid := auth.uid();
begin
  if v_user is null then
    return;
  end if;

  return query
    select *
    from public.cp_my_notes_enriched
    where user_id = v_user
      and (
        body ilike '%' || p_query || '%'
        or exists (
          select 1 from unnest(tags) t
          where t ilike '%' || p_query || '%'
        )
      )
    order by created_at desc
    limit greatest(p_limit, 1);
end;
$$;

revoke all on function public.cp_search_notes(text, integer) from public, anon;
grant execute on function public.cp_search_notes(text, integer) to authenticated;
