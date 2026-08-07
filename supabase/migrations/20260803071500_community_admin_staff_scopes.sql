-- Attribution atomique des périmètres de modération par le propriétaire.
-- Un compte ne peut ni modifier ses propres scopes ni recevoir un rôle
-- communautaire supérieur à son rôle dans le panel.

create or replace function public.community_admin_staff_scopes(p_admin_id uuid)
returns table(space_id text, space_label text, role text, expires_at timestamptz)
language plpgsql stable security definer set search_path = '' as $$
declare v_auth_uid uuid;
begin
  if not public.has_admin_role('owner') then raise exception 'Accès refusé' using errcode='42501'; end if;
  select a.auth_uid into v_auth_uid from public.admin_users a where a.id=p_admin_id;
  if v_auth_uid is null then return; end if;
  return query select s.space_id, coalesce(sp.label,s.space_id), s.role, s.expires_at
  from public.community_moderator_scopes s
  left join public.community_spaces sp on sp.id=s.space_id
  where s.user_id=v_auth_uid order by sp.sort_order nulls last,s.space_id;
end;
$$;

create or replace function public.community_admin_set_staff_scopes(
  p_admin_id uuid,
  p_scopes jsonb,
  p_reason text
) returns void language plpgsql security definer set search_path = '' as $$
declare
  v_actor uuid := (select auth.uid());
  v_target uuid;
  v_target_admin_role text;
  v_old jsonb;
  v_scope jsonb;
  v_space text;
  v_role text;
  v_expires timestamptz;
  v_max_rank integer;
  v_role_rank integer;
begin
  if not public.has_admin_role('owner') then raise exception 'Accès refusé' using errcode='42501'; end if;
  if char_length(trim(coalesce(p_reason,'')))<10 then raise exception 'Motif trop court' using errcode='22023'; end if;
  if p_scopes is null or jsonb_typeof(p_scopes)<>'array' or jsonb_array_length(p_scopes)>5 then raise exception 'Liste de scopes invalide' using errcode='22023'; end if;
  select a.auth_uid,lower(a.role) into v_target,v_target_admin_role from public.admin_users a where a.id=p_admin_id and not a.disabled;
  if v_target is null then raise exception 'Compte administrateur non lié ou désactivé' using errcode='22023'; end if;
  if v_target=v_actor then raise exception 'Modification de ses propres scopes interdite' using errcode='42501'; end if;
  if v_target_admin_role='owner' then raise exception 'Le scope propriétaire est géré par le système' using errcode='42501'; end if;
  v_max_rank := case v_target_admin_role when 'superadmin' then 3 when 'admin' then 3 when 'moderator' then 2 else 1 end;

  select coalesce(jsonb_agg(to_jsonb(s) order by s.space_id),'[]'::jsonb) into v_old
  from public.community_moderator_scopes s where s.user_id=v_target;

  for v_scope in select value from jsonb_array_elements(p_scopes)
  loop
    v_space := nullif(trim(v_scope->>'space_id'),'');
    v_role := nullif(trim(v_scope->>'role'),'');
    v_expires := case when nullif(v_scope->>'expires_at','') is null then null else (v_scope->>'expires_at')::timestamptz end;
    if v_space is null or not exists(select 1 from public.community_spaces s where s.id=v_space) then raise exception 'Espace invalide' using errcode='22023'; end if;
    if v_role not in ('helper','moderator','admin') then raise exception 'Rôle communautaire invalide' using errcode='22023'; end if;
    v_role_rank := case v_role when 'admin' then 3 when 'moderator' then 2 else 1 end;
    if v_role_rank>v_max_rank then raise exception 'Rôle supérieur au rôle panel' using errcode='42501'; end if;
    if v_expires is not null and v_expires<=now() then raise exception 'Expiration invalide' using errcode='22023'; end if;
  end loop;

  if (select count(*) from jsonb_array_elements(p_scopes)) <>
     (select count(distinct value->>'space_id') from jsonb_array_elements(p_scopes)) then
    raise exception 'Un seul rôle par espace' using errcode='22023';
  end if;

  delete from public.community_moderator_scopes where user_id=v_target;
  insert into public.community_moderator_scopes(user_id,space_id,role,granted_by,granted_at,expires_at)
  select v_target, value->>'space_id', value->>'role', v_actor, now(),
         case when nullif(value->>'expires_at','') is null then null else (value->>'expires_at')::timestamptz end
  from jsonb_array_elements(p_scopes);

  insert into public.community_moderation_log(actor_id,space_id,action,target_type,target_id,reason,old_state,new_state)
  values(v_actor,'global','set_staff_scopes','admin_staff',p_admin_id::text,trim(p_reason),v_old,p_scopes);
end;
$$;

revoke all on function public.community_admin_staff_scopes(uuid) from public,anon;
revoke all on function public.community_admin_set_staff_scopes(uuid,jsonb,text) from public,anon;
grant execute on function public.community_admin_staff_scopes(uuid) to authenticated;
grant execute on function public.community_admin_set_staff_scopes(uuid,jsonb,text) to authenticated;
