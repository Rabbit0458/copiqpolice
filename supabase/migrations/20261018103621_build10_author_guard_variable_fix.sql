-- Build 10: enforce author/moderator boundaries independently of the clients.
create or replace function public.community_guard_author_write()
returns trigger language plpgsql security invoker set search_path = '' as $$
declare
  before_row jsonb; after_row jsonb := to_jsonb(new);
  allowed text[]; space text; v_kind text; author uuid; deleting boolean;
begin
  -- Only audited SECURITY DEFINER RPCs, internal counters and the backend bypass
  -- this client-write guard. RLS still controls which rows clients can reach.
  if current_user in ('postgres','service_role','supabase_admin') then return new; end if;
  if tg_table_name = 'community_posts' then
    author := new.author_id; space := new.space_id; v_kind := 'post';
    allowed := array['title','content','status','deleted_at','edited_at','updated_at'];
  elsif tg_table_name = 'community_comments' then
    author := new.author_id; v_kind := 'comment';
    select p.space_id into space from public.community_posts p where p.id=new.post_id;
    allowed := array['content','status','deleted_at','edited_at'];
  else
    author := new.sender_id; v_kind := 'message';
    select coalesce(r.space_id,'global') into space from public.community_rooms r where r.id=new.room_id;
    allowed := array['content','status','deleted_at','edited_at','attachment_path'];
  end if;
  if author is distinct from auth.uid() or auth.uid() is null then
    raise exception 'Modification reservee a son auteur; utiliser la moderation pour les autres contenus' using errcode='42501';
  end if;
  if tg_op='INSERT' then
    if new.status <> 'published' or new.deleted_at is not null
      or coalesce((after_row->>'is_pinned')::boolean,false)
      or coalesce((after_row->>'is_resolved')::boolean,false)
      or coalesce((after_row->>'is_solution')::boolean,false)
      or after_row->>'solution_comment_id' is not null
      or coalesce((after_row->>'reaction_count')::integer,0)<>0
      or coalesce((after_row->>'comment_count')::integer,0)<>0
      or coalesce((after_row->>'reply_count')::integer,0)<>0
      or coalesce((after_row->>'share_count')::integer,0)<>0
      or coalesce((after_row->>'view_count')::integer,0)<>0 then
      raise exception 'Etat initial de publication interdit' using errcode='42501';
    end if;
    new.created_at := now();
    return new;
  end if;
  before_row := to_jsonb(old);
  if (after_row - allowed) is distinct from (before_row - allowed) then
    raise exception 'Champs reserves au serveur ou a la moderation' using errcode='42501';
  end if;
  deleting := new.status='deleted_by_author';
  if deleting then
    -- Removal remains possible during a sanction, but cannot carry new content.
    if new.content is distinct from old.content and new.content not in ('[supprimé]','') then
      raise exception 'Suppression invalide' using errcode='42501';
    end if;
    if v_kind='post' and after_row->>'title' is distinct from before_row->>'title' then
      raise exception 'Suppression invalide' using errcode='42501';
    end if;
    if v_kind='message' and after_row->'attachment_path' is distinct from before_row->'attachment_path' and after_row->>'attachment_path' is not null then
      raise exception 'Suppression invalide' using errcode='42501';
    end if;
    new.deleted_at := coalesce(old.deleted_at,now());
    return new;
  end if;
  if old.status <> 'published' or new.status <> 'published'
    or new.deleted_at is distinct from old.deleted_at then
    raise exception 'Seule la moderation peut restaurer ou changer cet etat' using errcode='42501';
  end if;
  if v_kind='message' and after_row->'attachment_path' is distinct from before_row->'attachment_path' then
    raise exception 'Piece jointe non modifiable' using errcode='42501';
  end if;
  if exists(select 1 from public.community_sanctions s where s.user_id=auth.uid()
    and s.status='active' and (s.space_id is null or s.space_id in ('global',space))
    and (s.ends_at is null or s.ends_at>now())
    and (s.kind in ('suspension','ban') or s.kind=v_kind||'_restriction')) then
    raise exception 'Modification interdite pendant cette sanction' using errcode='42501';
  end if;
  new.edited_at := now();
  return new;
end $$;
