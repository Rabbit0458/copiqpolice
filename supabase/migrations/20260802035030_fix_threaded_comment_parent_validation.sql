-- Évite une auto-référence dans la policy RLS (récursion PostgreSQL). La
-- cohérence parent/post est validée par un trigger invoker avant insertion.
drop policy if exists community_comments_insert on public.community_comments;
create policy community_comments_insert
on public.community_comments
for insert
to authenticated
with check (
  author_id = (select auth.uid())
  and public.community_can_publish(
    (select p.space_id from public.community_posts p where p.id = post_id),
    'comment'
  )
);

create or replace function public.community_validate_comment_parent()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if new.parent_id is not null and not exists (
    select 1
    from public.community_comments parent
    where parent.id = new.parent_id
      and parent.post_id = new.post_id
      and parent.status = 'published'
  ) then
    raise exception 'Le commentaire parent est invalide pour cette publication'
      using errcode = '23514';
  end if;
  return new;
end
$$;

drop trigger if exists community_comments_validate_parent
on public.community_comments;
create trigger community_comments_validate_parent
before insert or update of parent_id, post_id
on public.community_comments
for each row
execute function public.community_validate_comment_parent();

revoke all on function public.community_validate_comment_parent()
from public, anon, authenticated;
