create or replace function public.admin_report_center_list(
  p_kind text default null, p_status text default null, p_search text default null,
  p_limit integer default 150, p_offset integer default 0
) returns table(
  kind text,id text,created_at timestamptz,status text,module text,category text,
  question_id text,question text,message text,report_type text,email text,archived boolean
) language plpgsql security definer set search_path=pg_catalog,public,auth as $$
begin
  if not public.has_admin_permission('reports.read') then raise exception 'Accès refusé.' using errcode='42501'; end if;
  return query
  select * from (
    select 'culture'::text as kind,r.id::text as id,r.created_at,r.status,r.module,r.category,r.question_id::text as question_id,
      r.question,r.message,r.report_type,r.email,r.archived from public.report_culture_generale r
    union all
    select 'psy',r.id::text,r.created_at,r.status,r.module,r.category,r.question_id,r.question,r.message,
      r.report_type,r.email,r.archived from public.tests_psycotechnique_report r
    union all
    select 'cas_pratique',r.id::text,r.created_at,r.status,'cas_pratique',th.slug,r.question_id::text,
      c.title||' — Q'||q.position::text||' : '||q.label,r.message,r.report_type,au.email,r.archived
      from public.cas_pratique_question_reports r join public.cas_pratique_questions q on q.id=r.question_id
      join public.cas_pratique_cases c on c.id=r.case_id left join public.cas_pratique_themes th on th.id=c.theme_id
      left join auth.users au on au.id=r.user_id
    union all
    select 'question',r.id::text,r.created_at,r.status,r.source_file,r.question_category,null,r.question_text,
      r.report_message,r.report_type,r.email,r.archived from public.report_question r
    union all
    select 'bug',r.id::text,r.created_at,coalesce(r.status,'new'),'application',r.category,null,r.title,r.message,
      r.severity,r.email,false from public.bug_reports r
    union all
    select 'contact',r.id::text,r.created_at,r.status,'contact',null,null,r.subject,r.message,null,r.email,
      (r.status='archived') from public.contact_messages r
    union all
    select 'forum',r.id::text,r.created_at,r.status,'forum',r.target_type,r.target_id::text,
      r.target_type||' #'||r.target_id::text,r.details,r.reason,null,false from public.community_reports r
  ) u
  where (p_kind is null or p_kind='' or u.kind=case when p_kind='cg' then 'culture' else p_kind end)
    and (p_status is null or p_status='' or
      (p_status='archived' and u.archived) or (p_status<>'archived' and u.status=p_status))
    and (p_search is null or trim(p_search)='' or u.id=p_search or coalesce(u.question_id,'')=p_search
      or coalesce(u.question,'') ilike '%'||p_search||'%' or coalesce(u.message,'') ilike '%'||p_search||'%'
      or coalesce(u.email,'') ilike '%'||p_search||'%' or coalesce(u.report_type,'') ilike '%'||p_search||'%')
  order by u.created_at desc limit least(greatest(p_limit,1),300) offset greatest(p_offset,0);
end $$;
revoke all on function public.admin_report_center_list(text,text,text,integer,integer) from public,anon;
grant execute on function public.admin_report_center_list(text,text,text,integer,integer) to authenticated,service_role;
notify pgrst,'reload schema';
