-- Les écritures de contenu psychotechnique sont réservées aux administrateurs
-- disposant de quiz.write. Les lectures actives restent disponibles à l'app.

begin;

drop policy if exists psyco_av_delete on public.tests_psyco_attention_visuelle;
drop policy if exists psyco_av_insert on public.tests_psyco_attention_visuelle;
drop policy if exists psyco_av_update on public.tests_psyco_attention_visuelle;

drop policy if exists psyco_calcul_delete on public.tests_psyco_calcul_mental;
drop policy if exists psyco_calcul_insert on public.tests_psyco_calcul_mental;
drop policy if exists psyco_calcul_update on public.tests_psyco_calcul_mental;
drop policy if exists psyco_concentration_delete on public.tests_psyco_concentration;
drop policy if exists psyco_concentration_insert on public.tests_psyco_concentration;
drop policy if exists psyco_concentration_update on public.tests_psyco_concentration;
drop policy if exists psyco_verbale_delete on public.tests_psyco_logique_verbale;
drop policy if exists psyco_verbale_insert on public.tests_psyco_logique_verbale;
drop policy if exists psyco_verbale_update on public.tests_psyco_logique_verbale;
drop policy if exists psyco_raisonnement_delete on public.tests_psyco_raisonnement_logique;
drop policy if exists psyco_raisonnement_insert on public.tests_psyco_raisonnement_logique;
drop policy if exists psyco_raisonnement_update on public.tests_psyco_raisonnement_logique;
drop policy if exists psyco_spatial_delete on public.tests_psyco_raisonnement_spatial;
drop policy if exists psyco_spatial_insert on public.tests_psyco_raisonnement_spatial;
drop policy if exists psyco_spatial_update on public.tests_psyco_raisonnement_spatial;
drop policy if exists psyco_rotations_delete on public.tests_psyco_rotations_symetries;
drop policy if exists psyco_rotations_insert on public.tests_psyco_rotations_symetries;
drop policy if exists psyco_rotations_update on public.tests_psyco_rotations_symetries;
drop policy if exists psyco_sl_delete on public.tests_psyco_suite_logique;
drop policy if exists psyco_sl_insert on public.tests_psyco_suite_logique;
drop policy if exists psyco_sl_update on public.tests_psyco_suite_logique;

do $$ declare t text; begin
  foreach t in array array[
    'tests_psyco_calcul_mental','tests_psyco_concentration','tests_psyco_logique_verbale',
    'tests_psyco_raisonnement_logique','tests_psyco_raisonnement_spatial',
    'tests_psyco_rotations_symetries','tests_psyco_suite_logique'
  ] loop
    execute format('drop policy if exists p_admin_insert on public.%I',t);
    execute format('drop policy if exists p_admin_update on public.%I',t);
    execute format('drop policy if exists p_admin_delete on public.%I',t);
    execute format('create policy p_admin_insert on public.%I for insert to authenticated with check (public.has_admin_permission(''quiz.write''))',t);
    execute format('create policy p_admin_update on public.%I for update to authenticated using (public.has_admin_permission(''quiz.write'')) with check (public.has_admin_permission(''quiz.write''))',t);
    execute format('create policy p_admin_delete on public.%I for delete to authenticated using (public.has_admin_permission(''quiz.write''))',t);
  end loop;
end $$;

notify pgrst,'reload schema';
commit;
