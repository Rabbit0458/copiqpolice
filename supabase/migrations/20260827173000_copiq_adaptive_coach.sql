-- COP'IQ adaptive learning coach: synchronized preferences and spaced review.

create table if not exists public.coach_user_preferences (
  user_id uuid primary key references auth.users(id) on delete cascade,
  daily_question_goal integer not null default 10
    check (daily_question_goal between 1 and 50),
  target_exam_date date,
  preferred_session_minutes integer not null default 15
    check (preferred_session_minutes between 5 and 60),
  updated_at timestamptz not null default now()
);

create table if not exists public.coach_question_mastery (
  user_id uuid not null references auth.users(id) on delete cascade,
  track text not null check (track in ('pa', 'gpx')),
  mode text not null check (mode in ('exam', 'school')),
  question_key text not null,
  module_key text not null,
  question_text text not null,
  attempts integer not null default 0 check (attempts >= 0),
  correct_attempts integer not null default 0 check (correct_attempts >= 0),
  consecutive_correct integer not null default 0 check (consecutive_correct >= 0),
  mastery_score numeric(5,2) not null default 0
    check (mastery_score between 0 and 100),
  review_interval_days integer not null default 1
    check (review_interval_days between 1 and 365),
  next_review_at timestamptz not null default now(),
  last_answered_at timestamptz not null default now(),
  last_was_correct boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (user_id, track, mode, question_key)
);

alter table public.coach_user_preferences enable row level security;
alter table public.coach_question_mastery enable row level security;

drop policy if exists coach_preferences_own on public.coach_user_preferences;
create policy coach_preferences_own
on public.coach_user_preferences for all to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists coach_mastery_select_own
  on public.coach_question_mastery;
create policy coach_mastery_select_own
on public.coach_question_mastery for select to authenticated
using ((select auth.uid()) = user_id);

revoke all on public.coach_user_preferences from anon;
revoke all on public.coach_question_mastery from anon;
grant select, insert, update on public.coach_user_preferences to authenticated;
grant select on public.coach_question_mastery to authenticated;

create index if not exists coach_mastery_due_idx
  on public.coach_question_mastery
    (user_id, track, mode, next_review_at, mastery_score);

create or replace function public.update_coach_question_mastery()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  stable_key text := coalesce(
    nullif(new.question_id, ''),
    md5(lower(btrim(new.question_text)))
  );
begin
  -- This function is trigger-only (EXECUTE revoked below). The source row has
  -- already passed quiz_answer_history ownership RLS / its secured recorder.
  insert into public.coach_question_mastery (
    user_id, track, mode, question_key, module_key, question_text,
    attempts, correct_attempts, consecutive_correct, mastery_score,
    review_interval_days, next_review_at, last_answered_at,
    last_was_correct, updated_at
  ) values (
    new.user_id, new.track, new.mode, stable_key, new.module_key,
    new.question_text, 1, case when new.is_correct then 1 else 0 end,
    case when new.is_correct then 1 else 0 end,
    case when new.is_correct then 65 else 20 end,
    1, new.answered_at + interval '1 day', new.answered_at,
    new.is_correct, now()
  )
  on conflict (user_id, track, mode, question_key) do update set
    module_key = excluded.module_key,
    question_text = excluded.question_text,
    attempts = public.coach_question_mastery.attempts + 1,
    correct_attempts = public.coach_question_mastery.correct_attempts
      + case when new.is_correct then 1 else 0 end,
    consecutive_correct = case
      when new.is_correct
        then public.coach_question_mastery.consecutive_correct + 1
      else 0 end,
    mastery_score = greatest(0, least(100,
      public.coach_question_mastery.mastery_score
      + case when new.is_correct then 12 else -22 end)),
    review_interval_days = case
      when not new.is_correct then 1
      when public.coach_question_mastery.consecutive_correct <= 0 then 1
      when public.coach_question_mastery.consecutive_correct = 1 then 3
      when public.coach_question_mastery.consecutive_correct = 2 then 7
      else 30 end,
    next_review_at = new.answered_at + make_interval(days => case
      when not new.is_correct then 1
      when public.coach_question_mastery.consecutive_correct <= 0 then 1
      when public.coach_question_mastery.consecutive_correct = 1 then 3
      when public.coach_question_mastery.consecutive_correct = 2 then 7
      else 30 end),
    last_answered_at = new.answered_at,
    last_was_correct = new.is_correct,
    updated_at = now();
  return new;
end;
$$;

revoke all on function public.update_coach_question_mastery()
  from public, anon;

drop trigger if exists trg_update_coach_mastery
  on public.quiz_answer_history;
create trigger trg_update_coach_mastery
after insert on public.quiz_answer_history
for each row execute function public.update_coach_question_mastery();

comment on table public.coach_question_mastery is
  'Per-user adaptive mastery and spaced-review schedule for COPIQ Coach.';
