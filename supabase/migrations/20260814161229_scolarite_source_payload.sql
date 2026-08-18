-- Copie source et résultat d'extraction : preuve vérifiable de migration sans perte.
alter table public.scolarite_source_registry
  add column if not exists source_text text,
  add column if not exists extracted_payload jsonb not null default '{}'::jsonb,
  add column if not exists extraction_version integer not null default 1;

create index if not exists scolarite_source_registry_status_idx
  on public.scolarite_source_registry(track, content_type, migration_status);

create or replace function public.scolarite_admin_migration_summary()
returns jsonb language plpgsql security definer
set search_path = pg_catalog, public
as $$
declare r jsonb;
begin
  perform public.quiz_admin_guard();
  select jsonb_build_object(
    'total', count(*),
    'gpx', count(*) filter (where track='gpx'),
    'pa', count(*) filter (where track='pa'),
    'courses', count(*) filter (where content_type in ('course','introduction')),
    'quiz_files', count(*) filter (where content_type='quiz'),
    'pending', count(*) filter (where migration_status='pending'),
    'extracted', count(*) filter (where migration_status='extracted'),
    'imported', count(*) filter (where migration_status='imported'),
    'verified', count(*) filter (where migration_status='verified'),
    'errors', count(*) filter (where migration_status='error'),
    'source_bytes', coalesce(sum(source_bytes),0),
    'source_lines', coalesce(sum(source_lines),0),
    'quiz_questions', coalesce(sum(quiz_question_count),0)
  ) into r from public.scolarite_source_registry;
  return r;
end;
$$;
revoke all on function public.scolarite_admin_migration_summary() from public, anon;
grant execute on function public.scolarite_admin_migration_summary() to authenticated, service_role;

notify pgrst, 'reload schema';
