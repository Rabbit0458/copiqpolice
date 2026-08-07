-- Canonical PA/GPX Exam answer history and read-path indexes.
-- This migration is additive: existing quiz/session rows are preserved.

create table if not exists public.quiz_answer_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  history_id integer null references public.quiz_history(id) on delete set null,
  track text not null check (track in ('pa', 'gpx')),
  mode text not null check (mode in ('exam', 'school')),
  module_key text not null,
  quiz_key text not null,
  question_id text null,
  question_text text not null,
  user_answer text null,
  correct_answer text null,
  is_correct boolean not null,
  difficulty text null,
  response_time_ms integer null check (
    response_time_ms is null or response_time_ms >= 0
  ),
  answered_at timestamptz not null default now(),
  source_table text null,
  source_row_id bigint null,
  created_at timestamptz not null default now(),
  unique (source_table, source_row_id)
);

comment on table public.quiz_answer_history is
  'Canonical per-answer history for PA and GPX progress dashboards. Session totals remain in quiz_history.';

alter table public.quiz_answer_history enable row level security;

drop policy if exists quiz_answer_history_select_own
  on public.quiz_answer_history;
create policy quiz_answer_history_select_own
on public.quiz_answer_history
for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists quiz_answer_history_insert_own
  on public.quiz_answer_history;
create policy quiz_answer_history_insert_own
on public.quiz_answer_history
for insert
to authenticated
with check (
  (select auth.uid()) = user_id
  and track in ('pa', 'gpx')
  and mode = 'exam'
);

revoke all on table public.quiz_answer_history from anon;
grant select, insert on table public.quiz_answer_history to authenticated;

create index if not exists idx_quiz_answer_history_user_scope_date
  on public.quiz_answer_history (user_id, track, mode, answered_at desc);

create index if not exists idx_quiz_answer_history_user_module
  on public.quiz_answer_history (user_id, track, mode, module_key, is_correct);

create index if not exists idx_quiz_answer_history_session
  on public.quiz_answer_history (history_id)
  where history_id is not null;

create index if not exists idx_quiz_history_user_scope_finished
  on public.quiz_history (uid, track, mode, finished_at desc)
  where completed_at is not null;

create index if not exists idx_psychotechnique_history_user_scope_date
  on public.tests_psychotechnique_history (
    user_id,
    module,
    mode,
    created_at desc
  );

create index if not exists idx_cas_pratique_attempts_user_completed_date
  on public.cas_pratique_attempts (user_id, finished_at desc)
  where status = 'completed' and finished_at is not null;
