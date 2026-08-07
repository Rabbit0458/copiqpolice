-- Normalize the 1,370 remaining double-encoded option arrays, then prevent
-- future imports from reintroducing that format.

update public.quiz_questions
set options = (options #>> '{}')::jsonb
where jsonb_typeof(options) = 'string';

alter table public.quiz_questions
  drop constraint if exists quiz_questions_options_array_check;

alter table public.quiz_questions
  add constraint quiz_questions_options_array_check
  check (options is null or jsonb_typeof(options) = 'array')
  not valid;

alter table public.quiz_questions
  validate constraint quiz_questions_options_array_check;
