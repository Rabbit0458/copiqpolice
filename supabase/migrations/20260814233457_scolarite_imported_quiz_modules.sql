-- Référence chacun des quiz extraits des 1 409 fichiers de scolarité dans le
-- catalogue administrable. Les questions ont été importées avant cette étape ;
-- ce catalogue leur ajoute le titre, la filière et la route dynamique.
--
-- La migration est volontairement idempotente et ne remplace aucun module
-- historique déjà configuré à la main.

insert into public.quiz_scolarite_modules (
  module,
  track,
  title,
  subtitle,
  icon,
  color_hex,
  route,
  sort_order,
  is_active
)
select
  q.module,
  min(q.track) as track,
  initcap(
    replace(
      regexp_replace(max(q.source_path), '^.*/|\\.dart$', '', 'g'),
      '_',
      ' '
    )
  ) as title,
  'Quiz importé depuis la scolarité ' || upper(min(q.track)) as subtitle,
  'quiz' as icon,
  case when min(q.track) = 'pa' then '#C0392B' else '#1147D9' end as color_hex,
  '/scolarite/quiz/' || q.module as route,
  1000 + row_number() over (order by q.module) as sort_order,
  true as is_active
from public.quiz_scolarite_questions q
where q.source_path is not null
  and q.module is not null
  and btrim(q.module) <> ''
group by q.module
on conflict (module) do nothing;

notify pgrst, 'reload schema';
