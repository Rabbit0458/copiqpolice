-- Les notifications appartiennent à leur destinataire. Elles peuvent être
-- retirées de son centre sans donner accès aux notifications d'un autre compte.
drop policy if exists community_notifications_own_delete
  on public.community_notifications;

create policy community_notifications_own_delete
on public.community_notifications
for delete
to authenticated
using (recipient_id = (select auth.uid()));

grant delete on public.community_notifications to authenticated;
