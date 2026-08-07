-- Index couvrant les relations les plus sollicitées par le forum.
create index if not exists community_comments_parent_id_idx
on public.community_comments(parent_id)
where parent_id is not null;

create index if not exists community_blocks_blocked_id_idx
on public.community_blocks(blocked_id);

create index if not exists community_bookmarks_post_id_idx
on public.community_bookmarks(post_id);
