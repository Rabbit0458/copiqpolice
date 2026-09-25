-- COP'IQ — User 360 : scanner exhaustif multi-relations.
-- Une table peut référencer le même compte par plusieurs colonnes
-- (auteur/destinataire, reporter/sujet, acteur/cible). Les fonctions
-- précédentes n'en retenaient qu'une. Cette version agrège toutes les
-- relations et ne compte chaque ligne qu'une fois grâce à un prédicat OR.

create or replace function public.admin_scan_user_tables(p_user_id uuid)
returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare
  v_result jsonb := '{}'::jsonb;
  v_table record;
  v_column record;
  v_predicates text;
  v_relations text;
  v_count bigint;
  v_uuid_columns constant text[] := array[
    'user_id','author_id','sender_id','recipient_id','reporter_id',
    'subject_user_id','actor_id','imposed_by','revoked_by','target_user_id',
    'resolved_by','uid','moderator_id','admin_id','auth_uid','created_by',
    'updated_by','assigned_to','owner_id','member_id'
  ];
begin
  perform public.community_admin_owner_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  for v_table in
    select distinct c.table_name
    from information_schema.columns c
    join information_schema.tables t on t.table_schema=c.table_schema and t.table_name=c.table_name
    where c.table_schema='public' and t.table_type='BASE TABLE'
      and ((c.data_type='uuid' and c.column_name=any(v_uuid_columns))
        or (c.data_type='text' and c.column_name in ('user_uid','user_id','uid')))
    order by c.table_name
  loop
    v_predicates := null;
    v_relations := null;
    for v_column in
      select c.column_name, c.data_type
      from information_schema.columns c
      where c.table_schema='public' and c.table_name=v_table.table_name
        and ((c.data_type='uuid' and c.column_name=any(v_uuid_columns))
          or (c.data_type='text' and c.column_name in ('user_uid','user_id','uid')))
      order by c.ordinal_position
    loop
      v_predicates := concat_ws(' or ', v_predicates,
        case when v_column.data_type='uuid'
          then format('%I = $1', v_column.column_name)
          else format('%I = $1::text', v_column.column_name) end);
      v_relations := concat_ws(', ', v_relations, v_column.column_name);
    end loop;
    execute format('select count(*) from public.%I where %s', v_table.table_name, v_predicates)
      into v_count using p_user_id;
    if v_count > 0 then
      v_result := v_result || jsonb_build_object(v_table.table_name,
        jsonb_build_object('count',v_count,'relation',v_relations));
    end if;
  end loop;
  return v_result;
end;
$$;

create or replace function public.admin_get_user_raw_table_data(
  p_user_id uuid, p_table text, p_limit integer default 20, p_offset integer default 0
) returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare
  v_limit integer := least(greatest(coalesce(p_limit,20),1),100);
  v_offset integer := greatest(coalesce(p_offset,0),0);
  v_uuid_columns constant text[] := array[
    'user_id','author_id','sender_id','recipient_id','reporter_id',
    'subject_user_id','actor_id','imposed_by','revoked_by','target_user_id',
    'resolved_by','uid','moderator_id','admin_id','auth_uid','created_by',
    'updated_by','assigned_to','owner_id','member_id'
  ];
  v_column record;
  v_predicates text;
  v_relations text;
  v_columns text;
  v_order_by text;
  v_rows jsonb;
  v_total bigint;
begin
  perform public.community_admin_owner_guard();
  if p_user_id is null or p_table is null then raise exception 'Utilisateur et table obligatoires' using errcode='22023'; end if;
  if not exists(select 1 from information_schema.tables where table_schema='public' and table_name=p_table and table_type='BASE TABLE') then
    raise exception 'Table inconnue' using errcode='22023';
  end if;

  for v_column in
    select c.column_name,c.data_type from information_schema.columns c
    where c.table_schema='public' and c.table_name=p_table
      and ((c.data_type='uuid' and c.column_name=any(v_uuid_columns))
        or (c.data_type='text' and c.column_name in ('user_uid','user_id','uid')))
    order by c.ordinal_position
  loop
    v_predicates := concat_ws(' or ',v_predicates,
      case when v_column.data_type='uuid' then format('%I = $1',v_column.column_name)
      else format('%I = $1::text',v_column.column_name) end);
    v_relations := concat_ws(', ',v_relations,v_column.column_name);
  end loop;
  if v_predicates is null then raise exception 'Table non liée à un utilisateur' using errcode='22023'; end if;

  select string_agg(format('%I',column_name),', ' order by ordinal_position) into v_columns
  from information_schema.columns where table_schema='public' and table_name=p_table
    and column_name !~* 'password|token|secret|hash|encrypted|otp|api_key';
  if v_columns is null then raise exception 'Aucune colonne exposable' using errcode='22023'; end if;
  select case when exists(select 1 from information_schema.columns where table_schema='public' and table_name=p_table and column_name='created_at')
    then 'order by created_at desc' else '' end into v_order_by;

  execute format('select count(*) from public.%I where %s',p_table,v_predicates) into v_total using p_user_id;
  execute format('select coalesce(jsonb_agg(to_jsonb(t)),''[]''::jsonb) from (select %s from public.%I where %s %s limit $2 offset $3) t',v_columns,p_table,v_predicates,v_order_by)
    into v_rows using p_user_id,v_limit,v_offset;
  return jsonb_build_object('table',p_table,'relation',v_relations,'total_count',v_total,'rows',v_rows);
end;
$$;

revoke all on function public.admin_scan_user_tables(uuid) from public, anon;
revoke all on function public.admin_get_user_raw_table_data(uuid,text,integer,integer) from public, anon;
grant execute on function public.admin_scan_user_tables(uuid) to authenticated;
grant execute on function public.admin_get_user_raw_table_data(uuid,text,integer,integer) to authenticated;

comment on function public.admin_scan_user_tables(uuid) is
  'User 360 owner-only : toutes les tables publiques et toutes les colonnes reliant une ligne au compte, sans double comptage.';
