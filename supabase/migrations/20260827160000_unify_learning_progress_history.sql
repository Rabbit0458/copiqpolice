-- COP'IQ learning progress hub.
-- Extends the existing canonical answer history without deleting legacy data.

alter table public.quiz_answer_history
  add column if not exists options_snapshot jsonb,
  add column if not exists explanation_snapshot text,
  add column if not exists question_position integer,
  add column if not exists client_event_id uuid,
  add column if not exists question_version text;

create unique index if not exists uq_quiz_answer_history_client_event
  on public.quiz_answer_history (user_id, client_event_id)
  where client_event_id is not null;

create index if not exists idx_quiz_answer_history_user_errors_date
  on public.quiz_answer_history (user_id, answered_at desc)
  where is_correct = false;

create index if not exists idx_quiz_answer_history_attempt_position
  on public.quiz_answer_history (history_id, question_position, answered_at)
  where history_id is not null;

-- All four official scopes write to the same protected history.
drop policy if exists quiz_answer_history_insert_own
  on public.quiz_answer_history;
create policy quiz_answer_history_insert_own
on public.quiz_answer_history
for insert
to authenticated
with check (
  (select auth.uid()) = user_id
  and track in ('pa', 'gpx')
  and mode in ('exam', 'school')
);

revoke all on table public.quiz_answer_history from anon;
revoke update, delete on table public.quiz_answer_history from authenticated;
grant select, insert on table public.quiz_answer_history to authenticated;

