-- Credits are granted only by the signature-verifying AdMob webhook.
create table public.rewarded_ssv_config (
  id boolean primary key default true check (id),
  enabled boolean not null default false
);
insert into public.rewarded_ssv_config(id,enabled) values(true,false);
alter table public.rewarded_ssv_config enable row level security;
revoke all on public.rewarded_ssv_config from public,anon,authenticated;
grant all on public.rewarded_ssv_config to service_role;

create table public.rewarded_ssv_challenges (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  ad_unit text not null check(ad_unit in ('3779020910','5012211534')),
  window_start timestamptz not null,
  created_at timestamptz not null default now(),
  expires_at timestamptz not null default now()+interval '30 minutes',
  granted_at timestamptz,
  transaction_id text unique
);
create index rewarded_ssv_user_created on public.rewarded_ssv_challenges(user_id,created_at);
alter table public.rewarded_ssv_challenges enable row level security;
revoke all on public.rewarded_ssv_challenges from public,anon,authenticated;
grant select on public.rewarded_ssv_challenges to authenticated;
grant all on public.rewarded_ssv_challenges to service_role;
create policy rewarded_ssv_own_status on public.rewarded_ssv_challenges
  for select to authenticated using(user_id=(select auth.uid()));

create function public.begin_rewarded_request(p_ad_unit text) returns jsonb
language plpgsql security definer set search_path='' as $$
declare v_uid uuid:=auth.uid(); v_id uuid; v_window timestamptz; v_unit text;
begin
  if v_uid is null then return jsonb_build_object('allowed',false); end if;
  if not exists(select 1 from public.rewarded_ssv_config where id and enabled)
    then return jsonb_build_object('allowed',false,'reason','verification_not_configured'); end if;
  if public.is_user_premium(v_uid) then return jsonb_build_object('allowed',false); end if;
  v_unit:=split_part(p_ad_unit,'/',2);
  if p_ad_unit not in ('ca-app-pub-5486022144325892/3779020910','ca-app-pub-5486022144325892/5012211534')
    then return jsonb_build_object('allowed',false,'reason','invalid_ad_unit'); end if;
  select window_start into v_window from public.free_weekly_usage
    where user_id=v_uid and used>=10 and window_start+interval '7 days'>now() for update;
  if not found then return jsonb_build_object('allowed',false,'reason','quota_not_exhausted'); end if;
  if exists(select 1 from public.rewarded_ssv_challenges where user_id=v_uid
    and created_at>now()-interval '30 seconds') then
    return jsonb_build_object('allowed',false,'reason','throttled');
  end if;
  insert into public.rewarded_ssv_challenges(user_id,ad_unit,window_start)
    values(v_uid,v_unit,v_window) returning id into v_id;
  return jsonb_build_object('allowed',true,'challenge_id',v_id);
end; $$;

CREATE OR REPLACE FUNCTION public.get_my_entitlement()
 RETURNS json
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
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
 select * into v_native from public.store_entitlements where user_id=v_uid and (environment='PRODUCTION' or (environment='SANDBOX' and exists(select 1 from public.store_sandbox_testers t where t.user_id=v_uid and t.expires_at>now())))
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
end; $function$
revoke all on function public.begin_rewarded_request(text) from public,anon;
grant execute on function public.begin_rewarded_request(text) to authenticated;

create function public.grant_verified_reward(p_challenge uuid,p_transaction text,p_ad_unit text)
returns jsonb language plpgsql security definer set search_path='' as $$
declare c public.rewarded_ssv_challenges%rowtype;
begin
  if p_transaction is null or length(p_transaction) not between 8 and 256 then
    raise exception 'Invalid transaction' using errcode='22023';
  end if;
  select * into c from public.rewarded_ssv_challenges where id=p_challenge for update;
  if not found or c.ad_unit<>p_ad_unit then return jsonb_build_object('allowed',false); end if;
  if c.granted_at is not null then
    return jsonb_build_object('allowed',c.transaction_id=p_transaction,'duplicate',true);
  end if;
  if c.expires_at<now() then return jsonb_build_object('allowed',false,'reason','expired'); end if;
  if exists(select 1 from public.rewarded_ssv_challenges where transaction_id=p_transaction) then
    return jsonb_build_object('allowed',false,'reason','duplicate_transaction');
  end if;
  update public.free_weekly_usage set used=greatest(0,used-1),updated_at=now()
    where user_id=c.user_id and window_start=c.window_start and window_start+interval '7 days'>now();
  if not found then return jsonb_build_object('allowed',false,'reason','window_changed'); end if;
  update public.rewarded_ssv_challenges set granted_at=now(),transaction_id=p_transaction where id=c.id;
  insert into public.rewarded_ad_grants(user_id,client_nonce)
    values(c.user_id,'ssv:'||p_transaction);
  return jsonb_build_object('allowed',true);
end; $$;
revoke all on function public.grant_verified_reward(uuid,text,text) from public,anon,authenticated;
grant execute on function public.grant_verified_reward(uuid,text,text) to service_role;
revoke execute on function public.grant_rewarded_request(text) from public,anon,authenticated;
revoke insert,update,delete on public.rewarded_ad_grants from anon,authenticated;

-- Sandbox rights require an expiring, server-managed allowlist, never user metadata.
create table public.store_sandbox_testers(
  user_id uuid primary key references auth.users(id) on delete cascade,
  expires_at timestamptz not null
);
alter table public.store_sandbox_testers enable row level security;
revoke all on public.store_sandbox_testers from public,anon,authenticated;
grant all on public.store_sandbox_testers to service_role;
insert into public.store_sandbox_testers(user_id,expires_at)
  select user_id,trial_ends_at from public.cas_pratique_subscriptions
  where 'app_store_review_manual_trial'=any(entitlements) and trial_ends_at>now();

create or replace function public.is_user_premium(p_user_id uuid)
returns boolean language plpgsql stable security definer set search_path='' as $$
begin
  if p_user_id is null then return false; end if;
  if (select auth.uid()) is distinct from p_user_id
     and coalesce(public.has_admin_role('owner','admin'),false) is not true then
    raise exception 'Access denied' using errcode='42501';
  end if;
  return exists(select 1 from public.cas_pratique_subscriptions s
    where s.user_id=p_user_id and s.tier in ('premium','premium_trial')
    and s.status in ('active','trialing') and (s.current_period_end is null or s.current_period_end>now()))
    or exists(select 1 from public.store_entitlements s
      where s.user_id=p_user_id and not s.revoked and s.expires_at>now()
      and (s.environment='PRODUCTION' or (s.environment='SANDBOX'
        and exists(select 1 from public.store_sandbox_testers t
          where t.user_id=p_user_id and t.expires_at>now()))));
end; $$;
