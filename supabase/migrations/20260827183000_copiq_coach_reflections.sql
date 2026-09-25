-- COP'IQ Coach: user-owned learning reflections and weekly snapshots.

create table if not exists public.coach_answer_reflections (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  answer_id uuid not null references public.quiz_answer_history(id) on delete cascade,
  confidence text not null check (confidence in ('known', 'hesitant', 'guess')),
  perceived_cause text check (perceived_cause in (
    'unknown_concept', 'confusion', 'inattention', 'too_slow', 'forgotten'
  )),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, answer_id)
);

create table if not exists public.coach_weekly_summaries (
  user_id uuid not null references auth.users(id) on delete cascade,
  week_start date not null,
  metrics jsonb not null default '{}'::jsonb,
  generated_at timestamptz not null default now(),
  primary key (user_id, week_start)
);

alter table public.coach_answer_reflections enable row level security;
alter table public.coach_weekly_summaries enable row level security;

drop policy if exists coach_reflections_own on public.coach_answer_reflections;
create policy coach_reflections_own
on public.coach_answer_reflections for all to authenticated
using ((select auth.uid()) = user_id)
with check (
  (select auth.uid()) = user_id
  and exists (
    select 1 from public.quiz_answer_history h
    where h.id = answer_id and h.user_id = (select auth.uid())
  )
);

drop policy if exists coach_weekly_summaries_own on public.coach_weekly_summaries;
create policy coach_weekly_summaries_own
on public.coach_weekly_summaries for all to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

revoke all on public.coach_answer_reflections from anon;
revoke all on public.coach_weekly_summaries from anon;
grant select, insert, update on public.coach_answer_reflections to authenticated;
grant select, insert, update on public.coach_weekly_summaries to authenticated;

create index if not exists coach_reflections_user_created_idx
  on public.coach_answer_reflections (user_id, created_at desc);

comment on table public.coach_answer_reflections is
  'Private confidence and error-cause feedback used by the explainable COPIQ Coach.';
comment on table public.coach_weekly_summaries is
  'Private weekly pedagogical snapshots for durable progress comparisons.';
