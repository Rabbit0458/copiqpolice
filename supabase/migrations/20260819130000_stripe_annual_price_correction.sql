-- COP'IQ — Correction tarif Stripe annuel (ancien price_id créé par erreur
-- en 86,99€/mois, archivé). Nouveau price_id actif : 86,99€/an.
--
-- Périmètre : uniquement le plan "year" Stripe Web. N'affecte ni Apple IAP,
-- ni Google Play Billing, ni les abonnements historiques déjà enregistrés
-- (cas_pratique_subscriptions.stripe_price_id des transactions passées reste
-- inchangé — c'est un historique de facturation, pas une config active).
--
-- 1) admin_subscriptions_overview() comparait stripe_price_id à
--    current_setting('app.settings.stripe_price_year', true) — jamais
--    configurable sur Postgres managé Supabase (permission denied sur
--    ALTER DATABASE ... SET pour ce namespace custom), donc toujours NULL :
--    tout abonnement annuel s'affichait "month" dans le panel admin depuis
--    la création de cette fonction. Remplacé par une comparaison directe
--    au price_id annuel réel (le plan week garde son mécanisme existant,
--    hors périmètre de cette tâche).
-- 2) cp_business_prices / dashboard MRR-ARR (20260605140000_cas_pratique_
--    business_metrics.sql) : migration présente en local mais jamais
--    appliquée en prod (table inexistante) — feature non déployée, donc
--    hors périmètre ici, aucune action.

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
    case
      when s.stripe_price_id = current_setting('app.settings.stripe_price_week', true) then 'week'
      when s.stripe_price_id = 'price_1U5xdbBEMUz8FsmjDzMTSDGv' then 'year'
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
