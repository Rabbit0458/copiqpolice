-- Build 10: enforce author/moderator boundaries independently of the clients.
create or replace function public.community_guard_author_write()
returns trigger language plpgsql security invoker set search_path = '' as $$
declare
  before_row jsonb; after_row jsonb := to_jsonb(new);
  allowed text[]; space text; kind text; author uuid; deleting boolean;
begin
  -- Only audited SECURITY DEFINER RPCs, internal counters and the backend bypass
  -- this client-write guard. RLS still controls which rows clients can reach.
  if current_user in ('postgres','service_role','supabase_admin') then return new; end if;
  if tg_table_name = 'community_posts' then
    author := new.author_id; space := new.space_id; kind := 'post';
    allowed := array['title','content','status','deleted_at','edited_at','updated_at'];
  elsif tg_table_name = 'community_comments' then
    author := new.author_id; kind := 'comment';
    select p.space_id into space from public.community_posts p where p.id=new.post_id;
    allowed := array['content','status','deleted_at','edited_at'];
  else
    author := new.sender_id; kind := 'message';
    select coalesce(r.space_id,'global') into space from public.community_rooms r where r.id=new.room_id;
    allowed := array['content','status','deleted_at','edited_at','attachment_path'];
  end if;
  if author is distinct from auth.uid() or auth.uid() is null then
    raise exception 'Modification reservee a son auteur; utiliser la moderation pour les autres contenus' using errcode='42501';
  end if;
  if tg_op='INSERT' then
    if new.status <> 'published' or new.deleted_at is not null
      or coalesce((after_row->>'is_pinned')::boolean,false)
      or coalesce((after_row->>'is_resolved')::boolean,false)
      or coalesce((after_row->>'is_solution')::boolean,false)
      or after_row->>'solution_comment_id' is not null
      or coalesce((after_row->>'reaction_count')::integer,0)<>0
      or coalesce((after_row->>'comment_count')::integer,0)<>0
      or coalesce((after_row->>'reply_count')::integer,0)<>0
      or coalesce((after_row->>'share_count')::integer,0)<>0
      or coalesce((after_row->>'view_count')::integer,0)<>0 then
      raise exception 'Etat initial de publication interdit' using errcode='42501';
    end if;
    new.created_at := now();
    return new;
  end if;
  before_row := to_jsonb(old);
  if (after_row - allowed) is distinct from (before_row - allowed) then
    raise exception 'Champs reserves au serveur ou a la moderation' using errcode='42501';
  end if;
  deleting := new.status='deleted_by_author';
  if deleting then
    -- Removal remains possible during a sanction, but cannot carry new content.
    if new.content is distinct from old.content and new.content not in ('[supprimé]','') then
      raise exception 'Suppression invalide' using errcode='42501';
    end if;
    if kind='post' and after_row->>'title' is distinct from before_row->>'title' then
      raise exception 'Suppression invalide' using errcode='42501';
    end if;
    if kind='message' and after_row->'attachment_path' is distinct from before_row->'attachment_path' and after_row->>'attachment_path' is not null then
      raise exception 'Suppression invalide' using errcode='42501';
    end if;
    new.deleted_at := coalesce(old.deleted_at,now());
    return new;
  end if;
  if old.status <> 'published' or new.status <> 'published'
    or new.deleted_at is distinct from old.deleted_at then
    raise exception 'Seule la moderation peut restaurer ou changer cet etat' using errcode='42501';
  end if;
  if kind='message' and after_row->'attachment_path' is distinct from before_row->'attachment_path' then
    raise exception 'Piece jointe non modifiable' using errcode='42501';
  end if;
  if exists(select 1 from public.community_sanctions s where s.user_id=auth.uid()
    and s.status='active' and (s.space_id is null or s.space_id in ('global',space))
    and (s.ends_at is null or s.ends_at>now())
    and (s.kind in ('suspension','ban') or s.kind=kind||'_restriction')) then
    raise exception 'Modification interdite pendant cette sanction' using errcode='42501';
  end if;
  new.edited_at := now();
  return new;
end $$;
revoke all on function public.community_guard_author_write() from public,anon,authenticated;
create trigger community_author_write_guard before insert or update on public.community_posts
for each row execute function public.community_guard_author_write();
create trigger community_author_write_guard before insert or update on public.community_comments
for each row execute function public.community_guard_author_write();
create trigger community_author_write_guard before insert or update on public.community_messages
for each row execute function public.community_guard_author_write();

-- Serialize founder changes so two concurrent removals cannot remove both owners.
create or replace function public.guard_founder_account()
returns trigger language plpgsql security definer set search_path='' as $$
declare old_row jsonb := to_jsonb(old); new_row jsonb := to_jsonb(new);
  sensitive boolean; removing boolean; remaining integer; actor_owner boolean;
