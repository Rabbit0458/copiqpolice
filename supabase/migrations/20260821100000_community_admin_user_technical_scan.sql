-- ============================================================================
--  COP'IQ — Dossier administrateur : Phase C — Données techniques (owner only)
--  ---------------------------------------------------------------------------
--  Scanner générique : découvre dynamiquement, via information_schema, toutes
--  les tables du schéma public possédant une colonne référençant un
--  utilisateur (convention de nommage), sans liste figée en dur. Réservé au
--  rôle owner strictement (accès aux données brutes de toutes les tables).
--
--  SÉCURITÉ :
--    • community_admin_owner_guard() : owner uniquement (pas admin/moderator).
--    • Le SQL dynamique n'utilise JAMAIS de valeur utilisateur concaténée :
--      les noms de table/colonne viennent uniquement de information_schema
--      (catalogue système), toujours passés via format('%I') ; p_user_id est
--      toujours lié en paramètre (USING), jamais concaténé.
--    • admin_get_user_raw_table_data n'accepte qu'un nom de table présent
--      dans le résultat du scanner (liste blanche dynamique) et exclut
--      systématiquement les colonnes sensibles par motif de nom.
-- ============================================================================

create or replace function public.community_admin_owner_guard()
returns void language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.has_admin_role('owner') then
    raise exception 'Accès réservé au rôle owner' using errcode = '42501';
  end if;
end;
$$;

comment on function public.community_admin_owner_guard() is
  'Garde stricte owner-only pour les fonctionnalités les plus sensibles (données techniques, export brut).';


-- ===========================================================================
--  1. SCANNER — compte les lignes liées à l'utilisateur, table par table
-- ===========================================================================
create or replace function public.admin_scan_user_tables(p_user_id uuid)
returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare
  v_result jsonb := '{}'::jsonb;
  v_row record;
  v_count bigint;
  -- Conventions de nommage du projet pour une colonne uuid référençant un utilisateur.
  v_uuid_columns text[] := array[
    'user_id','author_id','sender_id','recipient_id','reporter_id',
    'subject_user_id','actor_id','imposed_by','revoked_by','target_user_id',
    'resolved_by','uid','moderator_id','admin_id','auth_uid'
  ];
begin
  perform public.community_admin_owner_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  -- Colonnes uuid nommées selon convention.
  for v_row in
    select c.table_name, c.column_name
    from information_schema.columns c
    join information_schema.tables t
      on t.table_schema = c.table_schema and t.table_name = c.table_name
    where c.table_schema = 'public'
      and t.table_type = 'BASE TABLE'
      and c.data_type = 'uuid'
      and c.column_name = any(v_uuid_columns)
    order by c.table_name, c.column_name
  loop
    execute format(
      'select count(*) from public.%I where %I = $1',
      v_row.table_name, v_row.column_name
    ) into v_count using p_user_id;

    if v_count > 0 then
      v_result := v_result || jsonb_build_object(
        v_row.table_name, jsonb_build_object('count', v_count, 'relation', v_row.column_name)
      );
    end if;
  end loop;

  -- Colonnes texte contenant un uuid sérialisé (ex. report_question.user_uid).
  for v_row in
    select c.table_name, c.column_name
    from information_schema.columns c
    join information_schema.tables t
      on t.table_schema = c.table_schema and t.table_name = c.table_name
    where c.table_schema = 'public'
      and t.table_type = 'BASE TABLE'
      and c.data_type = 'text'
      and c.column_name = 'user_uid'
    order by c.table_name
  loop
    execute format(
      'select count(*) from public.%I where %I = $1',
      v_row.table_name, v_row.column_name
    ) into v_count using p_user_id::text;

    if v_count > 0 then
      v_result := v_result || jsonb_build_object(
        v_row.table_name, jsonb_build_object('count', v_count, 'relation', v_row.column_name)
      );
    end if;
  end loop;

  return v_result;
end;
$$;

comment on function public.admin_scan_user_tables(uuid) is
  'Scanner générique : découvre via information_schema les tables liées à un utilisateur et compte ses lignes. Owner only.';


