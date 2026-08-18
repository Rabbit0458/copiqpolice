begin;

insert into public.information_contents
  (content_type, slug, title, summary, body_md, category, status, sort_order, published_at)
values
  ('legal_notice', 'mentions-legales', 'Mentions légales', 'Éditeur, hébergeur et propriété intellectuelle.', $legal$
## Éditeur

Le site et l'application COP'IQ sont édités par **COP'IQ**.

- Contact : **contact@copiq.fr**
- Directeur de la publication : **[à compléter avant la mise en production]**
- Adresse du siège : **[à compléter avant la mise en production]**
- Immatriculation : **[à compléter avant la mise en production]**

## Hébergement

Le site est hébergé par **IONOS SE**, Elgendorfer Str. 57, 56410 Montabaur, Allemagne.

Les données applicatives sont hébergées par **Supabase** dans l'Union européenne selon la configuration du projet.

## Propriété intellectuelle

Les textes, interfaces, illustrations, marques et contenus pédagogiques de COP'IQ sont protégés. Toute reproduction ou diffusion non autorisée est interdite.

## Données personnelles

Les traitements sont détaillés dans la politique de confidentialité. Pour exercer tes droits : **contact@copiq.fr**.

## Responsabilité

COP'IQ fournit un outil de préparation pédagogique. Les contenus ne remplacent ni les textes officiels en vigueur, ni les consignes de l'administration, ni un conseil juridique.
$legal$, 'Légal', 'published', 10, now()),
  ('privacy', 'confidentialite', 'Politique de confidentialité', 'Collecte, utilisation, conservation et protection des données.', $privacy$
## Responsable du traitement

COP'IQ est responsable du traitement de vos données personnelles. Pour toute question : **contact@copiq.fr**.

## Données traitées

Selon votre utilisation, nous pouvons traiter vos informations de compte, votre progression pédagogique, vos préférences, vos demandes de support, les données techniques nécessaires à la sécurité ainsi que les informations de facturation transmises par Stripe.

COP'IQ ne stocke pas les numéros complets de carte bancaire.

## Finalités

Les données sont utilisées pour fournir le service, synchroniser la progression, gérer l'abonnement, répondre au support, sécuriser les comptes et améliorer l'application.

## Destinataires

Les données sont accessibles aux seules personnes habilitées et aux prestataires nécessaires au fonctionnement du service, notamment Supabase pour l'infrastructure et Stripe pour la facturation.

## Conservation

Les durées de conservation dépendent de la nature des données, des obligations légales et de la durée de la relation contractuelle. Les demandes de support sont conservées le temps nécessaire à leur traitement et à leur suivi.

## Vos droits

Tu disposes de droits d'accès, de rectification, d'effacement, de limitation, d'opposition et de portabilité. Tu peux exercer ces droits via **contact@copiq.fr**. Tu peux également saisir la CNIL.

## Sécurité

Des mesures techniques et organisationnelles sont mises en œuvre pour protéger les données, notamment le contrôle des accès, les politiques de sécurité de la base et la double authentification du panneau d'administration.

## Contact

Pour toute question relative à la confidentialité : **contact@copiq.fr**.
$privacy$, 'Légal', 'published', 20, now())
on conflict (content_type, slug) do update set
  title = excluded.title,
  summary = excluded.summary,
  body_md = excluded.body_md,
  category = excluded.category,
  updated_at = now();

alter table public.patch_notes
  add column if not exists publication_status text,
  add column if not exists summary text,
  add column if not exists scheduled_at timestamptz,
  add column if not exists published_at timestamptz,
  add column if not exists archived_at timestamptz,
  add column if not exists updated_at timestamptz not null default now();

update public.patch_notes
set publication_status = case when is_published then 'published' else 'draft' end,
    published_at = case when is_published then coalesce(published_at, created_at) else published_at end
where publication_status is null;

alter table public.patch_notes alter column publication_status set default 'draft';
alter table public.patch_notes alter column publication_status set not null;

