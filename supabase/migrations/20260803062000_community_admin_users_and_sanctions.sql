-- Administration communautaire centralisée des utilisateurs COP'IQ.
-- Les RPC sont SECURITY DEFINER mais revalident systématiquement le rôle,
-- la hiérarchie et le scope. Aucun contenu de message privé n'est exposé.

create or replace function public.community_admin_list_users(
  p_search text default null,
  p_track text default null,
  p_mode text default null,
  p_subscription text default null,
  p_sanctioned boolean default null,
  p_limit integer default 40,
  p_offset integer default 0
) returns table(
  user_id uuid,
  email text,
  username text,
  first_name text,
  last_name text,
  avatar_index integer,
  user_role text,
  user_track text,
  user_mode text,
  plan text,
  subscription_status text,
  current_period_end timestamptz,
  posts_count bigint,
  comments_count bigint,
  reports_received bigint,
  active_sanctions bigint,
  last_seen timestamptz,
  created_at timestamptz,
  total_count bigint
)
language plpgsql stable security definer set search_path = '' as $$
declare
  v_limit integer := least(greatest(coalesce(p_limit, 40), 1), 100);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
begin
  if not public.has_admin_role('owner','admin','moderator') then
    raise exception 'Accès refusé' using errcode = '42501';
  end if;
  if p_track is not null and p_track not in ('pa','gpx') then
    raise exception 'Parcours invalide' using errcode = '22023';
  end if;
  if p_mode is not null and p_mode not in ('exam','school') then
    raise exception 'Mode invalide' using errcode = '22023';
  end if;
  if p_subscription is not null and p_subscription not in ('premium','free') then
    raise exception 'Abonnement invalide' using errcode = '22023';
  end if;

  return query
  select
    u.user_id, u.email, u.username, u.first_name, u.last_name, u.avatar_index,
    u.role::text, u.user_track, u.user_mode,
    sub.plan, sub.status, sub.current_period_end,
    coalesce(activity.posts_count, 0),
    coalesce(activity.comments_count, 0),
    coalesce(activity.reports_received, 0),
    coalesce(activity.active_sanctions, 0),
    u.updated_at, u.created_at,
    count(*) over()
  from public.user_profiles u
  left join lateral (
    select b.plan, b.status, b.current_period_end
    from public.billing_subscriptions b
    where b.user_id = u.user_id
    order by b.updated_at desc limit 1
  ) sub on true
  left join lateral (
    select
      (select count(*) from public.community_posts p where p.author_id = u.user_id) as posts_count,
      (select count(*) from public.community_comments c where c.author_id = u.user_id) as comments_count,
      (select count(*) from public.community_reports r where r.subject_user_id = u.user_id) as reports_received,
      (select count(*) from public.community_sanctions s where s.user_id = u.user_id and s.status = 'active' and (s.ends_at is null or s.ends_at > now())) as active_sanctions
  ) activity on true
  where (
    nullif(trim(coalesce(p_search, '')), '') is null
    or u.email ilike '%' || trim(p_search) || '%'
    or u.username ilike '%' || trim(p_search) || '%'
    or concat_ws(' ', u.first_name, u.last_name) ilike '%' || trim(p_search) || '%'
    or u.user_id::text = trim(p_search)
  )
  and (p_track is null or u.user_track = p_track)
  and (p_mode is null or u.user_mode = p_mode)
  and (
    p_subscription is null
    or (p_subscription = 'premium' and sub.status in ('active','trialing'))
    or (p_subscription = 'free' and coalesce(sub.status, '') not in ('active','trialing'))
  )
  and (
    p_sanctioned is null
    or p_sanctioned = (coalesce(activity.active_sanctions, 0) > 0)
  )
  order by coalesce(activity.active_sanctions, 0) desc, u.created_at desc
  limit v_limit offset v_offset;
end;
$$;

create or replace function public.community_admin_user_detail(p_user_id uuid)
returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare v_result jsonb;
begin
  if not public.has_admin_role('owner','admin','moderator') then
    raise exception 'Accès refusé' using errcode = '42501';
  end if;
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  select jsonb_build_object(
    'profile', jsonb_build_object(
      'user_id', u.user_id, 'email', u.email, 'username', u.username,
      'first_name', u.first_name, 'last_name', u.last_name,
      'avatar_index', u.avatar_index, 'city', u.city,
      'user_role', u.role::text, 'user_track', u.user_track,
      'user_mode', u.user_mode, 'created_at', u.created_at,
      'updated_at', u.updated_at
    ),
    'subscription', coalesce((
      select to_jsonb(b) - 'stripe_customer_id' - 'stripe_subscription_id'
      from public.billing_subscriptions b where b.user_id = u.user_id
      order by b.updated_at desc limit 1
    ), '{}'::jsonb),
    'activity', jsonb_build_object(
      'posts', (select count(*) from public.community_posts p where p.author_id = u.user_id),
      'comments', (select count(*) from public.community_comments c where c.author_id = u.user_id),
      'messages', (select count(*) from public.community_messages m where m.sender_id = u.user_id),
      'reports_received', (select count(*) from public.community_reports r where r.subject_user_id = u.user_id),
      'reports_sent', (select count(*) from public.community_reports r where r.reporter_id = u.user_id)
    ),
    'sanctions', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', s.id, 'space_id', s.space_id, 'kind', s.kind,
        'reason', s.reason, 'starts_at', s.starts_at, 'ends_at', s.ends_at,
        'status', case when s.status = 'active' and s.ends_at is not null and s.ends_at <= now() then 'expired' else s.status end,
        'created_at', s.created_at, 'revoked_at', s.revoked_at,
        'imposed_by', s.imposed_by, 'revoked_by', s.revoked_by
      ) order by s.created_at desc)
      from public.community_sanctions s where s.user_id = u.user_id
    ), '[]'::jsonb)
  ) into v_result
  from public.user_profiles u where u.user_id = p_user_id;

  if v_result is null then raise exception 'Utilisateur introuvable' using errcode = 'P0002'; end if;
  return v_result;