-- ===========================================================================
--  2. LIGNES BRUTES D'UNE TABLE — liste blanche dynamique + colonnes sensibles exclues
-- ===========================================================================
create or replace function public.admin_get_user_raw_table_data(
  p_user_id uuid,
  p_table   text,
  p_limit   integer default 20,
  p_offset  integer default 0
) returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare
  v_limit   integer := least(greatest(coalesce(p_limit, 20), 1), 100);
  v_offset  integer := greatest(coalesce(p_offset, 0), 0);
  v_relation text;
  v_is_text  boolean;
  v_columns  text;
  v_order_by text;
  v_rows     jsonb;
  v_total    bigint;
begin
  perform public.community_admin_owner_guard();
  if p_user_id is null or p_table is null then
    raise exception 'Utilisateur et table obligatoires' using errcode = '22023';
  end if;

  -- La table demandée doit être une table réellement liée à l'utilisateur
  -- (même liste blanche que le scanner : jamais de nom de table arbitraire).
  select c.column_name, (c.data_type = 'text')
    into v_relation, v_is_text
  from information_schema.columns c
  join information_schema.tables t
    on t.table_schema = c.table_schema and t.table_name = c.table_name
  where c.table_schema = 'public'
    and t.table_type = 'BASE TABLE'
    and c.table_name = p_table
    and (
      (c.data_type = 'uuid' and c.column_name = any(array[
        'user_id','author_id','sender_id','recipient_id','reporter_id',
        'subject_user_id','actor_id','imposed_by','revoked_by','target_user_id',
        'resolved_by','uid','moderator_id','admin_id','auth_uid'
      ]))
      or (c.data_type = 'text' and c.column_name = 'user_uid')
    )
  order by c.column_name
  limit 1;

  if v_relation is null then
    raise exception 'Table inconnue ou non liée à un utilisateur' using errcode = '22023';
  end if;

  -- Colonnes exposées : tout sauf les motifs sensibles.
  select string_agg(format('%I', column_name), ', ' order by ordinal_position)
    into v_columns
  from information_schema.columns
  where table_schema = 'public' and table_name = p_table
    and column_name !~* 'password|token|secret|hash|encrypted|otp|api_key';

  if v_columns is null then
    raise exception 'Aucune colonne exposable pour cette table' using errcode = '22023';
  end if;

  -- Tri par created_at si la colonne existe, sinon ordre non garanti.
  select case when exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = p_table and column_name = 'created_at'
  ) then format('order by %I desc', 'created_at') else '' end
  into v_order_by;

  if v_is_text then
    execute format(
      'select count(*) from public.%I where %I = $1',
      p_table, v_relation
    ) into v_total using p_user_id::text;

    execute format(
      'select coalesce(jsonb_agg(to_jsonb(t)), ''[]''::jsonb) from (select %s from public.%I where %I = $1 %s limit $2 offset $3) t',
      v_columns, p_table, v_relation, v_order_by
    ) into v_rows using p_user_id::text, v_limit, v_offset;
  else
    execute format(
      'select count(*) from public.%I where %I = $1',
      p_table, v_relation
    ) into v_total using p_user_id;

    execute format(
      'select coalesce(jsonb_agg(to_jsonb(t)), ''[]''::jsonb) from (select %s from public.%I where %I = $1 %s limit $2 offset $3) t',
      v_columns, p_table, v_relation, v_order_by
    ) into v_rows using p_user_id, v_limit, v_offset;
  end if;

  return jsonb_build_object('table', p_table, 'relation', v_relation, 'total_count', v_total, 'rows', v_rows);
end;
$$;

comment on function public.admin_get_user_raw_table_data(uuid,text,integer,integer) is
  'Lignes brutes d''une table liée à l''utilisateur, paginées. Liste blanche dynamique, colonnes sensibles exclues. Owner only.';


-- ===========================================================================
--  3. PERMISSIONS
-- ===========================================================================
revoke all on function public.community_admin_owner_guard() from public, anon;
revoke all on function public.admin_scan_user_tables(uuid) from public, anon;
revoke all on function public.admin_get_user_raw_table_data(uuid,text,integer,integer) from public, anon;

grant execute on function public.community_admin_owner_guard() to authenticated;
grant execute on function public.admin_scan_user_tables(uuid) to authenticated;
grant execute on function public.admin_get_user_raw_table_data(uuid,text,integer,integer) to authenticated;
