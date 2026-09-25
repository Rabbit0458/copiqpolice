-- COP'IQ — Répertoire admin : dernière plateforme connue de chaque compte.
-- Priorité au registre push user_devices, puis au dernier app_log exploitable.

drop function if exists public.community_admin_list_users(text,text,text,text,boolean,integer,integer);

create function public.community_admin_list_users(
  p_search text default null, p_track text default null, p_mode text default null,
  p_subscription text default null, p_sanctioned boolean default null,
  p_limit integer default 40, p_offset integer default 0
) returns table(
  user_id uuid, email text, username text, first_name text, last_name text,
  avatar_index integer, user_role text, user_track text, user_mode text,
  platform text, plan text, subscription_status text,
  current_period_end timestamptz, posts_count bigint, comments_count bigint,
  reports_received bigint, active_sanctions bigint, last_seen timestamptz,
  created_at timestamptz, total_count bigint
) language plpgsql stable security definer set search_path='' as $$
declare
  v_limit integer := least(greatest(coalesce(p_limit,40),1),100);
  v_offset integer := greatest(coalesce(p_offset,0),0);
begin
  if not public.has_admin_role('owner','admin','moderator') then raise exception 'Accès refusé' using errcode='42501'; end if;
  if p_track is not null and p_track not in ('pa','gpx') then raise exception 'Parcours invalide' using errcode='22023'; end if;
  if p_mode is not null and p_mode not in ('exam','school') then raise exception 'Mode invalide' using errcode='22023'; end if;
  if p_subscription is not null and p_subscription not in ('premium','free') then raise exception 'Abonnement invalide' using errcode='22023'; end if;

  return query
  select u.user_id,u.email,u.username,u.first_name,u.last_name,u.avatar_index,
    u.role::text,u.user_track,u.user_mode,device.platform,
    sub.plan,sub.status,sub.current_period_end,
    coalesce(activity.posts_count,0),coalesce(activity.comments_count,0),
    coalesce(activity.reports_received,0),coalesce(activity.active_sanctions,0),
    coalesce(device.seen_at,u.updated_at),u.created_at,count(*) over()
  from public.user_profiles u
  left join lateral (
    select lower(d.platform) platform,d.updated_at seen_at from public.user_devices d
    where d.user_id=u.user_id and lower(d.platform) in ('ios','android','web')
    order by d.updated_at desc limit 1
  ) registered_device on true
  left join lateral (
    select coalesce(registered_device.platform,lower(l.platform)) platform,
      coalesce(registered_device.seen_at,l.created_at) seen_at
    from (select 1) seed
    left join lateral (
      select a.platform,a.created_at from public.app_logs a
      where a.user_id=u.user_id and lower(a.platform) in ('ios','android','web')
      order by a.created_at desc limit 1
    ) l on registered_device.platform is null
  ) device on true
  left join lateral (
    select b.plan,b.status,b.current_period_end from public.billing_subscriptions b
    where b.user_id=u.user_id order by b.updated_at desc limit 1
  ) sub on true
  left join lateral (
    select
      (select count(*) from public.community_posts p where p.author_id=u.user_id) posts_count,
      (select count(*) from public.community_comments c where c.author_id=u.user_id) comments_count,
      (select count(*) from public.community_reports r where r.subject_user_id=u.user_id) reports_received,
      (select count(*) from public.community_sanctions s where s.user_id=u.user_id and s.status='active' and (s.ends_at is null or s.ends_at>now())) active_sanctions
  ) activity on true
  where (nullif(trim(coalesce(p_search,'')),'') is null
    or u.email ilike '%'||trim(p_search)||'%' or u.username ilike '%'||trim(p_search)||'%'
    or concat_ws(' ',u.first_name,u.last_name) ilike '%'||trim(p_search)||'%'
    or u.user_id::text=trim(p_search))
    and (p_track is null or u.user_track=p_track)
    and (p_mode is null or u.user_mode=p_mode)
    and (p_subscription is null
      or (p_subscription='premium' and sub.status in ('active','trialing'))
      or (p_subscription='free' and coalesce(sub.status,'') not in ('active','trialing')))
    and (p_sanctioned is null or p_sanctioned=(coalesce(activity.active_sanctions,0)>0))
  order by coalesce(activity.active_sanctions,0) desc,u.created_at desc
  limit v_limit offset v_offset;
end;
$$;

revoke all on function public.community_admin_list_users(text,text,text,text,boolean,integer,integer) from public,anon;
grant execute on function public.community_admin_list_users(text,text,text,text,boolean,integer,integer) to authenticated;
comment on function public.community_admin_list_users(text,text,text,text,boolean,integer,integer) is
  'Répertoire admin avec dernière plateforme iOS/Android/Web connue via user_devices puis app_logs.';
