-- Le propriétaire du panel doit pouvoir administrer tous les espaces.
-- Les autres rôles continuent d'exiger un scope explicite par mission.
insert into public.community_moderator_scopes(
  user_id, space_id, role, granted_by, granted_at, expires_at
)
select a.auth_uid, 'global', 'owner', a.auth_uid, now(), null
from public.admin_users a
where lower(a.role) = 'owner'
  and not a.disabled
  and a.auth_uid is not null
on conflict (user_id, space_id) do update
set role = 'owner', expires_at = null;
