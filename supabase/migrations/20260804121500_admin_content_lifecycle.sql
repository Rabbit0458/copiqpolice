-- COP'IQ — cycle de vie éditorial des cours et questions de quiz.
-- Les booléens historiques restent la source de visibilité de l'application
-- Flutter ; le panel admin pilote désormais un état éditorial plus complet.

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

alter table public.cours_scolarite
  add column if not exists publication_status text,
  add column if not exists scheduled_at timestamptz,
  add column if not exists published_at timestamptz,
  add column if not exists archived_at timestamptz,
  add column if not exists archived_previous_status text;

update public.cours_scolarite
set publication_status = case when is_published then 'published' else 'draft' end,
    published_at = case
      when is_published then coalesce(published_at, updated_at, created_at, now())
      else published_at
    end
where publication_status is null;

alter table public.cours_scolarite
  alter column publication_status set default 'draft',
  alter column publication_status set not null;

alter table public.cours_scolarite
  drop constraint if exists cours_scolarite_publication_status_check;
alter table public.cours_scolarite
  add constraint cours_scolarite_publication_status_check
  check (publication_status in ('draft', 'scheduled', 'published', 'archived'));

alter table public.cours_scolarite
  drop constraint if exists cours_scolarite_archived_previous_status_check;
alter table public.cours_scolarite
  add constraint cours_scolarite_archived_previous_status_check
  check (archived_previous_status is null or archived_previous_status in ('draft', 'scheduled', 'published'));

alter table public.quiz_scolarite_questions
  add column if not exists publication_status text,
  add column if not exists scheduled_at timestamptz,
  add column if not exists published_at timestamptz,
  add column if not exists archived_at timestamptz,
  add column if not exists archived_previous_status text;

update public.quiz_scolarite_questions
set publication_status = case when is_active then 'published' else 'draft' end,
    published_at = case
      when is_active then coalesce(published_at, updated_at, created_at, now())
      else published_at
    end
where publication_status is null;

alter table public.quiz_scolarite_questions
  alter column publication_status set default 'draft',
  alter column publication_status set not null;

alter table public.quiz_scolarite_questions
  drop constraint if exists quiz_scolarite_publication_status_check;
alter table public.quiz_scolarite_questions
  add constraint quiz_scolarite_publication_status_check
  check (publication_status in ('draft', 'scheduled', 'published', 'archived'));

alter table public.quiz_scolarite_questions
  drop constraint if exists quiz_scolarite_archived_previous_status_check;
alter table public.quiz_scolarite_questions
  add constraint quiz_scolarite_archived_previous_status_check
  check (archived_previous_status is null or archived_previous_status in ('draft', 'scheduled', 'published'));

create index if not exists cours_scolarite_publication_status_idx
  on public.cours_scolarite (publication_status, scheduled_at)
  where publication_status <> 'published';
create index if not exists quiz_scolarite_publication_status_idx
  on public.quiz_scolarite_questions (publication_status, scheduled_at)
  where publication_status <> 'published';

create or replace function private.publish_scheduled_content()
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog, public, private
as $$
declare
  v_courses integer := 0;
  v_questions integer := 0;
begin
  with changed as (
    update public.cours_scolarite
       set publication_status = 'published',
           is_published = true,
           published_at = now(),
           scheduled_at = null,
           archived_at = null,
           archived_previous_status = null,
           updated_at = now()
     where publication_status = 'scheduled'
       and scheduled_at <= now()
     returning id
  ) select count(*) into v_courses from changed;

  with changed as (
    update public.quiz_scolarite_questions
       set publication_status = 'published',
           is_active = true,
           published_at = now(),
           scheduled_at = null,
           archived_at = null,
           archived_previous_status = null,
           updated_at = now()
     where publication_status = 'scheduled'
       and scheduled_at <= now()
     returning id
  ) select count(*) into v_questions from changed;

  if v_courses + v_questions > 0 then
    insert into public.admin_audit_logs
      (action, severity, success, target_table, target_id, new_value, comment)
    values
      ('content.lifecycle.publish_scheduled', 'info', true, 'multiple', null,
       jsonb_build_object('courses', v_courses, 'quiz_questions', v_questions),
       'Publication automatique des contenus planifiés');
  end if;

  return jsonb_build_object('ok', true, 'courses', v_courses, 'quiz_questions', v_questions);
end;
$$;

revoke all on function private.publish_scheduled_content() from public, anon, authenticated;

create or replace function public.content_admin_set_lifecycle(
  p_content_type text,
  p_content_key text,
  p_status text,
  p_scheduled_at timestamptz default null
)
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_old jsonb;
  v_new jsonb;
  v_status text := lower(trim(p_status));
  v_id bigint;
