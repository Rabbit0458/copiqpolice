-- Repair the learning scope produced by historical quiz screens and prevent
-- any authenticated client (including build 4) from creating an unscoped
-- attempt. Explicit client values remain authoritative when valid.
create or replace function public.normalize_quiz_history_learning_scope()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
declare
  profile_track text;
  profile_mode text;
begin
  if (select auth.uid()) is null then
    raise exception 'authentication required' using errcode = '28000';
  end if;
  if new.uid::text <> (select auth.uid())::text then
    raise exception 'attempt does not belong to caller' using errcode = '42501';
  end if;

  select lower(nullif(btrim(p.user_track), '')),
         lower(nullif(btrim(p.user_mode), ''))
    into profile_track, profile_mode
  from public.user_profiles p
  where p.user_id = (select auth.uid())
  limit 1;

  new.track := case
    when lower(new.track) in ('pa', 'gpx') then lower(new.track)
    when lower(new.grade) in ('pa', 'gpx') then lower(new.grade)
    when profile_track in ('pa', 'gpx') then profile_track
    else null
  end;
  new.mode := case
    when lower(new.mode) in ('exam', 'school') then lower(new.mode)
    when profile_mode in ('exam', 'school') then profile_mode
    else null
  end;
  new.grade := coalesce(nullif(new.grade, ''), new.track);

  if new.track is null or new.mode is null then
    raise exception 'learning scope is required' using errcode = '22023';
  end if;
  return new;
end;
$$;

revoke all on function public.normalize_quiz_history_learning_scope()
  from public, anon;
grant execute on function public.normalize_quiz_history_learning_scope()
  to authenticated;

drop trigger if exists trg_normalize_quiz_history_learning_scope
  on public.quiz_history;
create trigger trg_normalize_quiz_history_learning_scope
before insert on public.quiz_history
for each row execute function public.normalize_quiz_history_learning_scope();

-- Recover attempts already created by build 4 before this safeguard existed.
update public.quiz_history h
set track = coalesce(
      case when lower(h.grade) in ('pa', 'gpx') then lower(h.grade) end,
      case when lower(p.user_track) in ('pa', 'gpx') then lower(p.user_track) end
    ),
    mode = case
      when lower(p.user_mode) in ('exam', 'school') then lower(p.user_mode)
      else h.mode
    end,
    grade = coalesce(nullif(h.grade, ''), p.user_track)
from public.user_profiles p
where h.uid::text = p.user_id::text
  and (
    h.track is null or lower(h.track) not in ('pa', 'gpx')
    or h.mode is null or lower(h.mode) not in ('exam', 'school')
  );

-- Recover question-by-question evidence still present in the historical quiz
-- tables. Each row is attached to the closest owned attempt and deduplicated.
do $$
declare
  source record;
begin
  for source in
    select c.table_name
    from information_schema.columns c
    where c.table_schema = 'public'
      and c.column_name in (
        'id', 'user_uid', 'question', 'user_answer', 'correct_answer',
        'is_correct', 'created_at'
      )
      and c.table_name <> 'quiz_answer_history'
    group by c.table_name
    having count(distinct c.column_name) = 7
  loop
    execute format($sql$
      insert into public.quiz_answer_history (
        user_id, history_id, track, mode, module_key, quiz_key,
        question_id, question_text, options_snapshot, user_answer,
        correct_answer, is_correct, explanation_snapshot, difficulty,
        answered_at, source_table, source_row_id
      )
      select
        (s.payload ->> 'user_uid')::uuid,
        h.id,
        h.track,
        h.mode,
        coalesce(nullif(s.payload ->> 'category', ''), %L),
        %L,
        nullif(s.payload ->> 'question_id', ''),
        coalesce(nullif(s.payload ->> 'question', ''), 'Question'),
        case when jsonb_typeof(s.payload -> 'options') = 'array'
          then s.payload -> 'options' else null end,
        nullif(s.payload ->> 'user_answer', ''),
        nullif(s.payload ->> 'correct_answer', ''),
        coalesce((s.payload ->> 'is_correct')::boolean, false),
        nullif(s.payload ->> 'explanation', ''),
        nullif(s.payload ->> 'difficulty', ''),
        coalesce(nullif(s.payload ->> 'created_at', '')::timestamptz, h.started_at),
        %L,
        (s.payload ->> 'id')::bigint
      from (select to_jsonb(t) as payload from public.%I t) s
      join lateral (
        select qh.id, qh.track, qh.mode, qh.started_at
        from public.quiz_history qh
        where qh.uid::text = s.payload ->> 'user_uid'
          and qh.track in ('pa', 'gpx')
          and qh.mode in ('exam', 'school')
          and qh.started_at <= coalesce(
            nullif(s.payload ->> 'created_at', '')::timestamptz,
            qh.started_at
          ) + interval '5 minutes'
        order by abs(extract(epoch from (
          coalesce(nullif(s.payload ->> 'created_at', '')::timestamptz, qh.started_at)
          - qh.started_at
        )))
        limit 1
      ) h on true
      where coalesce(s.payload ->> 'user_uid', '')
              ~ '^[0-9a-fA-F-]{36}$'
        and coalesce(s.payload ->> 'id', '') ~ '^[0-9]+$'
      on conflict (source_table, source_row_id) do nothing
    $sql$, source.table_name, source.table_name, source.table_name,
      source.table_name);
  end loop;
end;
$$;

comment on function public.normalize_quiz_history_learning_scope() is
  'Server-side guard that assigns every owned quiz attempt to PA/GPX and school/exam.';
