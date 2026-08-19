-- COP'IQ — Centre juridique Flutter : colonne de version pour les documents légaux.
-- Additive uniquement : n'affecte pas la logique CMS web existante sur
-- public.information_contents (content_type, status, RLS déjà en place).

begin;

alter table public.information_contents
  add column if not exists version text;

comment on column public.information_contents.version is
  'Version affichée dans le Centre juridique Flutter (ex: "1.0.0"). NULL = non affichée côté app.';

commit;
