-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Business metrics (MRR / ARR / churn / cohorts)
--  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-088
--
--  Vues SQL pour le dashboard admin :
--   • cp_business_active_subs           → tableau de bord temps réel
--   • cp_business_mrr_arr               → MRR / ARR / nouvel MRR du mois
--   • cp_business_monthly_revenue       → revenu mensuel (12 derniers mois)
--   • cp_business_churn                 → taux de churn mensuel
--   • cp_business_cohorts               → cohortes de rétention par mois d'inscription
--
--  Hypothèse de prix (à ajuster selon Stripe products) :
--   • monthly_eur : 9.99
--   • yearly_eur  : 79.00 (équiv ~6.58/mois)
--   • lifetime_eur: 149.00 (one-shot, exclu de MRR/ARR)
-- ════════════════════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────────────────────────
--  Table de mapping price_id → tarif (configurable par admin Phase R)
-- ─────────────────────────────────────────────────────────────────────────────

create table if not exists public.cp_business_prices (
  stripe_price_id   text primary key,
  label             text not null,         -- "Mensuel" / "Annuel" / "Lifetime"
  interval_kind     text not null check (interval_kind in ('month','year','one_time')),
  amount_eur        numeric(10,2) not null,
  is_lifetime       boolean not null default false,
  created_at        timestamptz not null default now()
);

comment on table public.cp_business_prices is
  'Mapping price_id → label + interval + montant. À synchroniser avec les Stripe Products.';

insert into public.cp_business_prices (stripe_price_id, label, interval_kind, amount_eur, is_lifetime)
values
  ('price_monthly_placeholder',  'Mensuel',  'month',    9.99,  false),
  ('price_yearly_placeholder',   'Annuel',   'year',    79.00,  false),
  ('price_lifetime_placeholder', 'Lifetime', 'one_time',149.00, true)
on conflict (stripe_price_id) do nothing;

-- ─────────────────────────────────────────────────────────────────────────────
--  VUE : abonnements actifs (snapshot temps réel)
-- ─────────────────────────────────────────────────────────────────────────────

create or replace view public.cp_business_active_subs as
  select
    s.user_id,
    s.tier,
    s.status,
    s.stripe_price_id,
    p.label as plan_label,
    p.interval_kind,
    p.amount_eur,
    p.is_lifetime,
    s.current_period_start,
    s.current_period_end,
    s.trial_ends_at,
    s.cancel_at_period_end,
    s.created_at,
    s.updated_at
  from public.cas_pratique_subscriptions s
  left join public.cp_business_prices p on p.stripe_price_id = s.stripe_price_id
  where s.status in ('active', 'trialing');

-- ─────────────────────────────────────────────────────────────────────────────
--  VUE : MRR / ARR (excluant les lifetime)
-- ─────────────────────────────────────────────────────────────────────────────

create or replace view public.cp_business_mrr_arr as
  with normalized as (
    select
      case
        when interval_kind = 'month' then amount_eur
        when interval_kind = 'year'  then amount_eur / 12.0
        else 0
      end as mrr_contribution
    from public.cp_business_active_subs
    where not is_lifetime
  )
  select
    coalesce(sum(mrr_contribution), 0)::numeric(12,2)   as mrr_eur,
    coalesce(sum(mrr_contribution) * 12, 0)::numeric(12,2) as arr_eur,
    count(*) as active_paying_users,
    now() as snapshot_at;

-- ─────────────────────────────────────────────────────────────────────────────
--  VUE : revenu mensuel (12 derniers mois)
--  Calculé à partir des period_end / period_start des subscriptions
-- ─────────────────────────────────────────────────────────────────────────────

create or replace view public.cp_business_monthly_revenue as
  with months as (
    select generate_series(
      date_trunc('month', now()) - interval '11 months',
      date_trunc('month', now()),
      '1 month'::interval
    ) as month_start
  ),
  monthly as (
    select
      m.month_start,
      coalesce(sum(
        case
          when s.interval_kind = 'month'
               and s.current_period_start <= m.month_start + interval '1 month'
               and s.current_period_end   >= m.month_start
            then s.amount_eur
          when s.interval_kind = 'year'
               and s.current_period_start <= m.month_start + interval '1 month'
               and s.current_period_end   >= m.month_start
            then s.amount_eur / 12.0
          when s.is_lifetime
               and s.created_at >= m.month_start
               and s.created_at <  m.month_start + interval '1 month'
            then s.amount_eur
          else 0
        end
      ), 0)::numeric(12,2) as revenue_eur,
      count(distinct case when s.created_at >= m.month_start
                          and s.created_at <  m.month_start + interval '1 month'
                          then s.user_id end) as new_subs_count
    from months m
    left join public.cp_business_active_subs s on true
    group by m.month_start
  )
  select month_start, revenue_eur, new_subs_count
  from monthly
  order by month_start;

