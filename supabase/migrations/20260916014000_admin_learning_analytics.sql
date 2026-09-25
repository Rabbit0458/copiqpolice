-- Owner-only learning outcomes. Requested quiz length is deliberately excluded:
-- accuracy is based solely on answers actually persisted by the app.
create or replace function public.admin_learning_analytics(p_days integer default 30)
returns jsonb
language plpgsql
stable
security definer
set search_path = public, auth
as $$
declare
  v_start timestamptz;
  v_result jsonb;
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then
    raise exception 'Accès refusé.' using errcode = '42501';
  end if;
  if p_days is null or p_days not in (7, 30, 90) then
    raise exception 'Période invalide.' using errcode = '22023';
  end if;
  v_start := (((now() at time zone 'Europe/Paris')::date - (p_days - 1))::timestamp at time zone 'Europe/Paris');

  with answers as (
    select user_id, track, mode, difficulty, module_key, is_correct,
           (answered_at at time zone 'Europe/Paris')::date as day
    from public.quiz_answer_history
    where answered_at >= v_start and answered_at <= now()
  ), journeys as (
    select * from (values
      (1,'gpx','school','Scolarité GPX'),
      (2,'pa','school','Scolarité PA'),
      (3,'gpx','exam','Concours GPX'),
      (4,'pa','exam','Concours PA')
    ) as j(position,track,mode,label)
  ), grouped as (
    select track, mode, count(*)::integer saved,
           count(*) filter (where is_correct)::integer correct,
           count(distinct user_id)::integer learners
    from answers group by track, mode
  )
  select jsonb_build_object(
    'days', p_days,
    'refreshed_at', now(),
    'definition', 'Taux de réussite = réponses correctes / réponses réellement sauvegardées. La longueur choisie pour une série ne figure pas au dénominateur.',
    'summary', (
      select jsonb_build_object(
        'saved', count(*)::integer,
        'correct', count(*) filter (where is_correct)::integer,
        'learners', count(distinct user_id)::integer,
        'accuracy', round(100.0 * count(*) filter (where is_correct) / nullif(count(*),0),1)
      ) from answers
    ),
    'journeys', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'track', j.track, 'mode', j.mode, 'label', j.label,
        'saved', coalesce(g.saved,0), 'correct', coalesce(g.correct,0),
        'learners', coalesce(g.learners,0),
        'accuracy', round(100.0 * g.correct / nullif(g.saved,0),1)
      ) order by j.position), '[]'::jsonb)
      from journeys j left join grouped g on g.track=j.track and g.mode=j.mode
    ),
    'difficulty', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'label', d.label, 'saved', d.saved, 'correct', d.correct,
        'learners', d.learners,
        'accuracy', round(100.0 * d.correct / nullif(d.saved,0),1)
      ) order by d.saved desc, d.label), '[]'::jsonb)
      from (select coalesce(nullif(trim(difficulty),''),'Non renseignée') label,
                   count(*)::integer saved,
                   count(*) filter (where is_correct)::integer correct,
                   count(distinct user_id)::integer learners
            from answers group by 1) d
    ),
    'daily', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'date', d.day, 'saved', d.saved, 'correct', d.correct,
        'accuracy', round(100.0 * d.correct / nullif(d.saved,0),1)
      ) order by d.day), '[]'::jsonb)
      from (select day, count(*)::integer saved,
                   count(*) filter (where is_correct)::integer correct
            from answers group by day) d
    ),
    'psychotechnique', (
      select jsonb_build_object(
        'exercises', count(*)::integer,
        'learners', count(distinct user_id)::integer,
        'accuracy', round(100.0 * sum(correct_answers) / nullif(sum(correct_answers + wrong_answers),0),1),
        'total_answered', sum(correct_answers + wrong_answers)::integer
      ) from public.tests_psychotechnique_history
      where created_at >= v_start and created_at <= now()
    ),
    'practical', (
      select jsonb_build_object(
        'attempts', count(*)::integer,
        'learners', count(distinct user_id)::integer,
        'scored', count(*) filter (where percent is not null)::integer,
        'average_percent', round(avg(percent) filter (where percent is not null),1)
      ) from public.cas_pratique_attempts
      where created_at >= v_start and created_at <= now()
    )
  ) into v_result;

  return v_result;
end;
$$;

comment on function public.admin_learning_analytics(integer) is
  'Owner/AAL2 aggregated learning outcomes. Accuracy uses only persisted answers.';
revoke all on function public.admin_learning_analytics(integer) from public, anon;
grant execute on function public.admin_learning_analytics(integer) to authenticated;