alter table public.patch_notes drop constraint if exists patch_notes_publication_status_check;
alter table public.patch_notes add constraint patch_notes_publication_status_check
  check (publication_status in ('draft', 'scheduled', 'published', 'archived'));

create or replace function public.list_public_patch_notes(p_limit integer default 100)
returns table(id bigint, title text, summary text, body text, published_at timestamptz)
language sql
stable
security definer
set search_path = public
as $$
  select n.id, n.title, n.summary, n.body, coalesce(n.published_at, n.created_at)
  from public.patch_notes n
  where n.publication_status = 'published'
     or (n.publication_status = 'scheduled' and n.scheduled_at <= now())
  order by coalesce(n.published_at, n.scheduled_at, n.created_at) desc
  limit greatest(1, least(coalesce(p_limit, 100), 200));
$$;

revoke all on function public.list_public_patch_notes(integer) from public;
grant execute on function public.list_public_patch_notes(integer) to anon, authenticated;

create or replace function public.patch_notes_admin_list(p_status text default null, p_limit integer default 100)
returns table(
  id bigint, title text, summary text, body text, publication_status text,
  scheduled_at timestamptz, published_at timestamptz, archived_at timestamptz,
  created_at timestamptz, updated_at timestamptz, author_email text
)
language plpgsql
security definer
set search_path = public, auth
as $$
begin
  perform public.information_admin_guard();
  return query
  select n.id, n.title, n.summary, n.body, n.publication_status,
         n.scheduled_at, n.published_at, n.archived_at,
         n.created_at, n.updated_at, u.email::text
  from public.patch_notes n
  left join auth.users u on u.id = n.author_id
  where p_status is null or n.publication_status = p_status
  order by n.updated_at desc
  limit greatest(1, least(coalesce(p_limit, 100), 200));
end;
$$;

create or replace function public.patch_notes_admin_save(
  p_id bigint default null,
  p_title text default '',
  p_summary text default null,
  p_body text default '',
  p_status text default 'draft',
  p_scheduled_at timestamptz default null
)
returns bigint
language plpgsql
security definer
set search_path = public
as $$
declare v_id bigint;
begin
  perform public.information_admin_guard();
  if length(trim(p_title)) < 2 or length(trim(p_body)) < 2 then
    raise exception 'Titre et contenu obligatoires.' using errcode = '22023';
  end if;
  if p_status not in ('draft', 'scheduled', 'published', 'archived') then
    raise exception 'Statut invalide.' using errcode = '22023';
  end if;
  if p_status = 'scheduled' and p_scheduled_at is null then
    raise exception 'Date de programmation obligatoire.' using errcode = '22023';
  end if;

  if p_id is null then
    insert into public.patch_notes
      (title, summary, body, is_published, publication_status, scheduled_at,
       published_at, archived_at, author_id)
    values
      (trim(p_title), nullif(trim(p_summary), ''), p_body,
       p_status = 'published', p_status, p_scheduled_at,
       case when p_status = 'published' then now() end,
       case when p_status = 'archived' then now() end, auth.uid())
    returning id into v_id;
  else
    update public.patch_notes set
      title = trim(p_title), summary = nullif(trim(p_summary), ''), body = p_body,
      is_published = p_status = 'published', publication_status = p_status,
      scheduled_at = case when p_status = 'scheduled' then p_scheduled_at end,
      published_at = case when p_status = 'published' then coalesce(published_at, now()) end,
      archived_at = case when p_status = 'archived' then coalesce(archived_at, now()) end,
      updated_at = now()
    where id = p_id
    returning id into v_id;
  end if;
  return v_id;
end;
$$;

revoke all on function public.patch_notes_admin_list(text, integer) from public;
revoke all on function public.patch_notes_admin_save(bigint, text, text, text, text, timestamptz) from public;
grant execute on function public.patch_notes_admin_list(text, integer) to authenticated;
grant execute on function public.patch_notes_admin_save(bigint, text, text, text, text, timestamptz) to authenticated;

commit;