-- ─────────────────────────────────────────────────────────────────────────────
--  VUE : churn mensuel
-- ─────────────────────────────────────────────────────────────────────────────

create or replace view public.cp_business_churn as
  with last_30d as (
    select
      count(*) filter (
        where canceled_at >= now() - interval '30 days'
      ) as churned_30d,
      count(*) filter (
        where status in ('active', 'trialing')
          and (canceled_at is null or canceled_at < now() - interval '30 days')
      ) as active_30d_ago
    from public.cas_pratique_subscriptions
    where stripe_subscription_id is not null
  )
  select
    churned_30d,
    active_30d_ago,
    case when active_30d_ago > 0
         then round((churned_30d::numeric / active_30d_ago) * 100, 2)
         else 0
    end as churn_rate_pct,
    now() as snapshot_at
  from last_30d;

-- ─────────────────────────────────────────────────────────────────────────────
--  VUE : cohortes par mois d'inscription
-- ─────────────────────────────────────────────────────────────────────────────

create or replace view public.cp_business_cohorts as
  select
    date_trunc('month', created_at) as cohort_month,
    count(*) as users_in_cohort,
    count(*) filter (
      where tier in ('premium', 'premium_trial')
        and status in ('active', 'trialing')
    ) as still_paying,
    case
      when count(*) > 0 then round(
        (count(*) filter (
          where tier in ('premium', 'premium_trial')
            and status in ('active', 'trialing')
        )::numeric / count(*)) * 100, 2)
      else 0
    end as retention_pct
  from public.cas_pratique_subscriptions
  group by date_trunc('month', created_at)
  order by cohort_month desc
  limit 12;

-- ─────────────────────────────────────────────────────────────────────────────
--  GRANTS : ces vues sont LECTURE service_role uniquement (admin)
-- ─────────────────────────────────────────────────────────────────────────────

revoke all on public.cp_business_active_subs        from anon, authenticated;
revoke all on public.cp_business_mrr_arr            from anon, authenticated;
revoke all on public.cp_business_monthly_revenue    from anon, authenticated;
revoke all on public.cp_business_churn              from anon, authenticated;
revoke all on public.cp_business_cohorts            from anon, authenticated;
revoke all on public.cp_business_prices             from anon, authenticated;

grant select on public.cp_business_active_subs     to service_role;
grant select on public.cp_business_mrr_arr         to service_role;
grant select on public.cp_business_monthly_revenue to service_role;
grant select on public.cp_business_churn           to service_role;
grant select on public.cp_business_cohorts         to service_role;
grant select on public.cp_business_prices          to service_role;

-- ─────────────────────────────────────────────────────────────────────────────
--  Trigger : notification Slack à chaque nouveau premium
--  → on stocke juste l'event dans une queue, l'edge fn cron envoie à Slack
-- ─────────────────────────────────────────────────────────────────────────────

create table if not exists public.cp_business_events_queue (
  id              uuid primary key default uuid_generate_v4(),
  event_kind      text not null,   -- 'new_subscription' | 'churned' | 'past_due' | ...
  user_id         uuid,
  payload         jsonb default '{}'::jsonb,
  created_at      timestamptz not null default now(),
  processed_at    timestamptz,
  notify_slack    boolean not null default true
);

create index if not exists idx_cp_events_unprocessed
  on public.cp_business_events_queue(created_at)
  where processed_at is null;

create or replace function public.cp_business_track_sub_event()
returns trigger
language plpgsql
as $$
begin
  -- New subscription (tier goes from free → premium/premium_trial)
  if (TG_OP = 'INSERT' and new.tier in ('premium', 'premium_trial'))
     or (TG_OP = 'UPDATE'
         and new.tier in ('premium', 'premium_trial')
         and (old.tier is null or old.tier = 'free')) then
    insert into public.cp_business_events_queue (event_kind, user_id, payload)
    values (
      'new_subscription',
      new.user_id,
      jsonb_build_object(
        'tier', new.tier,
        'stripe_price_id', new.stripe_price_id,
        'started_at', now()
      )
    );
  end if;

  -- Churned : status passe à canceled
  if TG_OP = 'UPDATE'
     and old.status not in ('canceled', 'unpaid')
     and new.status in ('canceled', 'unpaid') then
    insert into public.cp_business_events_queue (event_kind, user_id, payload)
    values (
      'churned',
      new.user_id,
      jsonb_build_object(
        'previous_tier', old.tier,
        'status', new.status,
        'canceled_at', new.canceled_at
      )
    );
  end if;

  return new;
end;
$$;

drop trigger if exists trg_cp_business_track_sub
  on public.cas_pratique_subscriptions;
create trigger trg_cp_business_track_sub
  after insert or update on public.cas_pratique_subscriptions
  for each row execute function public.cp_business_track_sub_event();

revoke all on public.cp_business_events_queue from anon, authenticated;
grant select, update on public.cp_business_events_queue to service_role;
