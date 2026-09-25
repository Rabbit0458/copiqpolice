-- Align active-module audit events with the severities accepted by admin_audit_logs.
do $$
declare
  v_function record;
  v_definition text;
begin
  for v_function in
    select p.oid
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname in (
        'admin_active_config_set',
        'admin_active_content_save',
        'admin_active_content_publish',
        'admin_active_content_archive',
        'admin_active_access_set'
      )
  loop
    v_definition := pg_get_functiondef(v_function.oid);
    v_definition := replace(v_definition, '''medium''', '''info''');
    v_definition := replace(v_definition, '''high''', '''warning''');
    execute v_definition;
  end loop;
end;
$$;
