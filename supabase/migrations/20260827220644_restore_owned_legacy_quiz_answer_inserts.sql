-- Build 4 and older generated quizzes still write their per-question evidence
-- to dedicated legacy tables. Restore only the minimum owned INSERT right;
-- SELECT remains governed by each table's existing policies and UPDATE/DELETE
-- are not granted.
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
    execute format('alter table public.%I enable row level security',
      source.table_name);
    execute format('drop policy if exists learning_answer_insert_own on public.%I',
      source.table_name);
    execute format(
      'create policy learning_answer_insert_own on public.%I '
      'for insert to authenticated '
      'with check ((select auth.uid()) = user_uid)',
      source.table_name
    );
    execute format('grant insert on table public.%I to authenticated',
      source.table_name);

    -- Keep the canonical mirror present even on tables created after the first
    -- learning-history migration.
    execute format('drop trigger if exists trg_mirror_learning_answer on public.%I',
      source.table_name);
    execute format(
      'create trigger trg_mirror_learning_answer after insert on public.%I '
      'for each row execute function public.mirror_legacy_learning_answer()',
      source.table_name
    );
  end loop;
end;
$$;
