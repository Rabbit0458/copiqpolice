-- Personal account deletion reaches this helper through delete-user-cascade.
-- Founder deletion in the panel uses its separate owner-guarded RPC.
revoke all on function public.purge_user(uuid) from public, anon, authenticated;
grant execute on function public.purge_user(uuid) to service_role;

create or replace function public.set_admin_panel_code(p_email text, p_code text)
returns void
language plpgsql
security definer
set search_path to ''
as $function$
begin
  -- current_user is postgres inside SECURITY DEFINER; check the invoking role.
  if current_setting('role', true) is distinct from 'service_role' then
    perform public.community_admin_owner_guard();
  end if;

  update public.admin_users
  set admin_code_hash = extensions.crypt(p_code, extensions.gen_salt('bf', 10)),
      admin_code = null
  where public.norm_email(email) = public.norm_email(p_email);
end;
$function$;

revoke all on function public.set_admin_panel_code(text, text) from public, anon, authenticated;
-- Authenticated callers still need the owner guard above; ordinary users fail.
grant execute on function public.set_admin_panel_code(text, text) to authenticated, service_role;
