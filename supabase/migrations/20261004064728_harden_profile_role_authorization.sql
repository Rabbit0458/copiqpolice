begin;
create policy user_profiles_insert_role_guard on public.user_profiles
as restrictive for insert to authenticated
with check (role = 'active'::public.user_role);
do $patch$
declare v_definition text;
begin
select pg_get_functiondef('public.set_user_role(uuid,text)'::regprocedure) into v_definition;
if position('IF v_actor_role NOT IN' in v_definition)=0 then
raise exception 'Unexpected set_user_role definition';
end if;
v_definition := replace(v_definition, 'IF v_actor_role NOT IN', 'IF v_actor_role IS NULL OR v_actor_role NOT IN');
execute v_definition;
end
$patch$;
commit;
