-- ============================================================================
--  COP'IQ — Dossier administrateur : Phase D — journalisation de l'export User 360
--  ---------------------------------------------------------------------------
--  L'export lui-même est assemblé côté client (agrégation des RPC déjà
--  disponibles, site exporté statique). Cette fonction ne fait que
--  journaliser l'action dans admin_audit_logs, avec l'acteur réel
--  (public.current_admin()), pour rester auditable.
-- ============================================================================

create or replace function public.community_admin_log_user_export(p_user_id uuid)
returns void language plpgsql volatile security definer set search_path = '' as $$
declare
  v_actor public.admin_users;
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  select * into v_actor from public.current_admin();

  insert into public.admin_audit_logs
    (actor_admin_id, actor_auth_uid, actor_email, actor_role,
     action, severity, success, target_table, target_id, target_user_id, comment)
  values
    (v_actor.id, v_actor.auth_uid, v_actor.email, v_actor.role,
     'user.export_360', 'warning', true, 'user_profiles', p_user_id::text, p_user_id,
     'Export complet du dossier utilisateur (User 360) depuis le panel admin');
end;
$$;

comment on function public.community_admin_log_user_export(uuid) is
  'Journalise un export User 360 dans admin_audit_logs. N''assemble aucune donnée : l''export se fait côté client.';

revoke all on function public.community_admin_log_user_export(uuid) from public, anon;
grant execute on function public.community_admin_log_user_export(uuid) to authenticated;
