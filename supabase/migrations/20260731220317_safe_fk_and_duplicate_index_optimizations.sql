-- Safe database optimizations validated with the Supabase advisors.
-- Adds covering indexes for foreign keys and removes only byte-for-byte
-- duplicate indexes. No table data or constraint is changed.

do $$
declare r record;
begin
  for r in
    with fks as (
      select distinct n.nspname schema_name, c.relname table_name, con.conkey,
             array_agg(a.attname order by u.ord) cols
      from pg_constraint con
      join pg_class c on c.oid=con.conrelid
      join pg_namespace n on n.oid=c.relnamespace
      cross join lateral unnest(con.conkey) with ordinality u(attnum,ord)
      join pg_attribute a on a.attrelid=c.oid and a.attnum=u.attnum
      where con.contype='f'
        and n.nspname in ('public','archive','beta')
        and not exists (
          select 1 from pg_index i
          where i.indrelid=con.conrelid and i.indisvalid
            and (i.indkey::smallint[])[0:cardinality(con.conkey)-1] = con.conkey
        )
      group by n.nspname,c.relname,con.conkey
    )
    select schema_name,table_name,cols,
      left('idx_'||table_name||'_'||array_to_string(cols,'_'),63) index_name
    from fks
  loop
    execute format('create index if not exists %I on %I.%I (%s)',
      r.index_name,r.schema_name,r.table_name,
      (select string_agg(format('%I',x),', ') from unnest(r.cols) x));
  end loop;
end $$;

drop index if exists public.admin_users_email_unique_ci;
drop index if exists public.app_meta_key_uidx;
drop index if exists public.idx_billing_events_user_time;
drop index if exists public.idx_billing_invoices_user_created;
drop index if exists public.idx_forum_post_comments_post;
drop index if exists public.idx_forum_post_comments_parent;
drop index if exists public.forum_post_likes_unique;
drop index if exists public.subscription_events_stripe_event_uidx;
drop index if exists public.idx_tests_psyco_suite_logique_rand;
drop index if exists public.idx_tests_psyco_suite_logique_active;
drop index if exists public.user_registry_email_unique;