begin
  perform public.quiz_admin_guard();

  if p_content_type not in ('course', 'quiz_question') then
    raise exception 'Type de contenu invalide.' using errcode = '22023';
  end if;
  if v_status not in ('draft', 'scheduled', 'published', 'archived', 'restore') then
    raise exception 'Etat editorial invalide.' using errcode = '22023';
  end if;
  if v_status = 'scheduled' and (p_scheduled_at is null or p_scheduled_at <= now()) then
    raise exception 'La date de publication doit etre future.' using errcode = '22023';
  end if;

  if p_content_type = 'course' then
    select to_jsonb(c) into v_old
      from public.cours_scolarite c where c.route = p_content_key for update;
    if v_old is null then
      raise exception 'Fiche de cours introuvable.' using errcode = 'P0002';
    end if;

    if v_status = 'restore' then
      v_status := coalesce(v_old->>'archived_previous_status', 'draft');
      -- L'archivage efface volontairement la programmation : restaurer une
      -- ancienne planification en brouillon évite une publication surprise.
      if v_status = 'scheduled' then v_status := 'draft'; end if;
    end if;

    update public.cours_scolarite
       set archived_previous_status = case when v_status = 'archived' then publication_status else null end,
           publication_status = v_status,
           is_published = (v_status = 'published'),
           scheduled_at = case when v_status = 'scheduled' then p_scheduled_at else null end,
           published_at = case when v_status = 'published' then now() else published_at end,
           archived_at = case when v_status = 'archived' then now() else null end,
           updated_at = now()
     where route = p_content_key;

    select c.id, to_jsonb(c) into v_id, v_new
      from public.cours_scolarite c where c.route = p_content_key;
  else
    begin
      v_id := p_content_key::bigint;
    exception when invalid_text_representation then
      raise exception 'Identifiant de question invalide.' using errcode = '22023';
    end;

    select to_jsonb(q) into v_old
      from public.quiz_scolarite_questions q where q.id = v_id for update;
    if v_old is null then
      raise exception 'Question introuvable.' using errcode = 'P0002';
    end if;

    if v_status = 'restore' then
      v_status := coalesce(v_old->>'archived_previous_status', 'draft');
      if v_status = 'scheduled' then v_status := 'draft'; end if;
    end if;

    update public.quiz_scolarite_questions
       set archived_previous_status = case when v_status = 'archived' then publication_status else null end,
           publication_status = v_status,
           is_active = (v_status = 'published'),
           scheduled_at = case when v_status = 'scheduled' then p_scheduled_at else null end,
           published_at = case when v_status = 'published' then now() else published_at end,
           archived_at = case when v_status = 'archived' then now() else null end,
           updated_at = now()
     where id = v_id
     returning to_jsonb(quiz_scolarite_questions.*) into v_new;
  end if;

  insert into public.admin_audit_logs
    (actor_auth_uid, action, severity, success, target_table, target_id,
     old_value, new_value, comment)
  values
    (auth.uid(), 'content.lifecycle.' || v_status, 'info', true,
     case when p_content_type = 'course' then 'cours_scolarite' else 'quiz_scolarite_questions' end,
     case when p_content_type = 'course' then p_content_key else v_id::text end,
     v_old - 'body_md' - 'options' - 'answer',
     v_new - 'body_md' - 'options' - 'answer',
     'Panel admin — cycle de vie editorial');

  return jsonb_build_object(
    'ok', true,
    'content_type', p_content_type,
    'content_key', p_content_key,
    'publication_status', v_status,
    'scheduled_at', v_new->'scheduled_at',
    'published_at', v_new->'published_at',
    'archived_at', v_new->'archived_at'
  );
end;
$$;

revoke all on function public.content_admin_set_lifecycle(text, text, text, timestamptz) from public, anon;
grant execute on function public.content_admin_set_lifecycle(text, text, text, timestamptz) to authenticated, service_role;

-- Les RPC de liste exposent les nouveaux états sans accès direct aux tables.
drop function if exists public.cours_admin_list(text, text, text);
create function public.cours_admin_list(
  p_track text default null,
  p_module text default null,
  p_search text default null
)
returns table(
  id bigint, route text, track text, module text, section text, code text,
  title text, subtitle text, quiz_module text, is_published boolean,
  publication_status text, scheduled_at timestamptz, published_at timestamptz,
  archived_at timestamptz, archived_previous_status text,
  taille integer, updated_at timestamptz
)
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
begin
  perform public.quiz_admin_guard();
  return query
  select c.id, c.route, c.track, c.module, c.section, c.code, c.title, c.subtitle,
         c.quiz_module, c.is_published, c.publication_status, c.scheduled_at,
         c.published_at, c.archived_at, c.archived_previous_status,
         length(c.body_md), c.updated_at
    from public.cours_scolarite c
   where (p_track is null or c.track = p_track)
     and (p_module is null or c.module = p_module)
     and (p_search is null or c.title ilike '%' || p_search || '%'
          or c.route ilike '%' || p_search || '%')
   order by c.track, c.module, c.section, c.sort_order;
end;
$$;
revoke all on function public.cours_admin_list(text, text, text) from public, anon;
grant execute on function public.cours_admin_list(text, text, text) to authenticated, service_role;

drop function if exists public.quiz_admin_list_questions(text, text);
create function public.quiz_admin_list_questions(
  p_module text,
  p_search text default null
)
returns table(
  id bigint, category text, difficulty text, question text, options jsonb,
  answer text, explanation text, legal_ref text, is_active boolean,
  publication_status text, scheduled_at timestamptz, published_at timestamptz,
  archived_at timestamptz, archived_previous_status text, updated_at timestamptz
)
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
begin
  perform public.quiz_admin_guard();
  return query
  select q.id, q.category, q.difficulty, q.question, q.options, q.answer,
         q.explanation, q.legal_ref, q.is_active, q.publication_status,
         q.scheduled_at, q.published_at, q.archived_at,
         q.archived_previous_status, q.updated_at
    from public.quiz_scolarite_questions q
   where q.module = p_module
     and (p_search is null or q.question ilike '%' || p_search || '%'
          or q.answer ilike '%' || p_search || '%')
   order by q.position, q.id;
end;
$$;
revoke all on function public.quiz_admin_list_questions(text, text) from public, anon;
grant execute on function public.quiz_admin_list_questions(text, text) to authenticated, service_role;

-- Publication automatique, idempotente et isolée du Data API.
do $$
begin
  if exists (select 1 from pg_extension where extname = 'pg_cron') then
    perform cron.unschedule(jobid)
      from cron.job where jobname = 'copiq_publish_scheduled_content';
    perform cron.schedule(
      'copiq_publish_scheduled_content',
      '* * * * *',
      'select private.publish_scheduled_content();'
    );
  end if;
end;
$$;

notify pgrst, 'reload schema';
