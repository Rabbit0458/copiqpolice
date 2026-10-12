-- School content is Premium-only; existing administrator write policies stay unchanged.
alter policy cours_scolarite_read on public.cours_scolarite
  using (is_published and public.is_user_premium((select auth.uid())));
alter policy quiz_scolarite_read on public.quiz_scolarite_questions
  using (is_active and public.is_user_premium((select auth.uid())));
alter policy scolarite_fragments_authenticated_read on public.scolarite_content_fragments
  using (public.is_user_premium((select auth.uid())) or public.has_admin_permission('quiz.write'));
