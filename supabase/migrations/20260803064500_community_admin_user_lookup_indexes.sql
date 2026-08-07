-- Accélère les fiches de modération et les compteurs utilisateur sans
-- dupliquer les index déjà présents sur publications, commentaires et messages.
create index if not exists community_reports_subject_user_created_idx
  on public.community_reports(subject_user_id, created_at desc)
  where subject_user_id is not null;

create index if not exists community_reports_reporter_created_idx
  on public.community_reports(reporter_id, created_at desc);
