-- Tout signalement visant une question stockée en base doit conserver son ID source.
alter table public.report_culture_generale
  alter column question_id set not null;

alter table public.tests_psycotechnique_report
  alter column question_id set not null;

alter table public.tests_psycotechnique_report
  add constraint tests_psycotechnique_report_question_id_not_blank
  check (btrim(question_id) <> '');
