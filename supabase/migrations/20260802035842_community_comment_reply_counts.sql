alter table public.community_comments
add column if not exists reply_count integer not null default 0
check (reply_count >= 0);

update public.community_comments parent
set reply_count = counts.total
from (
  select parent_id, count(*)::integer as total
  from public.community_comments
  where parent_id is not null and status = 'published'
  group by parent_id
) counts
where parent.id = counts.parent_id;

update public.community_comments parent
set reply_count = 0
where not exists (
  select 1 from public.community_comments child
  where child.parent_id = parent.id and child.status = 'published'
);

create or replace function public.community_sync_comment_reply_count()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if tg_op in ('UPDATE', 'DELETE')
    and old.parent_id is not null
    and old.status = 'published'
  then
    update public.community_comments
    set reply_count = greatest(reply_count - 1, 0)
    where id = old.parent_id;
  end if;

  if tg_op in ('INSERT', 'UPDATE')
    and new.parent_id is not null
    and new.status = 'published'
  then
    update public.community_comments
    set reply_count = reply_count + 1
    where id = new.parent_id;
  end if;

  if tg_op = 'DELETE' then
    return old;
  end if;
  return new;
end
$$;

drop trigger if exists community_comments_sync_reply_count
on public.community_comments;
create trigger community_comments_sync_reply_count
after insert or delete or update of parent_id, status
on public.community_comments
for each row
execute function public.community_sync_comment_reply_count();

revoke all on function public.community_sync_comment_reply_count()
from public, anon, authenticated;
