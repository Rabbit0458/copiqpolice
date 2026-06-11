-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Fiches mémo (ressources rapides)
--  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-090
--
--  Fiches markdown courtes (1 page max) sur les thèmes du concours :
--   • "Déontologie en 5 points"
--   • "Articles clés du code pénal"
--   • "Procédure pénale — chronologie"
--   • etc.
--
--  Linkables depuis correction details (CODE-036) via tags.
-- ════════════════════════════════════════════════════════════════════════════

create extension if not exists "uuid-ossp";

-- ─────────────────────────────────────────────────────────────────────────────
--  Table principale
-- ─────────────────────────────────────────────────────────────────────────────

create table if not exists public.cas_pratique_memos (
  id            uuid primary key default uuid_generate_v4(),
  slug          text unique not null check (char_length(slug) between 3 and 100),
  title         text not null,
  excerpt       text,                       -- 200 chars max pour preview
  content_md    text not null,              -- markdown du contenu
  theme_id      uuid references public.cas_pratique_themes(id) on delete set null,
  tags          text[] not null default array[]::text[],
  reading_time_minutes integer,             -- estimation auto
  is_premium    boolean not null default false,
  is_published  boolean not null default true,
  display_order integer not null default 100, -- pour tri custom
  view_count    integer not null default 0,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  published_at  timestamptz default now()
);

comment on table public.cas_pratique_memos is
  'Fiches mémo rapides sur les thèmes du concours. Markdown court, linkable depuis correction details.';

create index if not exists idx_cp_memos_theme
  on public.cas_pratique_memos(theme_id, display_order)
  where is_published = true;

create index if not exists idx_cp_memos_tags
  on public.cas_pratique_memos using gin(tags)
  where is_published = true;

create index if not exists idx_cp_memos_slug
  on public.cas_pratique_memos(slug)
  where is_published = true;

-- ─────────────────────────────────────────────────────────────────────────────
--  Table de tracking : qui a lu quelle mémo
-- ─────────────────────────────────────────────────────────────────────────────

create table if not exists public.cas_pratique_memo_reads (
  user_id    uuid not null references auth.users(id) on delete cascade,
  memo_id    uuid not null references public.cas_pratique_memos(id) on delete cascade,
  read_at    timestamptz not null default now(),
  duration_seconds integer,
  primary key (user_id, memo_id)
);

create index if not exists idx_cp_memo_reads_user
  on public.cas_pratique_memo_reads(user_id, read_at desc);

-- ─────────────────────────────────────────────────────────────────────────────
--  Trigger updated_at
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.cp_memos_set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists trg_cp_memos_updated_at on public.cas_pratique_memos;
create trigger trg_cp_memos_updated_at
  before update on public.cas_pratique_memos
  for each row execute function public.cp_memos_set_updated_at();

