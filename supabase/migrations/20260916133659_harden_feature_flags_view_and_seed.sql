-- Keep the mobile remote-config contract explicit and make the public view
-- enforce the querying role's permissions instead of its creator's.
insert into public.cp_feature_flags
  (key, description, value_type, value_default, rollout_percent, is_active)
values
  ('cp_edge_correction', 'Correction des cas pratiques via le service distant.', 'bool', 'false'::jsonb, 0, true),
  ('cp_new_correction_screen', 'Nouvel écran de correction premium.', 'bool', 'false'::jsonb, 100, true),
  ('cp_share_story_enabled', 'Partage natif des résultats.', 'bool', 'true'::jsonb, 100, true),
  ('cp_pdf_export_enabled', 'Export PDF de la copie corrigée.', 'bool', 'true'::jsonb, 100, true),
  ('cp_validate_button_style', 'Style du bouton principal.', 'variant', '["blue","gold","gradient"]'::jsonb, null, true),
  ('cp_validate_button_copy', 'Libellé du bouton principal.', 'variant', '["Valider","Soumettre","Terminer"]'::jsonb, null, true),
  ('cp_question_order', 'Ordre des questions.', 'variant', '["sequential","shuffled"]'::jsonb, null, true),
  ('cp_inline_hints', 'Conseils contextuels pendant la saisie.', 'bool', 'false'::jsonb, 50, true)
on conflict (key) do nothing;

create or replace view public.cp_feature_flags_public
with (security_invoker = true) as
select key, value_type, value_default, rollout_percent, segment
from public.cp_feature_flags
where is_active = true;

grant select on public.cp_feature_flags to anon, authenticated;
grant select on public.cp_feature_flags_public to anon, authenticated;
