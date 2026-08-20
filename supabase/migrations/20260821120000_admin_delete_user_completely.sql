-- ============================================================================
--  COP'IQ — Phase E : suppression complète d'un compte par un administrateur
--  ---------------------------------------------------------------------------
--  CONTEXTE — trouvé en auditant la base avant d'écrire cette migration :
--    • Aucune contrainte FOREIGN KEY n'existe entre les tables public.* et
--      auth.users(id) (vérifié via information_schema.referential_constraints).
--    • Le mécanisme RGPD existant (fn_cp_delete_user_data, edge function
--      cas_pratique_delete_user_data) ne supprime QUE le domaine cas_pratique_*.
--    • Un simple auth.admin.deleteUser() ne supprime donc que la ligne
--      auth.users et laisse orphelines toutes les autres données (community_*,
--      quiz_*, billing_*, notifications, tests psychotechniques, photolangage,
--      placement, etc.) — suppression RGPD Art. 17 incomplète en pratique.
--
--  Cette fonction corrige ce point : elle réutilise la même découverte
--  dynamique que le scanner de la Phase C (mêmes conventions de nommage,
--  aucune liste figée) pour supprimer les lignes de TOUTES les tables
--  réellement liées à l'utilisateur, dans un ordre déterminé automatiquement
--  par essais successifs (les tables bloquées par une contrainte FK interne
--  sont réessayées au tour suivant, jusqu'à stabilisation).
--
--  Elle NE TOUCHE PAS à auth.users : la suppression du compte Auth reste à
--  la charge de l'edge function appelante, via auth.admin.deleteUser()
--  (API officielle GoTrue), pour rester cohérente avec le mécanisme RGPD
--  existant et ne jamais manipuler le schéma auth en SQL brut.
--
--  SÉCURITÉ :
--    • Owner only (community_admin_owner_guard).
--    • Confirmation obligatoire : l'email exact du compte cible doit être
--      fourni en paramètre.
--    • Refuse de supprimer un compte qui est lui-même un administrateur
--      (présent dans admin_users) — protection anti-sabotage.
--    • Journalise l'action AVANT suppression (severity=critical), avec
--      l'acteur réel (public.current_admin()).
-- ============================================================================

create or replace function public.admin_delete_user_data_completely(
  p_user_id uuid,
  p_confirm_email text
) returns jsonb
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_email    text;
  v_is_staff boolean;
  v_actor    public.admin_users;
  v_report   jsonb := '{}'::jsonb;
  v_pass     integer := 0;
  v_progress boolean;
  v_row      record;
  v_count    bigint;
  v_uuid_columns text[] := array[
    'user_id','author_id','sender_id','recipient_id','reporter_id',
    'subject_user_id','actor_id','imposed_by','revoked_by','target_user_id',
    'resolved_by','uid','moderator_id','admin_id','auth_uid'
  ];
begin
  perform public.community_admin_owner_guard();
  if p_user_id is null then
    raise exception 'Utilisateur obligatoire' using errcode = '22023';
  end if;

  select email into v_email from public.user_profiles where user_id = p_user_id;
  if v_email is null then
    raise exception 'Utilisateur introuvable' using errcode = 'P0002';
  end if;
  if p_confirm_email is null or lower(trim(p_confirm_email)) <> lower(v_email) then
    raise exception 'La confirmation ne correspond pas à l''email du compte' using errcode = '22023';
  end if;

  select exists(select 1 from public.admin_users a where a.auth_uid = p_user_id)
    into v_is_staff;
  if v_is_staff then
    raise exception 'Impossible de supprimer un compte administrateur depuis cette fonction'
      using errcode = '42501';
  end if;

  select * into v_actor from public.current_admin();

  -- Journal AVANT suppression : target_user_id doit être capturé pendant
  -- qu'il existe encore, admin_audit_logs est explicitement exclu du scan.
  insert into public.admin_audit_logs
    (actor_admin_id, actor_auth_uid, actor_email, actor_role,
     action, severity, success, target_table, target_id, target_user_id, comment)
  values
    (v_actor.id, v_actor.auth_uid, v_actor.email, v_actor.role,
     'user.delete_account', 'critical', true, 'user_profiles', p_user_id::text, p_user_id,
     format('Suppression complète du compte %s (uid %s) par %s',
       v_email, p_user_id, coalesce(v_actor.email, '?')));

  -- PK (table, colonne) : une table peut avoir plusieurs colonnes candidates
  -- (ex. cas_pratique_appeals.user_id ET .resolved_by) — traitées séparément,
  -- jamais fusionnées, pour ne jamais supprimer une ligne pour la mauvaise raison.
  create temporary table _admin_delete_targets (
    table_name  text not null,
    column_name text not null,
    is_text     boolean not null,
    primary key (table_name, column_name)
  ) on commit drop;

  insert into _admin_delete_targets
  select c.table_name, c.column_name, false
  from information_schema.columns c
  join information_schema.tables t
    on t.table_schema = c.table_schema and t.table_name = c.table_name
  where c.table_schema = 'public'
    and t.table_type = 'BASE TABLE'
    and c.data_type = 'uuid'
    and c.column_name = any(v_uuid_columns)
    and c.table_name not in ('admin_audit_logs', 'admin_users')
  union
  select c.table_name, c.column_name, true
  from information_schema.columns c
  join information_schema.tables t
    on t.table_schema = c.table_schema and t.table_name = c.table_name
  where c.table_schema = 'public'
    and t.table_type = 'BASE TABLE'
    and c.data_type = 'text'
    and c.column_name = 'user_uid';

  -- Suppression itérative : chaque table bloquée par une contrainte FK
  -- interne (ex. cas_pratique_attempts référencé par cas_pratique_corrections)
  -- est laissée pour le tour suivant, jusqu'à stabilisation.
  loop
    v_pass := v_pass + 1;
    v_progress := false;

    for v_row in select * from _admin_delete_targets loop
      begin
        if v_row.is_text then
          execute format('delete from public.%I where %I = $1', v_row.table_name, v_row.column_name)
            using p_user_id::text;
        else
          execute format('delete from public.%I where %I = $1', v_row.table_name, v_row.column_name)
            using p_user_id;
        end if;
        get diagnostics v_count = row_count;
        if v_count > 0 then
          v_report := jsonb_set(
            v_report, array[v_row.table_name],
            to_jsonb(coalesce((v_report->>v_row.table_name)::bigint, 0) + v_count),
            true
          );
        end if;
        delete from _admin_delete_targets
          where table_name = v_row.table_name and column_name = v_row.column_name;
        v_progress := true;
      exception when foreign_key_violation then
        null; -- réessayé au tour suivant
      end;
    end loop;

    exit when not exists (select 1 from _admin_delete_targets) or not v_progress or v_pass >= 20;
  end loop;

  if exists (select 1 from _admin_delete_targets) then
    raise exception 'Suppression incomplète : colonne(s) bloquée(s) par une contrainte non résolue : %',
      (select string_agg(table_name || '.' || column_name, ', ') from _admin_delete_targets)
      using errcode = '55000';
  end if;

  return jsonb_build_object(
    'ok', true, 'user_id', p_user_id, 'email', v_email,
    'deleted_rows', v_report, 'passes', v_pass
  );
end;
$$;

comment on function public.admin_delete_user_data_completely(uuid,text) is
  'Supprime les données applicatives d''un utilisateur dans toutes les tables découvertes dynamiquement (mêmes conventions que admin_scan_user_tables). Ne touche pas à auth.users : à charge de l''edge function appelante via auth.admin.deleteUser(). Owner only, confirmation email obligatoire.';

revoke all on function public.admin_delete_user_data_completely(uuid,text) from public, anon;
grant execute on function public.admin_delete_user_data_completely(uuid,text) to authenticated;