begin
  if lower(coalesce(old_row->>'role','')) <> 'owner' then
    if tg_op='DELETE' then return old; else return new; end if;
  end if;
  sensitive := tg_op='DELETE' or (old_row->'role' is distinct from new_row->'role');
  if tg_table_name='admin_users' then
    sensitive := sensitive or (old_row - array['updated_at','last_admin_login_at','last_admin_login_ip','failed_admin_code_attempts','locked_until'])
      is distinct from (new_row - array['updated_at','last_admin_login_at','last_admin_login_ip','failed_admin_code_attempts','locked_until']);
  else
    sensitive := sensitive or old_row->'user_id' is distinct from new_row->'user_id';
  end if;
  if not sensitive then return new; end if;
  perform pg_advisory_xact_lock(101083301,10);
  actor_owner := coalesce(public.has_admin_role('owner'),false) or exists(
    select 1 from public.user_profiles where user_id=auth.uid() and role::text='owner');
  if auth.uid() is not null and not actor_owner then
    raise exception 'Seul un fondateur peut modifier un fondateur' using errcode='42501';
  end if;
  removing := tg_op='DELETE' or new_row->>'role' is distinct from 'owner';
  if tg_table_name='admin_users' then
    removing := removing or coalesce((new_row->>'disabled')::boolean,false)
      or new_row->>'auth_uid' is distinct from old_row->>'auth_uid'
      or new_row->>'expires_at' is not null;
    select count(*) into remaining from public.admin_users a
      where a.id<>(old_row->>'id')::uuid and lower(a.role)='owner' and not a.disabled
      and a.auth_uid is not null and a.expires_at is null;
  else
    removing := removing or new_row->>'user_id' is distinct from old_row->>'user_id';
    select count(*) into remaining from public.user_profiles p
      where p.user_id<>(old_row->>'user_id')::uuid and p.role::text='owner';
  end if;
  if removing and remaining=0 then
    raise exception 'Le dernier fondateur doit etre conserve' using errcode='42501';
  end if;
  if tg_op='DELETE' then return old; else return new; end if;
end $$;
revoke all on function public.guard_founder_account() from public,anon,authenticated;
create trigger guard_founder_account before update or delete on public.user_profiles
for each row execute function public.guard_founder_account();
create trigger guard_founder_account before update or delete on public.admin_users
for each row execute function public.guard_founder_account();
revoke insert,update,delete,truncate,references,trigger on public.admin_users from public,anon,authenticated;

create or replace function public.has_admin_permission(p_perm text)
returns boolean language plpgsql stable security definer set search_path='' as $$
declare a public.admin_users;
begin
  a := public.current_admin();
  if a.id is null then return false; end if;
  if lower(a.role)='owner' then return true; end if;
  if p_perm in ('subscriptions','subscriptions.read','subscriptions.write') then return false; end if;
  if lower(a.role)='moderator' then return p_perm in ('forum.read','forum.moderate'); end if;
  if p_perm in ('forum.read','forum.moderate') then
    return lower(a.role)='admin' and coalesce((a.permissions->>'reports.manage')::boolean,false);
  end if;
  return coalesce((a.permissions->>p_perm)::boolean,false);
end $$;

-- Keep the existing RPC implementations/signatures; narrow their entry guards.
do $$
declare f record; definition text;
begin
  for f in select oid,proname from pg_proc where pronamespace='public'::regnamespace
    and proname in ('admin_subscriptions_overview','admin_grant_access','admin_revoke_access','community_admin_user_billing') loop
    definition := pg_get_functiondef(f.oid);
    definition := replace(definition, 'public.has_admin_role(''owner'',''admin'',''moderator'')','public.has_admin_role(''owner'')');
    definition := replace(definition, 'public.has_admin_role(''owner'',''admin'')','public.has_admin_role(''owner'')');
    execute definition;
  end loop;
  for f in select oid,proname from pg_proc where pronamespace='public'::regnamespace
    and proname in ('admin_dashboard_stats_fast','admin_dashboard_stats_live','admin_dashboard_stats_v2',
      'admin_refresh_dashboard_stats','admin_search_auth_users','admin_search_auth_users_v2',
      'admin_user_full','admin_user_profile_full','admin_users_overview',
      'community_admin_user_quiz','community_admin_user_quiz_summary') loop
    definition := pg_get_functiondef(f.oid);
    definition := replace(definition, '''owner'',''admin'',''moderator'',''helper''','''owner'',''admin'',''helper''');
    definition := replace(definition, '''owner'',''admin'',''moderator''','''owner'',''admin''');
    execute definition;
  end loop;
end $$;

-- The legacy billing writer is not needed by the public app or this panel.
revoke execute on function public.set_user_subscription(uuid,text,text,timestamptz,text,text,text,boolean) from public,anon,authenticated;
revoke insert,update,delete,truncate,references,trigger on public.subscription_payement from public,anon,authenticated;
drop policy if exists "Admins can manage subscription_payement" on public.subscription_payement;
drop policy if exists "Admins manage subscription_payement" on public.subscription_payement;
drop policy if exists sp_select_self on public.subscription_payement;
create policy subscription_founder_read on public.subscription_payement for select to authenticated
using (user_id=(select auth.uid()) or public.has_admin_role('owner'));
drop policy store_entitlements_read on public.store_entitlements;
create policy store_entitlements_read on public.store_entitlements for select to authenticated
using (user_id=(select auth.uid()) or public.has_admin_role('owner'));

