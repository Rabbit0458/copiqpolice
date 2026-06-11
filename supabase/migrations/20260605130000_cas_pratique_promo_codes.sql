-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Codes promo + gift cards
--  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-087
--
--  Couvre :
--   • Codes promo alphanum (STUDENT50, BLACKFRIDAY, etc.)
--   • Réduction % ou montant fixe (en centimes EUR)
--   • Limites : usage global, usage par user
--   • Période de validité (starts_at / ends_at)
--   • Gift cards (mode 'gift') : code généré, valeur, destinataire
--   • Audit de chaque utilisation (redemption)
--
--  Les codes peuvent être créés côté admin (Phase R) ou via edge fn admin.
-- ════════════════════════════════════════════════════════════════════════════

create extension if not exists "uuid-ossp";

-- ─────────────────────────────────────────────────────────────────────────────
--  Table : cas_pratique_promo_codes
-- ─────────────────────────────────────────────────────────────────────────────

create table if not exists public.cas_pratique_promo_codes (
  id                  uuid primary key default uuid_generate_v4(),

  -- Code public, uppercase (ex: "STUDENT50") — unique
  code                text unique not null check (char_length(code) between 4 and 32),

  -- Type : 'promo' (campagne marketing) | 'gift' (carte cadeau achetée)
  type                text not null default 'promo'
                      check (type in ('promo', 'gift')),

  -- Type de réduction : 'percent' | 'fixed_amount' | 'free_months'
  discount_kind       text not null
                      check (discount_kind in ('percent', 'fixed_amount', 'free_months')),

  -- Valeur de la réduction (interprétée selon discount_kind)
  --   percent       : 0..100 (ex: 25 = -25%)
  --   fixed_amount  : montant en centimes EUR (ex: 1000 = -10€)
  --   free_months   : nombre de mois offerts (ex: 1 = 1 mois gratuit)
  discount_value      integer not null check (discount_value > 0),

  -- Limite globale (null = pas de limite)
  max_redemptions     integer check (max_redemptions is null or max_redemptions > 0),

  -- Limite par user (default 1 = chacun ne peut l'utiliser qu'une fois)
  max_per_user        integer not null default 1 check (max_per_user > 0),

  -- Compteur d'utilisations (auto-incrementé par trigger)
  redemption_count    integer not null default 0,

  -- Période de validité (null = pas de limite)
  starts_at           timestamptz,
  ends_at             timestamptz,

  -- Plans éligibles ; null = tous les plans
  -- Ex: ['price_monthly_xxx', 'price_yearly_xxx']
  eligible_price_ids  text[],

  -- Pour les gift cards : qui a acheté, qui doit recevoir
  purchased_by        uuid references auth.users(id) on delete set null,
  recipient_email     text,
  message             text, -- message personnalisé du donneur

  -- Stripe coupon ID (si lié à un coupon Stripe pour application au checkout)
  stripe_coupon_id    text,
  stripe_promotion_code_id text,

  -- Audit
  created_at          timestamptz not null default now(),
  created_by          uuid references auth.users(id) on delete set null,
  is_active           boolean not null default true
);

comment on table public.cas_pratique_promo_codes is
  'Codes promo et gift cards. Validation côté serveur via edge fn cas_pratique_redeem_promo.';

create index if not exists idx_cp_promo_codes_active
  on public.cas_pratique_promo_codes(is_active, ends_at)
  where is_active = true;

create index if not exists idx_cp_promo_codes_recipient
  on public.cas_pratique_promo_codes(recipient_email)
  where recipient_email is not null;

-- ─────────────────────────────────────────────────────────────────────────────
--  Table : cas_pratique_promo_redemptions (audit / limite par user)
-- ─────────────────────────────────────────────────────────────────────────────

create table if not exists public.cas_pratique_promo_redemptions (
  id              uuid primary key default uuid_generate_v4(),
  promo_code_id   uuid not null references public.cas_pratique_promo_codes(id) on delete cascade,
  user_id         uuid not null references auth.users(id) on delete cascade,
  redeemed_at     timestamptz not null default now(),
  applied_to_subscription_id text, -- stripe sub id si lié
  metadata        jsonb default '{}'::jsonb
);

create index if not exists idx_cp_promo_redemptions_user
  on public.cas_pratique_promo_redemptions(user_id, redeemed_at desc);

create index if not exists idx_cp_promo_redemptions_code
  on public.cas_pratique_promo_redemptions(promo_code_id);

-- Unique constraint : un user ne peut utiliser le même code que `max_per_user` fois
-- → géré par la fonction de validation, pas par contrainte UNIQUE (pour permettre max_per_user > 1)

-- ─────────────────────────────────────────────────────────────────────────────
--  Trigger : incrément du redemption_count
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.cp_promo_increment_count()
returns trigger
language plpgsql
as $$
begin
  update public.cas_pratique_promo_codes
     set redemption_count = redemption_count + 1
   where id = new.promo_code_id;
  return new;
