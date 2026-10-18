do $$
declare definition text;
begin
  select pg_get_functiondef(oid) into definition from pg_proc
    where pronamespace='public'::regnamespace and proname='community_admin_list_users';
  if definition is null then raise exception 'Account directory RPC missing'; end if;
  definition:=replace(definition,'''owner'',''admin'',''moderator''','''owner'',''admin''');
  execute definition;
end $$;
