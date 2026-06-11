-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Subscriptions & paywall
--  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-084
--
--  Modèle simple à 2 tiers : free / premium.
--  Source de vérité côté serveur — l'app client ne fait que lire son statut.
--  Webhook Stripe (CODE-085) ira UPSERT dans cette table.
-- ════════════════════════════════════════════════════════════════════════════

create extension if not exists "uuid-ossp";

-- ─────────────────────────────────────────────────────────────────────────────
--  Table : cas_pratique_subscriptions
-- ─────────────────────────────────────────────────────────────────────────────

create table if not exists public.cas_pratique_subscriptions (
  user_id              uuid primary key references auth.users(id) on delete cascade,

  -- Tier : 'free' | 'premium' | 'premium_trial'
  tier                 text not null default 'free'
                       check (tier in ('free', 'premium', 'premium_trial')),

  -- Status Stripe-aligné : 'active' | 'past_due' | 'canceled' | 'incomplete'
  status               text not null default 'active'
                       check (status in (
                         'active', 'past_due', 'canceled',
                         'incomplete', 'unpaid', 'trialing'
                       )),

  -- Métadonnées Stripe (remplies par le webhook CODE-085)
  stripe_customer_id   text,
  stripe_subscription_id text,
  stripe_price_id      text,
  stripe_product_id    text,

  -- Cycle de facturation
  current_period_start timestamptz,
  current_period_end   timestamptz,
  cancel_at_period_end boolean not null default false,
  canceled_at          timestamptz,
  trial_ends_at        timestamptz,

  -- Entitlements granulaires (Phase R pourra les rendre dynamiques)
  entitlements         text[] not null default array[]::text[],

  -- Audit
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now()
);

comment on table public.cas_pratique_subscriptions is
  'Source de vérité côté serveur pour le statut d''abonnement utilisateur. UPSERT par webhook Stripe (CODE-085).';

create index if not exists idx_cp_subscriptions_tier_status
  on public.cas_pratique_subscriptions(tier, status);

create index if not exists idx_cp_subscriptions_period_end
  on public.cas_pratique_subscriptions(current_period_end)
  where status = 'active';

-- ─────────────────────────────────────────────────────────────────────────────
--  Trigger updated_at
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.cp_subscriptions_set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists trg_cp_subscriptions_updated_at
  on public.cas_pratique_subscriptions;
create trigger trg_cp_subscriptions_updated_at
  before update on public.cas_pratique_subscriptions
  for each row execute function public.cp_subscriptions_set_updated_at();

-- ─────────────────────────────────────────────────────────────────────────────
--  RLS — l'utilisateur peut LIRE son propre abonnement, écrire seulement
--  via service_role (webhook Stripe).
-- ─────────────────────────────────────────────────────────────────────────────

alter table public.cas_pratique_subscriptions enable row level security;

drop policy if exists "Users read own subscription" on public.cas_pratique_subscriptions;
create policy "Users read own subscription"
  on public.cas_pratique_subscriptions
  for select
  to authenticated
  using (user_id = auth.uid());

-- (Pas de policy INSERT / UPDATE / DELETE → service_role seulement)

-- ─────────────────────────────────────────────────────────────────────────────
--  Fonction : statut effectif d'un utilisateur
--  Retourne 'free' pour les users sans entrée dans la table.
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.cp_get_user_tier(p_user_id uuid)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_tier text;
  v_status text;
  v_period_end timestamptz;
begin
  select tier, status, current_period_end
    into v_tier, v_status, v_period_end
  from public.cas_pratique_subscriptions
  where user_id = p_user_id;

  if v_tier is null then
    return 'free';
  end if;

  -- Si l'abonnement est expiré (period_end passé), on retourne 'free'
  if v_status in ('canceled', 'unpaid') then
    return 'free';
  end if;

  if v_period_end is not null and v_period_end < now() then
    return 'free';
  end if;

  return v_tier;
end;
$$;

revoke all on function public.cp_get_user_tier(uuid) from public, anon;
grant execute on function public.cp_get_user_tier(uuid) to authenticated, service_role;

-- ─────────────────────────────────────────────────────────────────────────────
--  Vue : ma souscription (utilisable depuis le client via PostgREST)
-- ─────────────────────────────────────────────────────────────────────────────

create or replace view public.cp_my_subscription as
  select
    user_id,
    tier,
    status,
    cancel_at_period_end,
    current_period_start,
    current_period_end,
    trial_ends_at,
    entitlements,
    updated_at
  from public.cas_pratique_subscriptions
  where user_id = auth.uid();

grant select on public.cp_my_subscription to authenticated;

-- ─────────────────────────────────────────────────────────────────────────────
--  Tracking : combien de cas faits cette semaine (pour le tier free)
--  Lecture seule, calcul à la volée.
-- ─────────────────────────────────────────────────────────────────────────────

create or replace view public.cp_my_weekly_case_count as
  select
    auth.uid() as user_id,
    count(distinct a.case_id) as cases_played_this_week,
    date_trunc('week', now()) as week_start
  from public.cas_pratique_attempts a
  where a.user_id = auth.uid()
    and a.created_at >= date_trunc('week', now())
    and a.created_at <  date_trunc('week', now()) + interval '1 week';

grant select on public.cp_my_weekly_case_count to authenticated;
