drop policy if exists cgv_consent_events_no_direct_access on public.cgv_consent_events;
create policy cgv_consent_events_no_direct_access on public.cgv_consent_events
for all to anon, authenticated using (false) with check (false);

revoke all on function public.handle_new_user_minimal() from public, anon, authenticated;
