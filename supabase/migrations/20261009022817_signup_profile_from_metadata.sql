-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║  COP'IQ — Profil complet dès l'inscription (site copiq.fr)                ║
-- ║                                                                           ║
-- ║  L'inscription web collecte désormais le profil exigé par l'application   ║
-- ║  (Profile.isComplete dans lib/features/home/profil_page.dart) :           ║
-- ║  prénom, nom, ville, mobile 06/07, pseudo, avatar 1–20, date de           ║
-- ║  naissance facultative, plus le parcours (user_track / user_mode).        ║
-- ║  Ces valeurs arrivent dans raw_user_meta_data ; le trigger les recopie    ║
-- ║  dans user_profiles pour qu'un compte créé sur le site s'ouvre            ║
-- ║  directement sur la bonne home dans l'application.                        ║
-- ║                                                                           ║
-- ║  Garanties :                                                              ║
-- ║   - chaque valeur est revalidée ici (mêmes règles que l'app et que les    ║
-- ║     contraintes de la table) ; une valeur invalide est ignorée, jamais    ║
-- ║     bloquante ;                                                           ║
-- ║   - pseudo déjà pris → laissé vide (l'app le redemandera) ;               ║
-- ║   - user_mode limité à exam / school (jamais « active », qui exige une    ║
-- ║     vérification), role jamais lu depuis les métadonnées ;                ║
-- ║   - une valeur déjà présente en base n'est jamais écrasée ;               ║
-- ║   - inscription depuis l'app : métadonnées sans profil → comportement     ║
-- ║     strictement identique à la version précédente ;                       ║
-- ║   - toute erreur inattendue retombe sur l'insertion minimale d'origine :  ║
-- ║     la création du compte ne peut pas échouer à cause du profil.          ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝

create or replace function public.handle_new_user_minimal()
returns trigger
language plpgsql
security definer
set search_path to 'public', 'auth'
as $function$
declare
  m jsonb := coalesce(new.raw_user_meta_data, '{}'::jsonb);
  v_cgv_accepted boolean := false;
  v_cgv_version text := nullif(m->>'cgv_version', '');
  v_client_at timestamptz;
  v_platform text := nullif(m->>'platform', '');

  v_first text := left(btrim(regexp_replace(coalesce(m->>'first_name', ''), '\s+', ' ', 'g')), 60);
  v_last text := left(btrim(regexp_replace(coalesce(m->>'last_name', ''), '\s+', ' ', 'g')), 60);
  v_city text := left(btrim(regexp_replace(coalesce(m->>'city', ''), '\s+', ' ', 'g')), 80);
  v_phone text := regexp_replace(coalesce(m->>'phone', ''), '[^0-9]', '', 'g');
  v_username text := nullif(btrim(coalesce(m->>'username', '')), '');
  v_birthday date;
  v_avatar integer := 1;
  v_track text := lower(nullif(btrim(coalesce(m->>'user_track', '')), ''));
  v_mode text := lower(nullif(btrim(coalesce(m->>'user_mode', '')), ''));
begin
  begin
    v_cgv_accepted := coalesce((m->>'cgv_accepted')::boolean, false);
  exception when others then
    v_cgv_accepted := false;
  end;

  begin
    v_client_at := nullif(m->>'cgv_accepted_client_at', '')::timestamptz;
  exception when others then
    v_client_at := null;
  end;

  -- ── Validation du profil (mêmes règles que l'application) ──────────────
  if v_phone !~ '^(06|07)[0-9]{8}$' then
    v_phone := '';
  end if;

  if v_username is not null and (
       v_username !~ '^[A-Za-z][A-Za-z0-9_]{2,19}$'
       or exists (
         select 1 from public.user_profiles p
         where lower(p.username) = lower(v_username) and p.user_id <> new.id
       )
     ) then
    v_username := null;
  end if;

  begin
    v_birthday := nullif(m->>'birthday', '')::date;
    if v_birthday < date '1920-01-01' or v_birthday > current_date then
      v_birthday := null;
    end if;
  exception when others then
    v_birthday := null;
  end;

  begin
    v_avatar := coalesce(nullif(m->>'avatar_index', '')::integer, 1);
  exception when others then
    v_avatar := 1;
  end;
  if v_avatar not between 1 and 20 then
    v_avatar := 1;
  end if;

  if v_track is not null and v_track not in ('pa', 'gpx') then
    v_track := null;
  end if;
  if v_mode is null or v_mode not in ('exam', 'school') then
    v_mode := 'exam';
  end if;

  -- ── Profil complet ─────────────────────────────────────────────────────
  begin
    insert into public.user_profiles (
      user_id, email, first_name, last_name, city, phone, username, birthday,
      avatar_index, user_mode, user_track, role, cgv_accepted,
      cgv_accepted_at, cgv_version, cgv_acceptance_source, cgv_recorded_at,
      created_at, updated_at
    ) values (
      new.id, new.email, v_first, v_last, v_city, v_phone, v_username, v_birthday,
      v_avatar, v_mode, v_track, 'user', v_cgv_accepted,
      case when v_cgv_accepted then coalesce(v_client_at, now()) end,
      case when v_cgv_accepted then coalesce(v_cgv_version, '2026-08') end,
      case when v_cgv_accepted then 'explicit_signup' end,
      case when v_cgv_accepted then now() end,
      now(), now()
    )
    on conflict (user_id) do update set
      email = excluded.email,
      first_name = case when coalesce(public.user_profiles.first_name, '') = '' then excluded.first_name else public.user_profiles.first_name end,
      last_name = case when coalesce(public.user_profiles.last_name, '') = '' then excluded.last_name else public.user_profiles.last_name end,
      city = case when coalesce(public.user_profiles.city, '') = '' then excluded.city else public.user_profiles.city end,
      phone = case when coalesce(public.user_profiles.phone, '') = '' then excluded.phone else public.user_profiles.phone end,
      username = coalesce(nullif(public.user_profiles.username, ''), excluded.username),
      birthday = coalesce(public.user_profiles.birthday, excluded.birthday),
      user_track = coalesce(public.user_profiles.user_track, excluded.user_track),
      cgv_accepted = public.user_profiles.cgv_accepted or excluded.cgv_accepted,
      cgv_accepted_at = coalesce(public.user_profiles.cgv_accepted_at, excluded.cgv_accepted_at),
      cgv_version = coalesce(public.user_profiles.cgv_version, excluded.cgv_version),
      cgv_acceptance_source = coalesce(public.user_profiles.cgv_acceptance_source, excluded.cgv_acceptance_source),
      cgv_recorded_at = coalesce(public.user_profiles.cgv_recorded_at, excluded.cgv_recorded_at),
      updated_at = now();
  exception when others then
    -- Filet de sécurité : insertion minimale d'origine (avant ce correctif).
    raise warning '[handle_new_user_minimal] profil depuis métadonnées ignoré pour % : %', new.id, sqlerrm;
    insert into public.user_profiles (
      user_id, email, avatar_index, user_mode, role, cgv_accepted,
      cgv_accepted_at, cgv_version, cgv_acceptance_source, cgv_recorded_at,
      created_at, updated_at
    ) values (
      new.id, new.email, 1, 'exam', 'user', v_cgv_accepted,
      case when v_cgv_accepted then coalesce(v_client_at, now()) end,
      case when v_cgv_accepted then coalesce(v_cgv_version, '2026-08') end,
      case when v_cgv_accepted then 'explicit_signup' end,
      case when v_cgv_accepted then now() end,
      now(), now()
    )
    on conflict (user_id) do update set
      email = excluded.email,
      cgv_accepted = public.user_profiles.cgv_accepted or excluded.cgv_accepted,
      cgv_accepted_at = coalesce(public.user_profiles.cgv_accepted_at, excluded.cgv_accepted_at),
      cgv_version = coalesce(public.user_profiles.cgv_version, excluded.cgv_version),
      cgv_acceptance_source = coalesce(public.user_profiles.cgv_acceptance_source, excluded.cgv_acceptance_source),
      cgv_recorded_at = coalesce(public.user_profiles.cgv_recorded_at, excluded.cgv_recorded_at),
      updated_at = now();
  end;

  if v_cgv_accepted then
    insert into public.cgv_consent_events (
      user_id, cgv_version, accepted_at_client, source, platform
    ) values (
      new.id, coalesce(v_cgv_version, '2026-08'), v_client_at,
      'explicit_signup', v_platform
    ) on conflict (user_id, cgv_version) do nothing;
  end if;
  return new;
end;
$function$;