end;
$$;

drop trigger if exists trg_cp_promo_inc_count
  on public.cas_pratique_promo_redemptions;
create trigger trg_cp_promo_inc_count
  after insert on public.cas_pratique_promo_redemptions
  for each row execute function public.cp_promo_increment_count();

-- ─────────────────────────────────────────────────────────────────────────────
--  RLS : codes promo lecture publique LIMITÉE (juste validation),
--        redemptions lecture only own, écriture service_role only
-- ─────────────────────────────────────────────────────────────────────────────

alter table public.cas_pratique_promo_codes enable row level security;
alter table public.cas_pratique_promo_redemptions enable row level security;

-- Codes : pas de lecture publique des codes secrets
-- (les utilisateurs valident via edge fn qui a service_role)
drop policy if exists "cp_promo_codes_no_public_read" on public.cas_pratique_promo_codes;
-- pas de policy = aucune lecture autorisée pour authenticated/anon

-- Redemptions : un user peut voir ses propres utilisations
drop policy if exists "cp_promo_redemptions_read_own" on public.cas_pratique_promo_redemptions;
create policy "cp_promo_redemptions_read_own"
  on public.cas_pratique_promo_redemptions
  for select
  to authenticated
  using (user_id = auth.uid());

-- ─────────────────────────────────────────────────────────────────────────────
--  Fonction de validation : retourne le code valide pour un user, ou null
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.cp_validate_promo_code(
  p_code text,
  p_user_id uuid,
  p_price_id text default null
)
returns table (
  valid boolean,
  reason text,
  promo_id uuid,
  discount_kind text,
  discount_value integer,
  stripe_coupon_id text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_promo public.cas_pratique_promo_codes;
  v_user_uses integer;
begin
  -- 1. Trouver le code
  select * into v_promo
  from public.cas_pratique_promo_codes
  where code = upper(p_code) and is_active = true
  limit 1;

  if not found then
    return query select false, 'code_not_found', null::uuid, null::text, null::integer, null::text;
    return;
  end if;

  -- 2. Période de validité
  if v_promo.starts_at is not null and now() < v_promo.starts_at then
    return query select false, 'not_yet_valid', v_promo.id, v_promo.discount_kind, v_promo.discount_value, v_promo.stripe_coupon_id;
    return;
  end if;

  if v_promo.ends_at is not null and now() > v_promo.ends_at then
    return query select false, 'expired', v_promo.id, v_promo.discount_kind, v_promo.discount_value, v_promo.stripe_coupon_id;
    return;
  end if;

  -- 3. Limite globale
  if v_promo.max_redemptions is not null
     and v_promo.redemption_count >= v_promo.max_redemptions then
    return query select false, 'max_global_reached', v_promo.id, v_promo.discount_kind, v_promo.discount_value, v_promo.stripe_coupon_id;
    return;
  end if;

  -- 4. Limite par user
  select count(*) into v_user_uses
  from public.cas_pratique_promo_redemptions
  where promo_code_id = v_promo.id and user_id = p_user_id;

  if v_user_uses >= v_promo.max_per_user then
    return query select false, 'max_per_user_reached', v_promo.id, v_promo.discount_kind, v_promo.discount_value, v_promo.stripe_coupon_id;
    return;
  end if;

  -- 5. Plan éligible
  if v_promo.eligible_price_ids is not null
     and array_length(v_promo.eligible_price_ids, 1) > 0
     and p_price_id is not null
     and not (p_price_id = any(v_promo.eligible_price_ids)) then
    return query select false, 'plan_not_eligible', v_promo.id, v_promo.discount_kind, v_promo.discount_value, v_promo.stripe_coupon_id;
    return;
  end if;

  -- ✅ Tout est valide
  return query select true, 'valid', v_promo.id, v_promo.discount_kind, v_promo.discount_value, v_promo.stripe_coupon_id;
end;
$$;

revoke all on function public.cp_validate_promo_code(text, uuid, text) from public, anon;
grant execute on function public.cp_validate_promo_code(text, uuid, text) to authenticated, service_role;

-- ─────────────────────────────────────────────────────────────────────────────
--  Seeds initiaux (à compléter via panel admin Phase R)
-- ─────────────────────────────────────────────────────────────────────────────

insert into public.cas_pratique_promo_codes
  (code, type, discount_kind, discount_value, max_redemptions, max_per_user, ends_at, is_active)
values
  ('WELCOME10', 'promo', 'percent', 10, 1000, 1, now() + interval '90 days', true),
  ('STUDENT50', 'promo', 'percent', 50, 500, 1, now() + interval '180 days', true),
  ('LAUNCH7DAYS', 'promo', 'free_months', 1, 200, 1, now() + interval '60 days', true)
on conflict (code) do nothing;
