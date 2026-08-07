-- Réactions et solutions de commentaires.
create or replace function public.community_set_solution(
  p_post_id uuid,
  p_comment_id uuid
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_owner uuid;
begin
  if (select auth.uid()) is null then
    raise exception 'Connexion requise' using errcode = '42501';
  end if;

  select author_id into v_owner
  from public.community_posts
  where id = p_post_id and status in ('published', 'locked');

  if v_owner is distinct from (select auth.uid()) then
    raise exception 'Seul l auteur de la publication peut choisir la solution'
      using errcode = '42501';
  end if;

  if not exists (
    select 1 from public.community_comments
    where id = p_comment_id and post_id = p_post_id and status = 'published'
  ) then
    raise exception 'Commentaire invalide' using errcode = '23514';
  end if;

  update public.community_comments
  set is_solution = (id = p_comment_id)
  where post_id = p_post_id and is_solution is distinct from (id = p_comment_id);

  update public.community_posts
  set solution_comment_id = p_comment_id,
      is_resolved = true,
      updated_at = now()
  where id = p_post_id;
end
$$;
revoke all on function public.community_set_solution(uuid, uuid)
from public, anon;
grant execute on function public.community_set_solution(uuid, uuid)
to authenticated;

create or replace function public.community_sync_comment_reaction_count()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_comment_id uuid := coalesce(new.comment_id, old.comment_id);
begin
  if v_comment_id is not null then
    update public.community_comments c
    set reaction_count = (
      select count(*) from public.community_reactions r
      where r.comment_id = v_comment_id
    )
    where c.id = v_comment_id;
  end if;
  if tg_op = 'DELETE' then return old; end if;
  return new;
end
$$;
drop trigger if exists community_comment_reaction_counts
on public.community_reactions;
create trigger community_comment_reaction_counts
after insert or delete
on public.community_reactions
for each row
execute function public.community_sync_comment_reaction_count();
revoke all on function public.community_sync_comment_reaction_count()
from public, anon, authenticated;

-- Notification dédiée lorsqu'un commentaire reçoit un J'aime.
create or replace function public.community_reaction_notification_trigger()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_author uuid;
  v_space text;
  v_post_id uuid;
begin
  if new.comment_id is not null then
    select c.author_id, c.post_id, p.space_id
    into v_author, v_post_id, v_space
    from public.community_comments c
    join public.community_posts p on p.id = c.post_id
    where c.id = new.comment_id;

    if v_author is not null and v_author <> new.user_id then
      insert into public.community_notifications(
        recipient_id, actor_id, space_id, type, target_type, target_id, payload
      ) values (
        v_author, new.user_id, v_space, 'comment_reaction', 'post', v_post_id,
        jsonb_build_object('kind', new.kind, 'comment_id', new.comment_id)
      );
    end if;
  elsif new.post_id is not null then
    select p.author_id, p.space_id into v_author, v_space
    from public.community_posts p where p.id = new.post_id;
    if v_author is not null and v_author <> new.user_id then
      insert into public.community_notifications(
        recipient_id, actor_id, space_id, type, target_type, target_id, payload
      ) values (
        v_author, new.user_id, v_space, 'reaction', 'post', new.post_id,
        jsonb_build_object('kind', new.kind)
      );
    end if;
  end if;
  return new;
end
$$;
revoke all on function public.community_reaction_notification_trigger()
from public, anon, authenticated;

-- Les anciennes migrations utilisent ce nom de trigger.
drop trigger if exists community_reaction_notifications
on public.community_reactions;
drop trigger if exists community_reactions_notify
on public.community_reactions;
create trigger community_reaction_notifications
after insert on public.community_reactions
for each row execute function public.community_reaction_notification_trigger();

create index if not exists community_comments_relevant_idx
on public.community_comments(post_id, parent_id, is_solution desc, reaction_count desc, created_at desc)
where status = 'published';

-- Anti-spam : doublons rapprochés et rafales de commentaires.
create or replace function public.community_guard_comment_rate()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if exists (
    select 1 from public.community_comments c
    where c.author_id = new.author_id
      and c.post_id = new.post_id
      and lower(trim(c.content)) = lower(trim(new.content))
      and c.created_at > now() - interval '60 seconds'
  ) then
    raise exception 'Ce commentaire vient déjà d être envoyé'
      using errcode = 'P0001';
  end if;

  if (
    select count(*) from public.community_comments c
    where c.author_id = new.author_id
      and c.created_at > now() - interval '60 seconds'
  ) >= 5 then
    raise exception 'Trop de commentaires envoyés. Réessaie dans un instant.'
      using errcode = 'P0001';
  end if;
  return new;
end
$$;
drop trigger if exists community_comments_rate_guard
on public.community_comments;
create trigger community_comments_rate_guard
before insert on public.community_comments
for each row execute function public.community_guard_comment_rate();
revoke all on function public.community_guard_comment_rate()
from public, anon, authenticated;

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'community_comments'
  ) then
    alter publication supabase_realtime add table public.community_comments;
  end if;
end
$$;
