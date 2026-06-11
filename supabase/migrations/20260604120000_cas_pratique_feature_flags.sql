-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Feature flags remote config
--  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-076
--
--  Permet de moduler le rollout d'une feature sans redéploiement de l'app.
--  Toutes les valeurs sont lues en read-only par le client (RLS public).
--  Écriture réservée au service_role (panel admin Phase R).
-- ════════════════════════════════════════════════════════════════════════════

create extension if not exists "uuid-ossp";

-- ─────────────────────────────────────────────────────────────────────────────
--  Table principale
-- ─────────────────────────────────────────────────────────────────────────────

create table if not exists public.cp_feature_flags (
  key              text primary key,
  description      text,

  -- Type valeur : 'bool' | 'string' | 'int' | 'double' | 'variant'
  value_type       text not null check (value_type in ('bool','string','int','double','variant')),

  -- Valeur par défaut (toujours stockée en JSON pour l'uniformité)
  -- exemples : true, "Soumettre", 42, 3.14, ["A","B","C"]
  value_default    jsonb not null,

  -- Pour rollout progressif : pourcentage 0..100 ; null = pas de rollout (full)
  rollout_percent  integer check (rollout_percent is null or (rollout_percent between 0 and 100)),

  -- Drapeau global : false = flag totalement désactivé (force defaultValue côté client)
  is_active        boolean not null default true,

  -- Pour ciblage par segment (à étendre Phase R) : null = global
  segment          text,

  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now()
);

comment on table public.cp_feature_flags is
  'Remote config des feature flags Cas Pratique. Lecture publique, écriture service_role uniquement.';

create index if not exists idx_cp_feature_flags_active
  on public.cp_feature_flags(is_active)
  where is_active = true;

-- ─────────────────────────────────────────────────────────────────────────────
--  Trigger updated_at
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.cp_feature_flags_set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists trg_cp_feature_flags_updated_at on public.cp_feature_flags;
create trigger trg_cp_feature_flags_updated_at
  before update on public.cp_feature_flags
  for each row execute function public.cp_feature_flags_set_updated_at();

-- ─────────────────────────────────────────────────────────────────────────────
--  RLS — lecture publique (anon + authenticated), écriture service_role
-- ─────────────────────────────────────────────────────────────────────────────

alter table public.cp_feature_flags enable row level security;

drop policy if exists "cp_feature_flags_select_all" on public.cp_feature_flags;
create policy "cp_feature_flags_select_all"
  on public.cp_feature_flags
  for select
  to anon, authenticated
  using (is_active = true);

-- (Écriture : aucune policy = service_role only — c'est l'admin via Phase R)

-- ─────────────────────────────────────────────────────────────────────────────
--  Seeds : flags initiaux alignés sur CpFlagKeys côté client
-- ─────────────────────────────────────────────────────────────────────────────

insert into public.cp_feature_flags (key, description, value_type, value_default, rollout_percent, is_active)
values
  ('cp_edge_correction',
   'Bascule l''app sur l''edge function TS au lieu du moteur Dart embarqué (CODE-051). Canary progressif.',
   'bool', 'false'::jsonb, 0, true),

  ('cp_new_correction_screen',
   'Nouvelle page correction premium (refonte CODE-067 dark mode + a11y).',
   'bool', 'false'::jsonb, 100, true),

  ('cp_share_story_enabled',
   'Partage natif story (CODE-069).',
   'bool', 'true'::jsonb, 100, true),

  ('cp_pdf_export_enabled',
   'Export PDF de la copie corrigée (CODE-070).',
   'bool', 'true'::jsonb, 100, true),

  ('cp_validate_button_style',
   'Style du CTA principal. Variants : blue / gold / gradient.',
   'variant', '["blue","gold","gradient"]'::jsonb, null, true),

  ('cp_validate_button_copy',
   'Copy du bouton de validation. Variants : Valider / Soumettre / Terminer.',
   'variant', '["Valider","Soumettre","Terminer"]'::jsonb, null, true),

  ('cp_question_order',
   'Ordre des questions. Variants : sequential / shuffled.',
   'variant', '["sequential","shuffled"]'::jsonb, null, true),

  ('cp_inline_hints',
   'Hints inline pendant la saisie.',
   'bool', 'false'::jsonb, 50, true)
on conflict (key) do nothing;

-- ─────────────────────────────────────────────────────────────────────────────
--  Vue pratique pour le client (ne renvoie que les colonnes utiles)
-- ─────────────────────────────────────────────────────────────────────────────

create or replace view public.cp_feature_flags_public as
  select
    key,
    value_type,
    value_default,
    rollout_percent,
    segment
  from public.cp_feature_flags
  where is_active = true;

grant select on public.cp_feature_flags_public to anon, authenticated;
