-- Conserve dans le dépôt les liens officiels contrôlés dans les consoles stores.
-- Cette migration est idempotente : elle ne journalise que si une correction est requise.
do $$
declare
  v_before jsonb;
  v_after jsonb;
begin
  select to_jsonb(c) into v_before
  from public.cp_app_version_config c
  where c.platform = 'ios';

  update public.cp_app_version_config
  set store_url = 'https://testflight.apple.com/join/tHsJvtre',
      updated_at = now()
  where platform = 'ios'
    and store_url is distinct from 'https://testflight.apple.com/join/tHsJvtre';

  if found then
    select to_jsonb(c) into v_after
    from public.cp_app_version_config c
    where c.platform = 'ios';

    insert into public.admin_audit_logs
      (actor_role, target_table, target_id, action, severity, success,
       old_value, new_value, comment, meta)
    values
      ('system', 'cp_app_version_config', 'ios',
       'mobile_release.store_link_corrected', 'info', true,
       v_before, v_after,
       'Lien TestFlight public vérifié dans App Store Connect puis corrigé côté serveur.',
       jsonb_build_object(
         'source', 'trusted_server_migration',
         'testflight_group', 'BETA-TESTEURS',
         'android_store_url_verified', 'https://play.google.com/store/apps/details?id=fr.copiq.app',
         'android_opt_in_url_verified', 'https://play.google.com/apps/testing/fr.copiq.app'
       ));
  end if;
end
$$;
