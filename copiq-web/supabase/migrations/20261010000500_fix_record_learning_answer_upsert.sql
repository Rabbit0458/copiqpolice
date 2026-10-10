-- Correctif : record_learning_answer échouait avec
-- « permission denied for table quiz_answer_history ».
-- La fonction (SECURITY INVOKER) faisait un ON CONFLICT DO UPDATE, ce qui exige
-- le droit UPDATE que le rôle authenticated n'a pas (et ne doit pas avoir).
-- Même signature, mêmes contrôles, même valeur de retour : on insère avec
-- ON CONFLICT DO NOTHING (seul le droit INSERT est requis) puis on relit l'id
-- existant en cas de doublon (idempotence par client_event_id conservée).

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
set search_path to ''
as $function$
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
  do nothing
  returning id into answer_id;

  if answer_id is null and p_client_event_id is not null then
    select a.id into answer_id
    from public.quiz_answer_history a
    where a.user_id = caller_id and a.client_event_id = p_client_event_id
    limit 1;
  end if;

  return answer_id;
end;
$function$;

revoke all on function public.record_learning_answer(integer, text, text, text, text, text, text, jsonb, text, text, boolean, text, text, integer, integer, uuid, text) from public, anon;
grant execute on function public.record_learning_answer(integer, text, text, text, text, text, text, jsonb, text, text, boolean, text, text, integer, integer, uuid, text) to authenticated, service_role;