end;
$$;

create or replace function public.community_admin_impose_sanction(
  p_user_id uuid,
  p_kind text,
  p_reason text,
  p_space_id text default 'global',
  p_ends_at timestamptz default null
) returns uuid language plpgsql security definer set search_path = '' as $$
declare
  v_actor uuid := (select auth.uid());
  v_id uuid;
  v_actor_role text := public.current_admin_role();
  v_target_role text;
  v_actor_rank integer;
  v_target_rank integer;
begin
  if not public.has_admin_role('owner','admin','moderator') then raise exception 'Accès refusé' using errcode = '42501'; end if;
  if p_user_id is null or p_user_id = v_actor then raise exception 'Auto-sanction interdite' using errcode = '42501'; end if;
  if p_kind not in ('warning','post_restriction','comment_restriction','message_restriction','suspension','ban') then raise exception 'Type de sanction invalide' using errcode = '22023'; end if;
  if char_length(trim(coalesce(p_reason, ''))) < 10 then raise exception 'Motif trop court' using errcode = '22023'; end if;
  if not exists(select 1 from public.community_spaces s where s.id = coalesce(p_space_id, 'global')) then raise exception 'Espace invalide' using errcode = '22023'; end if;
  if p_kind in ('post_restriction','comment_restriction','message_restriction','suspension') and (p_ends_at is null or p_ends_at <= now()) then raise exception 'Échéance future obligatoire' using errcode = '22023'; end if;
  if p_ends_at is not null and p_ends_at <= now() then raise exception 'Échéance invalide' using errcode = '22023'; end if;
  if not public.community_is_staff(coalesce(p_space_id, 'global')) then raise exception 'Scope insuffisant' using errcode = '42501'; end if;

  select a.role into v_target_role from public.admin_users a where a.auth_uid = p_user_id and not a.disabled limit 1;
  v_actor_rank := case v_actor_role when 'owner' then 4 when 'superadmin' then 3 when 'admin' then 2 when 'moderator' then 1 else 0 end;
  v_target_rank := case lower(coalesce(v_target_role, '')) when 'owner' then 4 when 'superadmin' then 3 when 'admin' then 2 when 'moderator' then 1 else 0 end;
  if v_target_rank >= v_actor_rank then raise exception 'Hiérarchie insuffisante' using errcode = '42501'; end if;

  insert into public.community_sanctions(user_id, space_id, imposed_by, kind, reason, ends_at, status)
  values(p_user_id, coalesce(p_space_id, 'global'), v_actor, p_kind, trim(p_reason), p_ends_at, 'active') returning id into v_id;
  insert into public.community_moderation_log(actor_id, space_id, action, target_type, target_id, reason, new_state)
  values(v_actor, coalesce(p_space_id, 'global'), 'impose_sanction', 'user', p_user_id::text, trim(p_reason), jsonb_build_object('sanction_id', v_id, 'kind', p_kind, 'ends_at', p_ends_at));
  return v_id;
end;
$$;

create or replace function public.community_admin_revoke_sanction(p_sanction_id uuid, p_reason text)
returns void language plpgsql security definer set search_path = '' as $$
declare v_actor uuid := (select auth.uid()); v_s public.community_sanctions%rowtype;
begin
  if not public.has_admin_role('owner','admin','moderator') then raise exception 'Accès refusé' using errcode = '42501'; end if;
  if char_length(trim(coalesce(p_reason, ''))) < 10 then raise exception 'Motif trop court' using errcode = '22023'; end if;
  select * into v_s from public.community_sanctions where id = p_sanction_id for update;
  if not found then raise exception 'Sanction introuvable' using errcode = 'P0002'; end if;
  if v_s.status <> 'active' then raise exception 'Sanction déjà clôturée' using errcode = '22023'; end if;
  if not public.community_is_staff(v_s.space_id) then raise exception 'Scope insuffisant' using errcode = '42501'; end if;
  update public.community_sanctions set status = 'revoked', revoked_at = now(), revoked_by = v_actor where id = p_sanction_id;
  insert into public.community_moderation_log(actor_id, space_id, action, target_type, target_id, reason, old_state, new_state)
  values(v_actor, v_s.space_id, 'revoke_sanction', 'sanction', p_sanction_id::text, trim(p_reason), to_jsonb(v_s), jsonb_build_object('status','revoked','revoked_at',now()));
end;
$$;

revoke all on function public.community_admin_list_users(text,text,text,text,boolean,integer,integer) from public, anon;
revoke all on function public.community_admin_user_detail(uuid) from public, anon;
revoke all on function public.community_admin_impose_sanction(uuid,text,text,text,timestamptz) from public, anon;
revoke all on function public.community_admin_revoke_sanction(uuid,text) from public, anon;
grant execute on function public.community_admin_list_users(text,text,text,text,boolean,integer,integer) to authenticated;
grant execute on function public.community_admin_user_detail(uuid) to authenticated;
grant execute on function public.community_admin_impose_sanction(uuid,text,text,text,timestamptz) to authenticated;
grant execute on function public.community_admin_revoke_sanction(uuid,text) to authenticated;

comment on function public.community_admin_user_detail(uuid) is 'Admin community profile without private message contents or Stripe identifiers.';
comment on function public.community_admin_impose_sanction(uuid,text,text,text,timestamptz) is 'Scoped and hierarchical sanction creation with mandatory audit trail.';
