begin;

drop function if exists public.admin_active_access_set(uuid, text, text);
drop function if exists public.admin_active_access_detail(uuid);
drop function if exists public.admin_active_access_list(text, text);
drop function if exists public.active_verification_submit(jsonb);
drop function if exists public.active_verification_get_questions();
drop function if exists public.active_access_status();
drop function if exists public.active_admin_guard();
drop function if exists public.active_normalize_answer(text);

drop table if exists public.active_verification_answers cascade;
drop table if exists public.active_verification_attempts cascade;
drop table if exists public.active_access_verifications cascade;
drop table if exists public.active_verification_questions cascade;

commit;
