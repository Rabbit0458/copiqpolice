-- Source unique des droits Premium pour Stripe, le web et Flutter.

create table if not exists public.cas_pratique_subscriptions (
  user_id uuid primary key references auth.users(id) on delete cascade,
  tier text not null default 'free' check (tier in ('free','premium','premium_trial')),
  status text not null default 'active' check (status in ('active','past_due','canceled','incomplete','unpaid','trialing')),
  stripe_customer_id text,
  stripe_subscription_id text,
  stripe_price_id text,
  stripe_product_id text,
  current_period_start timestamptz,
  current_period_end timestamptz,
  cancel_at_period_end boolean not null default false,
  canceled_at timestamptz,
  trial_ends_at timestamptz,
  entitlements text[] not null default array[]::text[],
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index if not exists cp_subscriptions_stripe_subscription_uidx
  on public.cas_pratique_subscriptions(stripe_subscription_id)
  where stripe_subscription_id is not null;
create index if not exists cp_subscriptions_tier_status_idx
  on public.cas_pratique_subscriptions(tier,status);

create or replace function public.cp_subscriptions_set_updated_at()
returns trigger language plpgsql set search_path = '' as $$
begin new.updated_at := now(); return new; end; $$;
drop trigger if exists cp_subscriptions_updated_at on public.cas_pratique_subscriptions;
create trigger cp_subscriptions_updated_at before update on public.cas_pratique_subscriptions
for each row execute function public.cp_subscriptions_set_updated_at();

create table if not exists public.cp_stripe_webhook_events (
  stripe_event_id text primary key,
  event_type text not null,
  processed_at timestamptz not null default now()
);

alter table public.cp_stripe_webhook_events enable row level security;
revoke all on table public.cp_stripe_webhook_events from public, anon, authenticated;
grant select, insert on table public.cp_stripe_webhook_events to service_role;

-- Le client peut seulement lire son abonnement. Les écritures sont réservées
-- aux fonctions serveur et aux RPC d'administration protégées.
alter table public.cas_pratique_subscriptions enable row level security;
drop policy if exists "Users read own subscription" on public.cas_pratique_subscriptions;
create policy "Users read own subscription"
on public.cas_pratique_subscriptions for select to authenticated
using ((select auth.uid()) = user_id);

-- Fonction commune utilisée par les verrous Flutter et web.
create or replace function public.is_user_premium(p_user_id uuid)
returns boolean
language plpgsql stable security definer set search_path = '' as $$
declare v_allowed boolean;
begin
  if p_user_id is null then return false; end if;
  if (select auth.uid()) is distinct from p_user_id
     and coalesce(public.has_admin_role('owner','admin'), false) is not true then
    raise exception 'Accès refusé' using errcode = '42501';
  end if;

  select exists (
    select 1 from public.cas_pratique_subscriptions s
    where s.user_id = p_user_id
      and s.tier in ('premium', 'premium_trial')
      and s.status in ('active', 'trialing')
      and (s.current_period_end is null or s.current_period_end > now())
  ) into v_allowed;
  return coalesce(v_allowed, false);
end;
$$;
revoke all on function public.is_user_premium(uuid) from public, anon;
grant execute on function public.is_user_premium(uuid) to authenticated, service_role;

-- Vue client avec security_invoker afin de conserver la RLS de la table.
create or replace view public.cp_my_subscription
with (security_invoker = true) as
select user_id, tier, status, cancel_at_period_end, current_period_start,
       current_period_end, trial_ends_at, entitlements, updated_at
from public.cas_pratique_subscriptions;
revoke all on public.cp_my_subscription from public, anon;
grant select on public.cp_my_subscription to authenticated;

-- Liste de facturation du panel admin.
drop function if exists public.admin_subscriptions_overview(text,text,integer,integer);
create or replace function public.admin_subscriptions_overview(
  p_search text default null,
  p_filter text default null,
  p_limit integer default 100,
  p_offset integer default 0
) returns table(
  user_id uuid, email text, first_name text, last_name text, username text,
  plan text, status text, current_period_start timestamptz,
  current_period_end timestamptz, is_premium boolean, is_expired boolean,
  is_free boolean, stripe_customer_id text, created_at timestamptz
)
language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.has_admin_role('owner','admin') then
    raise exception 'Accès refusé' using errcode = '42501';
  end if;
  return query
  select u.user_id, u.email, u.first_name, u.last_name, u.username,
    case s.stripe_price_id
      when current_setting('app.settings.stripe_price_week', true) then 'week'
      when current_setting('app.settings.stripe_price_year', true) then 'year'
      else case when s.tier = 'premium_trial' then 'trial' else 'month' end
    end,
    coalesce(s.status, 'free'), s.current_period_start, s.current_period_end,
    coalesce(s.tier in ('premium','premium_trial') and s.status in ('active','trialing')
      and (s.current_period_end is null or s.current_period_end > now()), false),
    coalesce(s.current_period_end <= now(), false),
    not coalesce(s.tier in ('premium','premium_trial') and s.status in ('active','trialing')
      and (s.current_period_end is null or s.current_period_end > now()), false),
    s.stripe_customer_id, coalesce(s.created_at, u.created_at)
  from public.user_profiles u
  left join public.cas_pratique_subscriptions s on s.user_id = u.user_id
  where (nullif(trim(coalesce(p_search,'')), '') is null
      or u.email ilike '%' || trim(p_search) || '%'
      or u.username ilike '%' || trim(p_search) || '%'
      or concat_ws(' ',u.first_name,u.last_name) ilike '%' || trim(p_search) || '%')
    and (p_filter is null or p_filter = ''
      or (p_filter = 'premium' and s.tier in ('premium','premium_trial') and s.status in ('active','trialing') and (s.current_period_end is null or s.current_period_end > now()))
      or (p_filter = 'expired' and s.current_period_end <= now())
      or (p_filter = 'free' and (s.user_id is null or s.tier = 'free' or s.status not in ('active','trialing'))))
  order by s.updated_at desc nulls last, u.created_at desc
  limit least(greatest(coalesce(p_limit,100),1),200)
  offset greatest(coalesce(p_offset,0),0);
end;
$$;
revoke all on function public.admin_subscriptions_overview(text,text,integer,integer) from public, anon;
grant execute on function public.admin_subscriptions_overview(text,text,integer,integer) to authenticated;

drop function if exists public.admin_grant_access(uuid,text,integer);
create or replace function public.admin_grant_access(
  p_user_id uuid, p_plan text default 'premium', p_duration_days integer default 30
) returns void language plpgsql security definer set search_path = '' as $$
begin
  if not public.has_admin_role('owner','admin') then raise exception 'Accès refusé' using errcode='42501'; end if;
  if p_duration_days < 1 or p_duration_days > 3660 then raise exception 'Durée invalide' using errcode='22023'; end if;
  insert into public.cas_pratique_subscriptions(
    user_id,tier,status,current_period_start,current_period_end,entitlements
  ) values (
    p_user_id, case when p_plan='trial' then 'premium_trial' else 'premium' end,
    case when p_plan='trial' then 'trialing' else 'active' end,
    now(), now() + make_interval(days => p_duration_days),
    array['unlimited_cases','school_access','no_ads','concours_blanc','annales_full']
  ) on conflict(user_id) do update set
    tier=excluded.tier,status=excluded.status,current_period_start=excluded.current_period_start,
    current_period_end=excluded.current_period_end,entitlements=excluded.entitlements,
    cancel_at_period_end=false,canceled_at=null,updated_at=now();
end; $$;
revoke all on function public.admin_grant_access(uuid,text,integer) from public, anon;
grant execute on function public.admin_grant_access(uuid,text,integer) to authenticated;

drop function if exists public.admin_revoke_access(uuid);
create or replace function public.admin_revoke_access(p_user_id uuid)
returns void language plpgsql security definer set search_path = '' as $$
begin
  if not public.has_admin_role('owner','admin') then raise exception 'Accès refusé' using errcode='42501'; end if;
  update public.cas_pratique_subscriptions set tier='free',status='canceled',
    current_period_end=now(),cancel_at_period_end=false,canceled_at=now(),updated_at=now()
  where user_id=p_user_id;
end; $$;
revoke all on function public.admin_revoke_access(uuid) from public, anon;
grant execute on function public.admin_revoke_access(uuid) to authenticated;

-- Realtime permet aux deux clients de se déverrouiller sans reconnexion.
do $$ begin
  alter publication supabase_realtime add table public.cas_pratique_subscriptions;
exception when duplicate_object then null;
end $$;
