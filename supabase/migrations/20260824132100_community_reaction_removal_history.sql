-- Conserve les retraits de likes dans le journal communautaire.
create or replace function public.community_log_reaction_removal()
returns trigger language plpgsql security definer set search_path = '' as $$
declare v_space_id text;
begin
  select coalesce(p.space_id, cp.space_id) into v_space_id
  from (select 1) seed
  left join public.community_posts p on p.id = old.post_id
  left join public.community_comments c on c.id = old.comment_id
  left join public.community_posts cp on cp.id = c.post_id;
  if v_space_id is not null then
    insert into public.community_moderation_log(actor_id,space_id,action,target_type,target_id,reason,old_state,new_state)
    values(old.user_id,v_space_id,'unlike',case when old.post_id is not null then 'post' else 'comment' end,
      coalesce(old.post_id::text,old.comment_id::text),'Réaction retirée',to_jsonb(old),jsonb_build_object('removed_at',now()));
  end if;
  return old;
end;
$$;
revoke all on function public.community_log_reaction_removal() from public, anon, authenticated;
drop trigger if exists trg_community_reaction_removal_log on public.community_reactions;
create trigger trg_community_reaction_removal_log before delete on public.community_reactions
for each row execute function public.community_log_reaction_removal();
