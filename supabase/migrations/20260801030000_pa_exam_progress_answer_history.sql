-- Canonical PA Exam answer history used by the "Mon suivi" dashboard.
-- Session aggregates remain in quiz_history; this table stores answers only.

create table if not exists public.quiz_answer_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  history_id integer null references public.quiz_history(id) on delete set null,
  track text not null default 'pa' check (track in ('pa', 'gpx')),
  mode text not null default 'exam' check (mode in ('exam', 'school')),
  module_key text not null,
  quiz_key text not null,
  question_id text null,
  question_text text not null,
  user_answer text null,
  correct_answer text null,
  is_correct boolean not null,
  difficulty text null,
  response_time_ms integer null check (response_time_ms is null or response_time_ms >= 0),
  answered_at timestamptz not null default now(),
  source_table text null,
  source_row_id bigint null,
  created_at timestamptz not null default now(),
  unique (source_table, source_row_id)
);

alter table public.quiz_answer_history enable row level security;

drop policy if exists quiz_answer_history_select_own on public.quiz_answer_history;
create policy quiz_answer_history_select_own
on public.quiz_answer_history for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists quiz_answer_history_insert_own on public.quiz_answer_history;
create policy quiz_answer_history_insert_own
on public.quiz_answer_history for insert
to authenticated
with check (
  (select auth.uid()) = user_id
  and track = 'pa'
  and mode = 'exam'
);

revoke all on table public.quiz_answer_history from anon;
grant select, insert on table public.quiz_answer_history to authenticated;

create index if not exists idx_quiz_answer_history_user_scope_date
  on public.quiz_answer_history (user_id, track, mode, answered_at desc);
create index if not exists idx_quiz_answer_history_user_module
  on public.quiz_answer_history (user_id, module_key, is_correct);
create index if not exists idx_quiz_answer_history_session
  on public.quiz_answer_history (history_id)
  where history_id is not null;

-- Photolangage is currently PA-only. Persist its scope explicitly so future
-- modules cannot silently contaminate the PA Exam dashboard.
alter table public.photolangage_attempts
  add column if not exists track text not null default 'pa',
  add column if not exists mode text not null default 'exam';

do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname = 'photolangage_attempts_track_check'
      and conrelid = 'public.photolangage_attempts'::regclass
  ) then
    alter table public.photolangage_attempts
      add constraint photolangage_attempts_track_check check (track = 'pa');
  end if;
  if not exists (
    select 1 from pg_constraint
    where conname = 'photolangage_attempts_mode_check'
      and conrelid = 'public.photolangage_attempts'::regclass
  ) then
    alter table public.photolangage_attempts
      add constraint photolangage_attempts_mode_check check (mode = 'exam');
  end if;
end $$;

-- Backfill only rows explicitly marked PA. Rows with a null discriminator are
-- intentionally excluded because their ownership cannot be proven reliably.
do $$
declare
  source record;
begin
  for source in
    select * from (values
      ('quiz_culture_generale_actualite_pages', 'culture_generale'),
      ('quiz_culture_generale_cinema_pages', 'culture_generale'),
      ('quiz_culture_generale_droit_pages', 'culture_generale'),
      ('quiz_culture_generale_geographie_pages', 'culture_generale'),
      ('quiz_culture_generale_musique_pages', 'culture_generale'),
      ('quiz_culture_generale_mythologie_pages', 'culture_generale'),
      ('quiz_culture_generale_police_pages', 'institution'),
      ('quiz_culture_generale_sante_pages', 'culture_generale'),
      ('quiz_culture_generale_sciences_pages', 'culture_generale'),
      ('quiz_culture_generale_sport_pages', 'culture_generale'),
      ('quiz_psycotechniques_calcul_pages', 'psychotechnique'),
      ('quiz_psycotechniques_concentration_pages', 'psychotechnique'),
      ('quiz_psycotechniques_raisonnement_pages', 'psychotechnique'),
      ('quiz_psycotechniques_verbal_pages', 'psychotechnique')
    ) as sources(table_name, module_key)
  loop
    execute format(
      'insert into public.quiz_answer_history
       (user_id, track, mode, module_key, quiz_key, question_text,
        user_answer, correct_answer, is_correct, difficulty, answered_at,
        source_table, source_row_id)
       select user_uid, ''pa'', ''exam'', %L, %L, question,
              user_answer, correct_answer, is_correct, difficulty, created_at,
              %L, id
       from public.%I
       where exam_type = ''pa'' and user_uid is not null
       on conflict (source_table, source_row_id) do nothing',
      source.module_key,
      source.table_name,
      source.table_name,
      source.table_name
    );
  end loop;
