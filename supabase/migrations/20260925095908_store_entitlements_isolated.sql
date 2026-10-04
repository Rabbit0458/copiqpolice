-- Native purchases are isolated from Stripe and manual grants.
-- Only verified server snapshots may write these tables.
create table public.store_entitlements (
  user_id uuid not null references auth.users(id) on delete cascade,
  environment text not null check (environment in ('PRODUCTION','SANDBOX')),
  product_id text not null,
  store text not null check (store in ('app_store','play_store')),
  plan text not null check (plan in ('month','year')),
  expires_at timestamptz not null,
  revoked boolean not null default false,
  cancel_at_period_end boolean not null default false,
  verified_at timestamptz not null,
  primary key (user_id, environment, product_id)
);
create table public.store_sync_events (
  event_id text primary key,
  event_type text not null,
  processed_at timestamptz not null default now()
);
create table public.store_sync_watermarks (
  user_id uuid primary key references auth.users(id) on delete cascade,
  verified_at timestamptz not null
);
alter table public.store_entitlements enable row level security;
alter table public.store_sync_events enable row level security;
alter table public.store_sync_watermarks enable row level security;
revoke all on public.store_entitlements, public.store_sync_events, public.store_sync_watermarks from public, anon, authenticated;
grant select on public.store_entitlements to authenticated;
grant all on public.store_entitlements, public.store_sync_events, public.store_sync_watermarks to service_role;
create policy store_entitlements_read on public.store_entitlements for select to authenticated
using ((select auth.uid()) = user_id or public.has_admin_role('owner','admin'));

-- One transaction replaces each verified customer's native snapshot and records
-- the event. A failed write rolls back the deduplication record as well.
create function public.apply_store_snapshot(p_event_id text,p_event_type text,p_snapshots jsonb)
returns jsonb language plpgsql security invoker set search_path = '' as $$
declare v_snapshot jsonb; v_row jsonb; v_uid uuid; v_verified timestamptz;
begin
  if current_user <> 'service_role' then
    raise exception 'service_role required' using errcode='42501';
  end if;
  if length(p_event_id) not between 1 and 255 or jsonb_typeof(p_snapshots) <> 'array' then
    raise exception 'Invalid snapshot';
  end if;
  insert into public.store_sync_events(event_id,event_type) values(p_event_id,p_event_type)
    on conflict do nothing;
  if not found then return jsonb_build_object('duplicate',true); end if;
  -- Consistent lock order also handles TRANSFER events affecting two accounts.
  for v_snapshot in select value from jsonb_array_elements(p_snapshots) order by value->>'user_id' loop
    v_uid := (v_snapshot->>'user_id')::uuid;
    v_verified := (v_snapshot->>'verified_at')::timestamptz;
    if v_verified is null or v_verified > now()+interval '5 minutes' then raise exception 'Invalid verification time'; end if;
    perform pg_advisory_xact_lock(hashtextextended(v_uid::text, 9417));
    if exists(select 1 from public.store_sync_watermarks where user_id=v_uid and verified_at > v_verified) then continue; end if;
    if jsonb_typeof(v_snapshot->'entitlements') <> 'array' then raise exception 'Invalid entitlement list'; end if;
    delete from public.store_entitlements where user_id=v_uid;
    for v_row in select value from jsonb_array_elements(v_snapshot->'entitlements') loop
      insert into public.store_entitlements(user_id,environment,product_id,store,plan,expires_at,revoked,cancel_at_period_end,verified_at)
      values(v_uid,v_row->>'environment',v_row->>'product_id',v_row->>'store',v_row->>'plan',
        (v_row->>'expires_at')::timestamptz,coalesce((v_row->>'revoked')::boolean,false),
        coalesce((v_row->>'cancel_at_period_end')::boolean,false),v_verified);
    end loop;
    insert into public.store_sync_watermarks values(v_uid,v_verified)
      on conflict(user_id) do update set verified_at=excluded.verified_at;
  end loop;
  return jsonb_build_object('duplicate',false);
end; $$;
revoke all on function public.apply_store_snapshot(text,text,jsonb) from public,anon,authenticated;
grant execute on function public.apply_store_snapshot(text,text,jsonb) to service_role;

