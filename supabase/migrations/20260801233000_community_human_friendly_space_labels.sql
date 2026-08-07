-- Human-friendly labels shown by web/admin clients. Internal identifiers stay
-- unchanged so existing posts, memberships, links and RLS policies are safe.
update public.community_spaces
set label = case id
  when 'global' then 'Tout le monde'
  when 'pa_exam' then 'Concours Policier adjoint'
  when 'gpx_exam' then 'Concours Gardien de la paix'
  when 'pa_school' then 'École Policier adjoint'
  when 'gpx_school' then 'École Gardien de la paix'
end,
description = case id
  when 'global' then 'Publications visibles par toute la communauté COP’IQ'
  when 'pa_exam' then 'Préparation au recrutement de policier adjoint'
  when 'gpx_exam' then 'Préparation au concours de gardien de la paix'
  when 'pa_school' then 'Formation initiale des policiers adjoints'
  when 'gpx_school' then 'Formation initiale des gardiens de la paix'
end
where id in ('global','pa_exam','gpx_exam','pa_school','gpx_school');
