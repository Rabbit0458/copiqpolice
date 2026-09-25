-- Signalements quiz : lien stable vers la question et instantané auditables.
alter table public.report_question
  add column if not exists question_id text,
  add column if not exists question_version text,
  add column if not exists question_options jsonb,
  add column if not exists question_snapshot jsonb not null default '{}'::jsonb;

alter table public.report_question
  drop constraint if exists report_question_options_array_check;
alter table public.report_question
  add constraint report_question_options_array_check
  check (question_options is null or jsonb_typeof(question_options) = 'array');

create index if not exists report_question_question_id_idx
  on public.report_question(question_id, created_at desc);

comment on column public.report_question.question_id is
  'Clé stable ou identifiant de la question signalée.';
comment on column public.report_question.question_snapshot is
  'Instantané immuable du contenu vu par l’utilisateur au moment du signalement.';