-- Existing checks remain authoritative; native purchases only add a second
-- independently verified source. Sandbox never unlocks production server data.
create or replace function public.is_user_premium(p_user_id uuid)
returns boolean language plpgsql stable security definer set search_path='' as $$
begin
  if p_user_id is null then return false; end if;
  if (select auth.uid()) is distinct from p_user_id
     and coalesce(public.has_admin_role('owner','admin'),false) is not true then
    raise exception 'Accès refusé' using errcode='42501';
  end if;
  return exists(select 1 from public.cas_pratique_subscriptions s
    where s.user_id=p_user_id and s.tier in ('premium','premium_trial')
    and s.status in ('active','trialing') and (s.current_period_end is null or s.current_period_end>now()))
    or exists(select 1 from public.store_entitlements s
      where s.user_id=p_user_id and s.environment='PRODUCTION' and not s.revoked and s.expires_at>now());
end; $$;

-- Read model for the admin panel: paid native rights are visible only to
-- existing administrators; buying Premium never changes an admin role.
create function public.admin_store_billing_overview()
returns jsonb language plpgsql stable security invoker set search_path='' as $$
begin
  if not coalesce(public.has_admin_role('owner','admin'),false) or not public.admin_require_aal2() then
    raise exception 'Accès refusé' using errcode='42501';
  end if;
  return jsonb_build_object('refreshed_at',now(),'stores',coalesce((
    select jsonb_agg(to_jsonb(s)) from (
      select store,environment,count(*) subscriptions,
        count(*) filter(where not revoked and expires_at>now()) active,
        count(*) filter(where cancel_at_period_end and not revoked and expires_at>now()) cancelling,
        max(verified_at) last_verified_at
      from public.store_entitlements group by store,environment
    ) s),'[]'::jsonb));
end; $$;
revoke all on function public.admin_store_billing_overview() from public,anon;
grant execute on function public.admin_store_billing_overview() to authenticated;

-- Preserve the existing role/quota payload and enrich the plan from native
-- rights. No purchase ever changes user_profiles/admin_users.
create or replace function public.get_my_entitlement()
returns json language plpgsql stable security definer set search_path='' as $$
declare
 v_uid uuid:=auth.uid(); v_role text; v_plan text; v_status text;
 v_valid_until timestamptz; v_cancel boolean; v_used integer; v_resets timestamptz;
 v_quiz_count integer; v_native public.store_entitlements%rowtype;
begin
 if v_uid is null then return json_build_object('authenticated',false); end if;
 select coalesce((select case lower(a.role) when 'owner' then 'owner' when 'superadmin' then 'admin'
   when 'admin' then 'admin' when 'moderator' then 'moderator' else null end
   from public.admin_users a where a.auth_uid=v_uid and not a.disabled and (a.expires_at is null or a.expires_at>now())
   order by case lower(a.role) when 'owner' then 1 when 'superadmin' then 2 when 'admin' then 3 when 'moderator' then 4 else 5 end limit 1
 ),p.role::text,'user') into v_role from public.user_profiles p where p.user_id=v_uid;
 v_role:=coalesce(v_role,'user');
 select plan::text,status::text,valid_until,cancel_at_period_end into v_plan,v_status,v_valid_until,v_cancel
 from public.subscription_payement where user_id=v_uid order by updated_at desc limit 1;
 select * into v_native from public.store_entitlements where user_id=v_uid and environment='PRODUCTION'
   and not revoked and expires_at>now() order by expires_at desc limit 1;
 if found and (v_plan is null or v_plan='free' or v_valid_until is null or v_native.expires_at>v_valid_until) then
   v_plan:=v_native.plan; v_status:='active'; v_valid_until:=v_native.expires_at; v_cancel:=v_native.cancel_at_period_end;
 end if;
 select used,window_start+interval '7 days' into v_used,v_resets from public.free_weekly_usage where user_id=v_uid;
 v_quiz_count:=public.count_quiz_attempts(v_uid);
 return json_build_object('authenticated',true,'user_id',v_uid,'role',v_role,'is_owner',v_role='owner',
   'is_admin',v_role in ('owner','admin'),'premium',public.is_user_premium(v_uid),'plan',coalesce(v_plan,'free'),
   'status',coalesce(v_status,'active'),'valid_until',v_valid_until,'cancel_at_period_end',coalesce(v_cancel,false),
   'free_used',coalesce(v_used,0),'free_limit',10,'free_remaining',greatest(0,10-coalesce(v_used,0)),
   'free_resets_at',v_resets,'quiz_attempts_count',v_quiz_count,
   'badge_type',public.compute_badge_type(v_role::public.user_role,v_quiz_count));
end; $$;