-- Single entry point used by every Flutter quiz. The caller can never write
-- history for another account: user_id is derived inside the function.
create or replace function public.record_learning_answer(
  p_history_id integer,
  p_track text,
  p_mode text,
  p_module_key text,
  p_quiz_key text,
  p_question_id text,
  p_question_text text,
  p_options jsonb,
  p_user_answer text,
  p_correct_answer text,
  p_is_correct boolean,
  p_explanation text default null,
  p_difficulty text default null,
  p_response_time_ms integer default null,
  p_question_position integer default null,
  p_client_event_id uuid default null,
  p_question_version text default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
  caller_id uuid := (select auth.uid());
  answer_id uuid;
begin
  if caller_id is null then
    raise exception 'authentication required' using errcode = '28000';
  end if;
  if p_track not in ('pa', 'gpx') or p_mode not in ('exam', 'school') then
    raise exception 'invalid learning scope' using errcode = '22023';
  end if;
  if nullif(btrim(p_question_text), '') is null then
    raise exception 'question text is required' using errcode = '22023';
  end if;
  if p_response_time_ms is not null and p_response_time_ms < 0 then
    raise exception 'invalid response time' using errcode = '22023';
  end if;
  if p_history_id is not null and not exists (
    select 1 from public.quiz_history h
    where h.id = p_history_id and h.uid::text = caller_id::text
  ) then
    raise exception 'attempt does not belong to caller' using errcode = '42501';
  end if;

  insert into public.quiz_answer_history (
    user_id, history_id, track, mode, module_key, quiz_key,
    question_id, question_text, options_snapshot, user_answer,
    correct_answer, is_correct, explanation_snapshot, difficulty,
    response_time_ms, question_position, client_event_id, question_version,
    answered_at
  ) values (
    caller_id, p_history_id, p_track, p_mode, p_module_key, p_quiz_key,
    p_question_id, p_question_text, p_options, p_user_answer,
    p_correct_answer, p_is_correct, p_explanation, p_difficulty,
    p_response_time_ms, p_question_position, p_client_event_id,
    p_question_version, now()
  )
  on conflict (user_id, client_event_id)
    where client_event_id is not null
  do update set client_event_id = excluded.client_event_id
  returning id into answer_id;

  return answer_id;
end;
$$;

revoke all on function public.record_learning_answer(
  integer, text, text, text, text, text, text, jsonb, text, text,
  boolean, text, text, integer, integer, uuid, text
) from public, anon;
grant execute on function public.record_learning_answer(
  integer, text, text, text, text, text, text, jsonb, text, text,
  boolean, text, text, integer, integer, uuid, text
) to authenticated;

comment on function public.record_learning_answer(
  integer, text, text, text, text, text, text, jsonb, text, text,
  boolean, text, text, integer, integer, uuid, text
) is 'Canonical authenticated answer recorder for PA/GPX school and exam.';

-- Compatibility bridge for the many historical quiz tables still written by
-- generated screens. It mirrors a detailed row only when it can be attached
-- unambiguously to a quiz_history row owned by the authenticated caller.
create or replace function public.mirror_legacy_learning_answer()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
declare
  payload jsonb := to_jsonb(new);
  caller_id uuid := (select auth.uid());
  owner_id uuid;
  attempt_id integer;
  attempt_track text;
  attempt_mode text;
  source_id bigint;
  answer_time timestamptz;
begin
  if caller_id is null then return new; end if;
  begin
    owner_id := nullif(payload ->> 'user_uid', '')::uuid;
  exception when others then
    return new;
  end;
  if owner_id is distinct from caller_id then return new; end if;

  answer_time := coalesce(
    nullif(payload ->> 'created_at', '')::timestamptz,
    now()
  );
  if coalesce(payload ->> 'history_id', '') ~ '^[0-9]+$' then
    attempt_id := (payload ->> 'history_id')::integer;
  end if;

  select h.id, h.track, h.mode
    into attempt_id, attempt_track, attempt_mode
  from public.quiz_history h
  where h.uid::text = caller_id::text
    and (attempt_id is null or h.id = attempt_id)
    and h.started_at <= answer_time + interval '5 minutes'
  order by
    case when attempt_id is not null and h.id = attempt_id then 0 else 1 end,
    abs(extract(epoch from (answer_time - h.started_at)))
  limit 1;

  if attempt_id is null
     or attempt_track not in ('pa', 'gpx')
     or attempt_mode not in ('exam', 'school') then
    return new;
  end if;
  if coalesce(payload ->> 'id', '') ~ '^[0-9]+$' then
    source_id := (payload ->> 'id')::bigint;
  end if;

  insert into public.quiz_answer_history (
    user_id, history_id, track, mode, module_key, quiz_key,
    question_id, question_text, options_snapshot, user_answer,
    correct_answer, is_correct, explanation_snapshot, difficulty,
    answered_at, source_table, source_row_id
  ) values (
    caller_id, attempt_id, attempt_track, attempt_mode,
    coalesce(nullif(payload ->> 'category', ''), tg_table_name),
    tg_table_name,
    nullif(payload ->> 'question_id', ''),
    coalesce(nullif(payload ->> 'question', ''), 'Question'),
    case when jsonb_typeof(payload -> 'options') = 'array'
      then payload -> 'options' else null end,
    nullif(payload ->> 'user_answer', ''),
    nullif(payload ->> 'correct_answer', ''),
    coalesce((payload ->> 'is_correct')::boolean, false),
    nullif(payload ->> 'explanation', ''),
    nullif(payload ->> 'difficulty', ''),
    answer_time, tg_table_name, source_id
  )
  on conflict (source_table, source_row_id) do nothing;
  return new;
exception when invalid_text_representation then
  return new;
end;
$$;

revoke all on function public.mirror_legacy_learning_answer()
  from public, anon;
grant execute on function public.mirror_legacy_learning_answer()
  to authenticated;

do $$
declare
  source record;
begin
  for source in
    select c.table_name
    from information_schema.columns c
    where c.table_schema = 'public'
      and c.column_name in (
        'user_uid', 'question', 'user_answer', 'correct_answer', 'is_correct'
      )
      and c.table_name <> 'quiz_answer_history'
    group by c.table_name
    having count(distinct c.column_name) = 5
  loop
    execute format(
      'drop trigger if exists trg_mirror_learning_answer on public.%I',
      source.table_name
    );
    execute format(
      'create trigger trg_mirror_learning_answer after insert on public.%I '
      'for each row execute function public.mirror_legacy_learning_answer()',
      source.table_name
    );
  end loop;
end;
$$;