end $$;

comment on table public.quiz_answer_history is
  'Canonical per-answer history. Session totals remain in quiz_history; PA Exam dashboard must not count these rows as sessions.';

-- Harmonise legacy per-question tables still used by current quiz pages.
do $$
declare
  table_name text;
begin
  foreach table_name in array array[
    'quiz_culture_generale_actualite_pages',
    'quiz_culture_generale_cinema_pages',
    'quiz_culture_generale_droit_pages',
    'quiz_culture_generale_geographie_pages',
    'quiz_culture_generale_histoire_france_pages',
    'quiz_culture_generale_institutions_europeennes_pages',
    'quiz_culture_generale_musique_pages',
    'quiz_culture_generale_mythologie_pages',
    'quiz_culture_generale_pages',
    'quiz_culture_generale_police_pages',
    'quiz_culture_generale_sante_pages',
    'quiz_culture_generale_sciences_pages',
    'quiz_culture_generale_securite_routiere_pages',
    'quiz_culture_generale_sport_pages',
    'quiz_psycotechniques_calcul_pages',
    'quiz_psycotechniques_concentration_pages',
    'quiz_psycotechniques_raisonnement_pages',
    'quiz_psycotechniques_verbal_pages'
  ] loop
    execute format('alter table public.%I add column if not exists exam_type text', table_name);
    execute format('alter table public.%I add column if not exists history_id integer references public.quiz_history(id) on delete set null', table_name);
    execute format('drop policy if exists pa_exam_insert_own on public.%I', table_name);
    execute format(
      'create policy pa_exam_insert_own on public.%I for insert to authenticated '
      'with check (user_uid = (select auth.uid()) and exam_type = ''pa'')',
      table_name
    );
    execute format('grant select, insert on table public.%I to authenticated', table_name);
  end loop;
end $$;

create or replace function public.sync_pa_exam_answer_history()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
declare
  module text;
begin
  if new.exam_type is distinct from 'pa' then
    return new;
  end if;
  -- Keep legacy admin imports working; user-owned runtime inserts are the
  -- only rows mirrored automatically under the caller's RLS context.
  if (select auth.uid()) is null or new.user_uid is distinct from (select auth.uid()) then
    return new;
  end if;
  module := case
    when tg_table_name like 'quiz_psycotechniques_%' then 'psychotechnique'
    when tg_table_name = 'quiz_culture_generale_police_pages' then 'institution'
    when tg_table_name = 'quiz_culture_generale_pages' then 'francais'
    else 'culture_generale'
  end;
  insert into public.quiz_answer_history (
    user_id, history_id, track, mode, module_key, quiz_key,
    question_text, user_answer, correct_answer, is_correct, difficulty,
    answered_at, source_table, source_row_id
  ) values (
    new.user_uid, new.history_id, 'pa', 'exam', module, tg_table_name,
    new.question, new.user_answer, new.correct_answer, new.is_correct,
    new.difficulty, new.created_at, tg_table_name, new.id
  ) on conflict (source_table, source_row_id) do nothing;
  return new;
end;
$$;

revoke all on function public.sync_pa_exam_answer_history() from public;
grant execute on function public.sync_pa_exam_answer_history() to authenticated;

do $$
declare
  table_name text;
begin
  foreach table_name in array array[
    'quiz_culture_generale_actualite_pages', 'quiz_culture_generale_cinema_pages',
    'quiz_culture_generale_droit_pages', 'quiz_culture_generale_geographie_pages',
    'quiz_culture_generale_histoire_france_pages', 'quiz_culture_generale_institutions_europeennes_pages',
    'quiz_culture_generale_musique_pages', 'quiz_culture_generale_mythologie_pages',
    'quiz_culture_generale_pages', 'quiz_culture_generale_police_pages',
    'quiz_culture_generale_sante_pages', 'quiz_culture_generale_sciences_pages',
    'quiz_culture_generale_securite_routiere_pages', 'quiz_culture_generale_sport_pages',
    'quiz_psycotechniques_calcul_pages', 'quiz_psycotechniques_concentration_pages',
    'quiz_psycotechniques_raisonnement_pages', 'quiz_psycotechniques_verbal_pages'
  ] loop
    execute format('drop trigger if exists trg_sync_pa_answer_history on public.%I', table_name);
    execute format(
      'create trigger trg_sync_pa_answer_history after insert on public.%I '
      'for each row execute function public.sync_pa_exam_answer_history()',
      table_name
    );
  end loop;
end $$;