-- ─────────────────────────────────────────────────────────────────────────────
--  Fonction : track une lecture (upsert avec timestamps)
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.cp_memo_mark_read(
  p_memo_id uuid,
  p_duration_seconds integer default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user uuid := auth.uid();
begin
  if v_user is null then
    raise exception 'not_authenticated';
  end if;

  insert into public.cas_pratique_memo_reads (user_id, memo_id, duration_seconds)
  values (v_user, p_memo_id, p_duration_seconds)
  on conflict (user_id, memo_id) do update
    set read_at = now(),
        duration_seconds = coalesce(excluded.duration_seconds, cas_pratique_memo_reads.duration_seconds);

  update public.cas_pratique_memos
     set view_count = view_count + 1
   where id = p_memo_id;
end;
$$;

revoke all on function public.cp_memo_mark_read(uuid, integer) from public, anon;
grant execute on function public.cp_memo_mark_read(uuid, integer) to authenticated;

-- ─────────────────────────────────────────────────────────────────────────────
--  RLS — lecture publique des mémos publiés, pas d'écriture côté client
-- ─────────────────────────────────────────────────────────────────────────────

alter table public.cas_pratique_memos enable row level security;
alter table public.cas_pratique_memo_reads enable row level security;

drop policy if exists "cp_memos_select_published" on public.cas_pratique_memos;
create policy "cp_memos_select_published"
  on public.cas_pratique_memos
  for select
  to anon, authenticated
  using (is_published = true);

drop policy if exists "cp_memo_reads_select_own" on public.cas_pratique_memo_reads;
create policy "cp_memo_reads_select_own"
  on public.cas_pratique_memo_reads
  for select
  to authenticated
  using (user_id = auth.uid());

-- ─────────────────────────────────────────────────────────────────────────────
--  Vue : liste mémos avec flag is_read_by_user
-- ─────────────────────────────────────────────────────────────────────────────

create or replace view public.cp_memos_with_read_state as
  select
    m.id,
    m.slug,
    m.title,
    m.excerpt,
    m.theme_id,
    m.tags,
    m.reading_time_minutes,
    m.is_premium,
    m.display_order,
    m.view_count,
    m.published_at,
    case
      when auth.uid() is null then false
      else exists (
        select 1 from public.cas_pratique_memo_reads r
        where r.user_id = auth.uid() and r.memo_id = m.id
      )
    end as is_read_by_user
  from public.cas_pratique_memos m
  where m.is_published = true
  order by m.display_order, m.published_at desc;

grant select on public.cp_memos_with_read_state to anon, authenticated;

-- ─────────────────────────────────────────────────────────────────────────────
--  Seeds : 5 fiches mémo initiales
-- ─────────────────────────────────────────────────────────────────────────────

insert into public.cas_pratique_memos
  (slug, title, excerpt, content_md, tags, reading_time_minutes, display_order)
values
  ('deontologie-5-points', 'Déontologie en 5 points',
   'Les fondamentaux du Code de déontologie de la police nationale.',
   '# Déontologie en 5 points

## 1. Respect des personnes
Tout policier traite les personnes avec respect, dignité et sans discrimination.

## 2. Probité et neutralité
Aucun avantage personnel ne doit être recherché dans l''exercice des fonctions.

## 3. Légalité et nécessité
Toute action doit être fondée sur la loi et strictement proportionnée.

## 4. Hiérarchie et discipline
Les ordres légaux du supérieur s''exécutent. Un ordre manifestement illégal doit être refusé.

## 5. Secret professionnel
Aucune information acquise dans l''exercice des fonctions ne doit être divulguée.',
   array['déontologie', 'fondamentaux']::text[], 3, 10),

  ('articles-cles-code-penal', 'Articles clés du code pénal',
   'Les articles incontournables pour le concours.',
   '# Articles clés du Code pénal

## Article 121-3 — Élément moral
Pas de crime sans intention. La faute non-intentionnelle ne suffit que dans les cas prévus.

## Article 122-5 — Légitime défense
Riposte nécessaire, simultanée et proportionnée à une atteinte injustifiée.

## Article 222-13 — Violences volontaires
Sanctionnées différemment selon l''ITT (incapacité totale de travail).

## Article 311-1 — Vol
Soustraction frauduleuse de la chose d''autrui.

## Article 433-3 — Outrage à agent
Paroles ou actes portant atteinte à la dignité de l''agent dans l''exercice de ses fonctions.',
   array['droit_penal', 'articles']::text[], 4, 20),

  ('procedure-penale-chronologie', 'Procédure pénale — chronologie',
   'De l''enquête à la condamnation : les étapes clefs.',
   '# Procédure pénale — chronologie

## 1. Enquête préliminaire ou flagrance
- Préliminaire : avec autorisation
- Flagrance : crime/délit en cours

## 2. Garde à vue (24h, prolongeable 24h)
Notification des droits dès le placement.

## 3. Saisine du procureur
Le procureur décide : classement, alternative, poursuites.

## 4. Instruction (si nécessaire)
Juge d''instruction. Mise en examen.

## 5. Jugement
Tribunal correctionnel / Cour d''assises.

## 6. Voies de recours
Appel, cassation.',
   array['procedure_penale', 'chronologie']::text[], 5, 30),

  ('reflexes-redaction-cas-pratique', 'Réflexes de rédaction',
   'Comment structurer une réponse de cas pratique gagnante.',
   '# Réflexes de rédaction — cas pratique

## Structure type
1. **Qualification** : ce que c''est juridiquement
2. **Texte applicable** : article + alinéa
3. **Conditions** : caractères constitutifs
4. **Application aux faits** : démonstration
5. **Conclusion** : décision motivée

## Mots-clés évaluateurs
- "En vertu de l''article…"
- "Les conditions sont réunies…"
- "Il convient donc de…"
- "Conformément au principe de…"

## Pièges classiques
- Confondre légitime défense et état de nécessité
- Oublier la proportionnalité
- Sauter l''étape de la qualification',
   array['methodologie', 'redaction']::text[], 4, 40),

  ('organisation-police-nationale', 'Organisation de la police nationale',
   'Hiérarchie et grandes directions.',
   '# Organisation de la police nationale

## Hiérarchie (du plus haut au plus bas)
1. Ministre de l''Intérieur
2. Directeur général de la police nationale (DGPN)
3. Préfets de police / préfets de département
4. Directeurs centraux

## Grandes directions
- DCPJ : Police judiciaire
- DCPAF : Police aux frontières
- DCSP : Sécurité publique
- DCCRS : Compagnies républicaines de sécurité
- DGSI : Sécurité intérieure
- RAID : Recherche, Assistance, Intervention, Dissuasion

## Corps
- Corps de conception et de direction (commissaires)
- Corps de commandement (officiers)
- Corps d''encadrement et d''application (gardiens, brigadiers)',
   array['organisation', 'hierarchie']::text[], 3, 50)
on conflict (slug) do nothing;
