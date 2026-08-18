-- Évite le chevauchement de politiques SELECT tout en conservant la lecture
-- des textes par les utilisateurs connectés de l'application.

drop policy if exists scolarite_fragments_admin_write
  on public.scolarite_content_fragments;

drop policy if exists scolarite_fragments_admin_insert
  on public.scolarite_content_fragments;
create policy scolarite_fragments_admin_insert
  on public.scolarite_content_fragments for insert to authenticated
  with check (public.has_admin_permission('quiz.write'));

drop policy if exists scolarite_fragments_admin_update
  on public.scolarite_content_fragments;
create policy scolarite_fragments_admin_update
  on public.scolarite_content_fragments for update to authenticated
  using (public.has_admin_permission('quiz.write'))
  with check (public.has_admin_permission('quiz.write'));

-- Les liaisons GPX/PA passent uniquement par les RPC administratives gardées.
revoke select on public.scolarite_content_links from authenticated;

notify pgrst, 'reload schema';