-- A gift cannot overwrite a Stripe subscription; store purchases are separate.
do $$
declare f record; definition text;
begin
  for f in select oid from pg_proc where pronamespace='public'::regnamespace
    and proname in ('admin_grant_access','admin_revoke_access') loop
    definition := pg_get_functiondef(f.oid);
    definition := replace(definition, 'begin', E'begin\n  perform public.community_admin_owner_guard();\n  if exists(select 1 from public.cas_pratique_subscriptions where user_id=p_user_id and stripe_subscription_id is not null) then\n    raise exception ''Abonnement Stripe gere par son prestataire, pas par un cadeau manuel'' using errcode=''42501'';\n  end if;');
    execute definition;
  end loop;
end $$;

create or replace function public.admin_subscription_sources(p_search text default null,p_filter text default null,p_limit integer default 50,p_offset integer default 0)
returns jsonb language plpgsql stable security definer set search_path='' as $$
declare result jsonb;
begin
  perform public.community_admin_owner_guard();
  with users as (
    select u.user_id,u.email,u.first_name,u.last_name,u.username,u.created_at,
      public.is_user_premium(u.user_id) is_premium,
      coalesce(s.tier in ('premium','premium_trial') and s.status in ('active','trialing')
        and (s.current_period_end is null or s.current_period_end>now()) and s.stripe_subscription_id is null,false) manual_active,
      coalesce((select jsonb_agg(jsonb_build_object(
        'source',e.store,'environment',e.environment,'plan',e.plan,'product_id',e.product_id,
        'expires_at',e.expires_at,'verified_at',e.verified_at,'cancel_at_period_end',e.cancel_at_period_end,
        'status',case when e.revoked then 'revoked' when e.expires_at<=now() then 'expired' else 'active' end,
        'grants_access',not e.revoked and e.expires_at>now() and (e.environment='PRODUCTION' or exists(
          select 1 from public.store_sandbox_testers t where t.user_id=e.user_id and t.expires_at>now()))
      ) order by e.environment,e.store) from public.store_entitlements e where e.user_id=u.user_id),'[]'::jsonb)
      || case when s.user_id is null then '[]'::jsonb else jsonb_build_array(jsonb_build_object(
        'source',case when s.stripe_subscription_id is null then 'MANUAL' else 'STRIPE' end,
        'environment','PRODUCTION','plan',s.tier,'status',s.status,'expires_at',s.current_period_end,
        'verified_at',s.updated_at,'cancel_at_period_end',s.cancel_at_period_end,
        'grants_access',s.tier in ('premium','premium_trial') and s.status in ('active','trialing')
          and (s.current_period_end is null or s.current_period_end>now()))) end sources
    from public.user_profiles u left join public.cas_pratique_subscriptions s on s.user_id=u.user_id
    where nullif(trim(p_search),'') is null or u.email ilike '%'||trim(p_search)||'%'
      or u.username ilike '%'||trim(p_search)||'%' or u.user_id::text=trim(p_search)
      or concat_ws(' ',u.first_name,u.last_name) ilike '%'||trim(p_search)||'%'
  ), filtered as (
    select * from users where coalesce(p_filter,'')='' or (p_filter='paid' and is_premium)
      or (p_filter='free' and not is_premium)
      or (p_filter='expired' and not is_premium and jsonb_array_length(sources)>0)
      or (p_filter='trial' and exists(select 1 from jsonb_array_elements(sources) x where x->>'status'='trialing'))
    order by created_at desc,user_id limit least(greatest(coalesce(p_limit,50),1),200) offset greatest(coalesce(p_offset,0),0)
  ) select coalesce(jsonb_agg(to_jsonb(filtered)),'[]'::jsonb) into result from filtered;
  return result;
end $$;
revoke all on function public.admin_subscription_sources(text,text,integer,integer) from public,anon;
grant execute on function public.admin_subscription_sources(text,text,integer,integer) to authenticated;

-- Legacy administrative helpers must not equate forum moderators with admins.
do $$
declare f record; definition text;
begin
  for f in select oid from pg_proc where pronamespace='public'::regnamespace
    and proname in ('is_admin','is_elevated','admin_total_users') loop
    definition := pg_get_functiondef(f.oid);
    definition := replace(definition, ',''moderator''','');
    execute definition;
  end loop;
  for f in select oid from pg_proc where pronamespace='public'::regnamespace
    and proname in ('community_admin_user_auth','community_admin_user_badges','community_admin_user_cgv_status',
      'community_admin_user_content_reports','community_admin_user_detail','community_admin_user_devices',
      'community_admin_user_notifications','community_admin_user_photolangage','community_admin_user_placement',
      'community_admin_user_timeline','community_admin_log_user_export') loop
    definition := pg_get_functiondef(f.oid);
    definition := replace(definition, 'perform public.community_admin_guard();',
      'if not public.has_admin_role(''owner'',''admin'') then raise exception ''Acces refuse'' using errcode=''42501''; end if;');
    definition := replace(definition, '''owner'',''admin'',''moderator''','''owner'',''admin''');
    execute definition;
  end loop;
end $$;
