-- ============================================================================
--  COP'IQ — Dossier administrateur : extension User 360 (Phase A + B)
--  ---------------------------------------------------------------------------
--  Complète 20260818120000_community_admin_user_dossier.sql avec les données
--  utilisateur non encore couvertes : auth Supabase, badges, notifications,
--  favoris, appareils, signalements de contenu, photolangage, placement,
--  et détail des tentatives de cas pratique.
--
--  MÊMES PRINCIPES QUE LA MIGRATION DE RÉFÉRENCE :
--    • Toutes les fonctions sont SECURITY DEFINER et revalident le rôle admin
--      via public.community_admin_guard() (owner/admin/moderator).
--    • search_path = '' et références entièrement qualifiées.
--    • revoke from public, anon + grant execute to authenticated.
--    • Aucun mot de passe, hash, jeton ou secret n'est exposé.
--
--  AUCUNE TABLE, AUCUNE COLONNE N'EST CRÉÉE OU MODIFIÉE PAR CETTE MIGRATION.
--  Elle ne contient que des CREATE OR REPLACE FUNCTION : rejouable sans risque.
-- ============================================================================

-- ===========================================================================
--  1. AUTHENTIFICATION SUPABASE (auth.users) — champs sûrs uniquement
-- ===========================================================================
create or replace function public.community_admin_user_auth(p_user_id uuid)
returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare v_result jsonb;
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  select jsonb_build_object(
    'user_id',               au.id,
    'email',                 au.email,
    'phone',                 au.phone,
    'email_confirmed_at',    au.email_confirmed_at,
    'phone_confirmed_at',    au.phone_confirmed_at,
    'confirmation_sent_at',  au.confirmation_sent_at,
    'last_sign_in_at',       au.last_sign_in_at,
    'created_at',            au.created_at,
    'updated_at',            au.updated_at,
    'banned_until',          au.banned_until,
    'deleted_at',            au.deleted_at,
    'is_anonymous',          au.is_anonymous,
    'is_sso_user',           au.is_sso_user,
    'provider',              au.raw_app_meta_data->>'provider',
    'providers',             au.raw_app_meta_data->'providers'
  ) into v_result
  from auth.users au where au.id = p_user_id;

  if v_result is null then
    raise exception 'Utilisateur introuvable' using errcode = 'P0002';
  end if;
  return v_result;
end;
$$;

comment on function public.community_admin_user_auth(uuid) is
  'Champs sûrs de auth.users pour le dossier admin. Ne renvoie jamais mot de passe, jetons ou secrets.';


-- ===========================================================================
--  2. BADGES
-- ===========================================================================
create or replace function public.community_admin_user_badges(p_user_id uuid)
returns table(
  slug text, label text, description text, icon text, color_hex text,
  kind text, unlocked_at timestamptz, metadata jsonb
)
language plpgsql stable security definer set search_path = '' as $$
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  return query
  select b.slug, b.label, b.description, b.icon, b.color_hex, b.kind,
         ub.unlocked_at, ub.metadata
  from public.cas_pratique_user_badges ub
  join public.cas_pratique_badges b on b.slug = ub.badge_slug
  where ub.user_id = p_user_id
  order by ub.unlocked_at desc;
end;
$$;


-- ===========================================================================
--  3. NOTIFICATIONS
-- ===========================================================================
create or replace function public.community_admin_user_notifications(
  p_user_id uuid,
  p_unread_only boolean default null,
  p_limit integer default 20,
  p_offset integer default 0
) returns table(
  id uuid, type text, target_type text, target_id uuid,
  space_id text, space_label text, payload jsonb,
  created_at timestamptz, read_at timestamptz, total_count bigint
)
language plpgsql stable security definer set search_path = '' as $$
declare
  v_limit  integer := least(greatest(coalesce(p_limit, 20), 1), 100);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  return query
  select
    n.id, n.type, n.target_type, n.target_id, n.space_id,
    (select s.label from public.community_spaces s where s.id = n.space_id),
    n.payload, n.created_at, n.read_at,
    count(*) over()
  from public.community_notifications n
  where n.recipient_id = p_user_id
    and (p_unread_only is null or (p_unread_only and n.read_at is null) or (not p_unread_only and n.read_at is not null))
  order by n.created_at desc
  limit v_limit offset v_offset;
end;
$$;


-- ===========================================================================
--  4. FAVORIS (bookmarks communauté)
-- ===========================================================================
create or replace function public.community_admin_user_favorites(
  p_user_id uuid,
  p_limit   integer default 20,
  p_offset  integer default 0
) returns table(
  post_id uuid, post_title text, post_status text,
  space_id text, space_label text,
  created_at timestamptz, total_count bigint
)
language plpgsql stable security definer set search_path = '' as $$
declare
  v_limit  integer := least(greatest(coalesce(p_limit, 20), 1), 100);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  return query
  select
    bk.post_id, p.title, p.status, p.space_id,
    (select s.label from public.community_spaces s where s.id = p.space_id),
    bk.created_at, count(*) over()
  from public.community_bookmarks bk
  left join public.community_posts p on p.id = bk.post_id
  where bk.user_id = p_user_id
  order by bk.created_at desc
  limit v_limit offset v_offset;
end;
$$;


-- ===========================================================================
--  5. APPAREILS — jeton FCM masqué
-- ===========================================================================
create or replace function public.community_admin_user_devices(p_user_id uuid)
returns table(
  id bigint, platform text, app_version text,
  token_masked text, created_at timestamptz, updated_at timestamptz
)
language plpgsql stable security definer set search_path = '' as $$
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  return query
  select
    d.id, d.platform, d.app_version,
    case when d.fcm_token is null then null
         else '••••••' || right(d.fcm_token, 6) end,
    d.created_at, d.updated_at
  from public.user_devices d
  where d.user_id = p_user_id
  order by d.updated_at desc;
end;
$$;


-- ===========================================================================
--  6. SIGNALEMENTS DE CONTENU (distincts des signalements communautaires)
--     Fusionne report_question, report_culture_generale, cas_pratique_question_reports.
-- ===========================================================================
create or replace function public.community_admin_user_content_reports(
  p_user_id uuid,
  p_limit   integer default 20,
  p_offset  integer default 0
) returns table(
  source text, id text, created_at timestamptz,
  report_type text, category text, content text, status text,
  total_count bigint
)
language plpgsql stable security definer set search_path = '' as $$
declare
  v_limit  integer := least(greatest(coalesce(p_limit, 20), 1), 100);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
  v_uid_text text := p_user_id::text;
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  return query
  with unioned as (
    select 'quiz'::text as source, rq.id::text, rq.created_at,
           rq.report_type, rq.question_category as category,
           (coalesce(rq.report_message, '') || ' — ' || left(coalesce(rq.question_text, ''), 150))::text as content,
           rq.status
    from public.report_question rq
    where rq.user_uid = v_uid_text

    union all
    select 'culture_generale'::text, rcg.id::text, rcg.created_at,
           rcg.report_type, rcg.category,
           (coalesce(rcg.message, '') || ' — ' || left(coalesce(rcg.question, ''), 150))::text,
           rcg.status
    from public.report_culture_generale rcg
    where rcg.user_uid = v_uid_text

    union all
    select 'cas_pratique'::text, cpr.id::text, cpr.created_at,
           cpr.report_type, null::text,
           cpr.message, cpr.status
    from public.cas_pratique_question_reports cpr
    where cpr.user_id = p_user_id
  )
  select u.*, count(*) over()
  from unioned u
  order by u.created_at desc
  limit v_limit offset v_offset;
end;
$$;


-- ===========================================================================
--  7. PHOTOLANGAGE
-- ===========================================================================
create or replace function public.community_admin_user_photolangage(
  p_user_id uuid,
  p_limit   integer default 20,
  p_offset  integer default 0
) returns table(
  id uuid, case_id text, status text, correction_status text,
  character_count integer, word_count integer,
  elapsed_seconds integer, pedagogical_score integer,
  started_at timestamptz, submitted_at timestamptz,
  total_count bigint
)
language plpgsql stable security definer set search_path = '' as $$
declare
  v_limit  integer := least(greatest(coalesce(p_limit, 20), 1), 100);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  return query
  select
    a.id, a.case_id, a.status, a.correction_status,
    a.character_count, a.word_count, a.elapsed_seconds, a.pedagogical_score,
    a.started_at, a.submitted_at, count(*) over()
  from public.photolangage_attempts a
  where a.user_id = p_user_id
  order by a.created_at desc
  limit v_limit offset v_offset;
end;
$$;


-- ===========================================================================
--  8. TEST DE PLACEMENT (orientation initiale)
-- ===========================================================================
create or replace function public.community_admin_user_placement(p_user_id uuid)
returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare v_result jsonb;
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  select jsonb_build_object(
    'results', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', r.id, 'total_score', r.total_score, 'max_score', r.max_score,
        'score_pct', r.score_pct, 'created_at', r.created_at
      ) order by r.created_at desc)
      from public.placement_results r where r.user_id = p_user_id
    ), '[]'::jsonb),
    'by_domain', coalesce((
      select jsonb_agg(jsonb_build_object(
        'domain', d.domain, 'total', d.total, 'correct', d.correct
      ))
      from (
        select a.domain, count(*) as total,
               count(*) filter (where a.is_correct) as correct
        from public.placement_answers a
        where a.user_id = p_user_id
        group by a.domain
      ) d
    ), '[]'::jsonb)
  ) into v_result;

  return v_result;
end;
$$;


-- ===========================================================================
--  9. CAS PRATIQUE — détail des tentatives (Phase B)
-- ===========================================================================
create or replace function public.community_admin_user_cp_attempts(
  p_user_id uuid,
  p_limit   integer default 20,
  p_offset  integer default 0
) returns table(
  id uuid, case_id text, status text, is_completed boolean,
  started_at timestamptz, finished_at timestamptz, time_spent_ms bigint,
  total_score numeric, total_max numeric, percent numeric,
  correction_percent numeric, xp_delta bigint,
  total_count bigint
)
language plpgsql stable security definer set search_path = '' as $$
declare
  v_limit  integer := least(greatest(coalesce(p_limit, 20), 1), 100);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  return query
  select
    a.id, a.case_id, a.status, a.is_completed,
    a.started_at, a.finished_at, a.time_spent_ms,
    a.total_score, a.total_max, a.percent,
    (select c.percent from public.cas_pratique_corrections c where c.attempt_id = a.id order by c.evaluated_at desc limit 1),
    (select coalesce(sum(x.delta), 0)::bigint from public.cas_pratique_xp_ledger x where x.attempt_id = a.id),
    count(*) over()
  from public.cas_pratique_attempts a
  where a.user_id = p_user_id
  order by a.created_at desc
  limit v_limit offset v_offset;
end;
$$;


-- ===========================================================================
--  10. FICHE PRINCIPALE — compteurs additionnels (remplace 20260818120000)
-- ===========================================================================
create or replace function public.community_admin_user_detail(p_user_id uuid)
returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare v_result jsonb;
begin
  perform public.community_admin_guard();
  if p_user_id is null then
    raise exception 'Utilisateur obligatoire' using errcode = '22023';
  end if;

  select jsonb_build_object(

    /* ---- Profil ------------------------------------------------------- */
    'profile', jsonb_build_object(
      'user_id',         u.user_id,
      'email',           u.email,
      'username',        u.username,
      'first_name',      u.first_name,
      'last_name',       u.last_name,
      'avatar_index',    u.avatar_index,
      'city',            u.city,
      'phone',           u.phone,
      'birthday',        u.birthday,
      'user_role',       u.role::text,
      'user_track',      u.user_track,
      'user_mode',       u.user_mode,
      'has_passed_exam', u.has_passed_exam,
      'cgv_accepted',    u.cgv_accepted,
      'cgv_accepted_at', u.cgv_accepted_at,
      'created_at',      u.created_at,
      'updated_at',      u.updated_at
    ),

    /* ---- Préférences applicatives ------------------------------------- */
    'settings', coalesce((
      select jsonb_build_object(
        'locale',             s.locale,
        'theme_dark',         s.theme_dark,
        'onboarding_done_at', s.onboarding_done_at,
        'updated_at',         s.updated_at
      )
      from public.user_settings s where s.user_id = u.user_id
    ), '{}'::jsonb),

    /* ---- Profil communautaire ----------------------------------------- */
    'community_profile', coalesce((
      select jsonb_build_object(
        'bio',               cp.bio,
        'show_activity',     cp.show_activity,
        'show_joined_at',    cp.show_joined_at,
        'show_spaces',       cp.show_spaces,
        'show_display_name', cp.show_display_name,
        'created_at',        cp.created_at
      )
      from public.community_profiles cp where cp.user_id = u.user_id
    ), '{}'::jsonb),

    /* ---- Staff : ce compte est-il lui-même administrateur ? ------------ */
    'staff', coalesce((
      select jsonb_build_object(
        'role',                 a.role,
        'disabled',             a.disabled,
        'last_admin_login_at',  a.last_admin_login_at,
        'expires_at',           a.expires_at
      )
      from public.admin_users a where a.auth_uid = u.user_id limit 1
    ), '{}'::jsonb),

    /* ---- Abonnement courant (sans identifiants Stripe) ---------------- */
    'subscription', coalesce((
      select to_jsonb(b) - 'stripe_customer_id' - 'stripe_subscription_id'
      from public.billing_subscriptions b
      where b.user_id = u.user_id
      order by b.updated_at desc nulls last limit 1
    ), '{}'::jsonb),

    /* ---- Compteurs : tous calculés, aucun en dur ----------------------- */
    'activity', jsonb_build_object(
      'posts',            (select count(*) from public.community_posts p
                             where p.author_id = u.user_id),
      'posts_visible',    (select count(*) from public.community_posts p
                             where p.author_id = u.user_id and p.deleted_at is null),
      'comments',         (select count(*) from public.community_comments c
                             where c.author_id = u.user_id),
      'comments_visible', (select count(*) from public.community_comments c
                             where c.author_id = u.user_id and c.deleted_at is null),
      'messages',         (select count(*) from public.community_messages m
                             where m.sender_id = u.user_id),
      'rooms',            (select count(*) from public.community_room_members rm
                             where rm.user_id = u.user_id and rm.left_at is null),
      'reactions_given',  (select count(*) from public.community_reactions r
                             where r.user_id = u.user_id),
      'reports_received', (select count(*) from public.community_reports r
                             where r.subject_user_id = u.user_id),
      'reports_sent',     (select count(*) from public.community_reports r
                             where r.reporter_id = u.user_id),
      'reports_open',     (select count(*) from public.community_reports r
                             where r.subject_user_id = u.user_id
                               and r.status in ('new','triaged','in_progress','appealed')),
      'sanctions_total',  (select count(*) from public.community_sanctions s
                             where s.user_id = u.user_id),
      'sanctions_active', (select count(*) from public.community_sanctions s
                             where s.user_id = u.user_id and s.status = 'active'
                               and (s.ends_at is null or s.ends_at > now())),
      'quiz_answers',     (select count(*) from public.quiz_answer_history q
                             where q.user_id = u.user_id),
      'psy_tests',        (select count(*) from public.tests_psychotechnique_history t
                             where t.user_id = u.user_id),
      'cp_attempts',      (select count(*) from public.cas_pratique_attempts a
                             where a.user_id = u.user_id),
      'invoices',         (select count(*) from public.billing_invoices i
                             where i.user_id = u.user_id),
      -- Phase A : nouveaux compteurs, tous calculés en base.
      'badges',              (select count(*) from public.cas_pratique_user_badges ub
                                 where ub.user_id = u.user_id),
      'notifications',       (select count(*) from public.community_notifications n
                                 where n.recipient_id = u.user_id),
      'notifications_unread',(select count(*) from public.community_notifications n
                                 where n.recipient_id = u.user_id and n.read_at is null),
      'favorites',            (select count(*) from public.community_bookmarks bk
                                 where bk.user_id = u.user_id),
      'devices',              (select count(*) from public.user_devices d
                                 where d.user_id = u.user_id),
      'photolangage_attempts',(select count(*) from public.photolangage_attempts p
                                 where p.user_id = u.user_id),
      'placement_done',       (select count(*) > 0 from public.placement_results r
                                 where r.user_id = u.user_id),
      'content_reports',      (
        (select count(*) from public.report_question rq where rq.user_uid = u.user_id::text) +
        (select count(*) from public.report_culture_generale rcg where rcg.user_uid = u.user_id::text) +
        (select count(*) from public.cas_pratique_question_reports cpr where cpr.user_id = u.user_id)
      )
    ),

    /* ---- Synthèse quiz ------------------------------------------------- */
    'quiz_summary', coalesce((
      select jsonb_build_object(
        'answers',    count(*),
        'correct',    count(*) filter (where q.is_correct),
        'wrong',      count(*) filter (where q.is_correct is false),
        'accuracy',   round(
                        100.0 * count(*) filter (where q.is_correct)
                        / nullif(count(*), 0), 1),
        'modules',    count(distinct q.module_key),
        'first_at',   min(q.answered_at),
        'last_at',    max(q.answered_at)
      )
      from public.quiz_answer_history q where q.user_id = u.user_id
    ), '{}'::jsonb),

    /* ---- Progression cas pratique -------------------------------------- */
    'cp_progress', coalesce((
      select to_jsonb(pr) from public.cas_pratique_user_progress pr
      where pr.user_id = u.user_id
    ), '{}'::jsonb),

    /* ---- Dernière activité observable ---------------------------------- */
    'last_activity', (
      select max(ts) from (
        select max(p.created_at)  as ts from public.community_posts p     where p.author_id = u.user_id
        union all
        select max(c.created_at)        from public.community_comments c  where c.author_id = u.user_id
        union all
        select max(m.created_at)        from public.community_messages m  where m.sender_id = u.user_id
        union all
        select max(q.answered_at)       from public.quiz_answer_history q where q.user_id  = u.user_id
        union all
        select max(a.created_at)        from public.cas_pratique_attempts a where a.user_id = u.user_id
        union all
        select u.updated_at
      ) t
    ),

    /* ---- Sanctions (historique complet) -------------------------------- */
    'sanctions', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', s.id, 'space_id', s.space_id, 'kind', s.kind,
        'reason', s.reason, 'starts_at', s.starts_at, 'ends_at', s.ends_at,
        'status', case
                    when s.status = 'active' and s.ends_at is not null and s.ends_at <= now()
                    then 'expired' else s.status
                  end,
        'created_at', s.created_at, 'revoked_at', s.revoked_at,
        'imposed_by', s.imposed_by, 'revoked_by', s.revoked_by,
        'imposed_by_email', (select a.email from public.admin_users a where a.auth_uid = s.imposed_by limit 1),
        'revoked_by_email', (select a.email from public.admin_users a where a.auth_uid = s.revoked_by limit 1),
        'space_label',      (select sp.label from public.community_spaces sp where sp.id = s.space_id)
      ) order by s.created_at desc)
      from public.community_sanctions s where s.user_id = u.user_id
    ), '[]'::jsonb)

  ) into v_result
  from public.user_profiles u where u.user_id = p_user_id;

  if v_result is null then
    raise exception 'Utilisateur introuvable' using errcode = 'P0002';
  end if;
  return v_result;
end;
$$;


-- ===========================================================================
--  11. TIMELINE — sources additionnelles (remplace 20260818120000)
-- ===========================================================================
create or replace function public.community_admin_user_timeline(
  p_user_id uuid,
  p_limit   integer default 40,
  p_offset  integer default 0
) returns table(
  occurred_at timestamptz,
  kind text,
  label text,
  detail text,
  ref_type text,
  ref_id text
)
language plpgsql stable security definer set search_path = '' as $$
declare
  v_limit  integer := least(greatest(coalesce(p_limit, 40), 1), 200);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
  v_cap    integer := v_limit + v_offset;
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  return query
  with events(occurred_at, kind, label, detail, ref_type, ref_id) as (
    select u.created_at, 'account_created'::text,
           'Création du compte'::text,
           u.email::text, 'user'::text, u.user_id::text
    from public.user_profiles u where u.user_id = p_user_id

    union all
    select * from (
      select p.created_at, 'post'::text, 'Publication'::text,
             coalesce(p.title, left(coalesce(p.content, ''), 120))::text,
             'post'::text, p.id::text
      from public.community_posts p
      where p.author_id = p_user_id
      order by p.created_at desc limit v_cap
    ) p_evt

    union all
    select * from (
      select c.created_at, 'comment'::text, 'Réponse'::text,
             left(coalesce(c.content, ''), 120)::text,
             'comment'::text, c.id::text
      from public.community_comments c
      where c.author_id = p_user_id
      order by c.created_at desc limit v_cap
    ) c_evt

    union all
    select * from (
      select m.created_at, 'message'::text, 'Message privé'::text,
             ('Salon · ' || coalesce(rm.title, 'sans titre'))::text,
             'message'::text, m.id::text
      from public.community_messages m
      left join public.community_rooms rm on rm.id = m.room_id
      where m.sender_id = p_user_id
      order by m.created_at desc limit v_cap
    ) m_evt

    union all
    select r.created_at, 'report_received'::text, 'Signalement reçu'::text,
           (r.reason || coalesce(' · ' || r.status, ''))::text,
           'report'::text, r.id::text
    from public.community_reports r where r.subject_user_id = p_user_id

    union all
    select r.created_at, 'report_sent'::text, 'Signalement émis'::text,
           (r.reason || coalesce(' · ' || r.status, ''))::text,
           'report'::text, r.id::text
    from public.community_reports r where r.reporter_id = p_user_id

    union all
    select s.created_at, 'sanction'::text, 'Sanction appliquée'::text,
           (s.kind || ' · ' || s.reason)::text,
           'sanction'::text, s.id::text
    from public.community_sanctions s where s.user_id = p_user_id

    union all
    select s.revoked_at, 'sanction_revoked'::text, 'Sanction levée'::text,
           s.kind::text, 'sanction'::text, s.id::text
    from public.community_sanctions s
    where s.user_id = p_user_id and s.revoked_at is not null

    union all
    select * from (
      select a.created_at, 'cp_attempt'::text, 'Cas pratique'::text,
             (a.case_id || coalesce(' · ' || round(a.percent, 0)::text || ' %', ''))::text,
             'cp_attempt'::text, a.id::text
      from public.cas_pratique_attempts a
      where a.user_id = p_user_id
      order by a.created_at desc limit v_cap
    ) a_evt

    union all
    select * from (
      select t.created_at at time zone 'UTC', 'psy_test'::text, 'Test psychotechnique'::text,
             (t.module || ' · ' || coalesce(t.score, 0)::text || '/' || coalesce(t.total_questions, 0)::text)::text,
             'psy_test'::text, t.id::text
      from public.tests_psychotechnique_history t
      where t.user_id = p_user_id
      order by t.created_at desc limit v_cap
    ) t_evt

    union all
    select b.created_at, 'subscription'::text, 'Abonnement'::text,
           (coalesce(b.plan, 'inconnu') || ' · ' || coalesce(b.status, 'inconnu'))::text,
           'subscription'::text, b.id::text
    from public.billing_subscriptions b where b.user_id = p_user_id

    union all
    select * from (
      select i.created_at, 'invoice'::text, 'Facture'::text,
             (coalesce(i.invoice_number, '—') || ' · '
              || round(coalesce(i.amount_cents, 0) / 100.0, 2)::text || ' '
              || upper(coalesce(i.currency, 'eur')))::text,
             'invoice'::text, i.id::text
      from public.billing_invoices i
      where i.user_id = p_user_id
      order by i.created_at desc limit v_cap
    ) i_evt

    union all
    select * from (
      select l.created_at, 'moderation'::text, 'Action de modération'::text,
             (l.action || coalesce(' · ' || l.reason, ''))::text,
             'moderation'::text, l.id::text
      from public.community_moderation_log l
      where l.target_type = 'user' and l.target_id = p_user_id::text
      order by l.created_at desc limit v_cap
    ) l_evt

    -- Phase A : nouvelles sources.
    union all
    select * from (
      select ub.unlocked_at, 'badge'::text, 'Badge débloqué'::text,
             b.label, 'badge'::text, b.slug
      from public.cas_pratique_user_badges ub
      join public.cas_pratique_badges b on b.slug = ub.badge_slug
      where ub.user_id = p_user_id
      order by ub.unlocked_at desc limit v_cap
    ) b_evt

    union all
    select * from (
      select coalesce(a.submitted_at, a.created_at), 'photolangage'::text, 'Photolangage'::text,
             (a.case_id || coalesce(' · ' || a.pedagogical_score::text || ' pts', ''))::text,
             'photolangage'::text, a.id::text
      from public.photolangage_attempts a
      where a.user_id = p_user_id
      order by coalesce(a.submitted_at, a.created_at) desc limit v_cap
    ) ph_evt

    union all
    select r.created_at, 'placement'::text, 'Test de placement'::text,
           (round(coalesce(r.score_pct, 0), 0)::text || ' %')::text,
           'placement'::text, r.id::text
    from public.placement_results r where r.user_id = p_user_id
  )
  select e.occurred_at, e.kind, e.label, e.detail, e.ref_type, e.ref_id
  from events e
  where e.occurred_at is not null
  order by e.occurred_at desc
  limit v_limit offset v_offset;
end;
$$;


-- ===========================================================================
--  12. PERMISSIONS
-- ===========================================================================
revoke all on function public.community_admin_user_auth(uuid) from public, anon;
revoke all on function public.community_admin_user_badges(uuid) from public, anon;
revoke all on function public.community_admin_user_notifications(uuid,boolean,integer,integer) from public, anon;
revoke all on function public.community_admin_user_favorites(uuid,integer,integer) from public, anon;
revoke all on function public.community_admin_user_devices(uuid) from public, anon;
revoke all on function public.community_admin_user_content_reports(uuid,integer,integer) from public, anon;
revoke all on function public.community_admin_user_photolangage(uuid,integer,integer) from public, anon;
revoke all on function public.community_admin_user_placement(uuid) from public, anon;
revoke all on function public.community_admin_user_cp_attempts(uuid,integer,integer) from public, anon;
revoke all on function public.community_admin_user_detail(uuid) from public, anon;
revoke all on function public.community_admin_user_timeline(uuid,integer,integer) from public, anon;

grant execute on function public.community_admin_user_auth(uuid) to authenticated;
grant execute on function public.community_admin_user_badges(uuid) to authenticated;
grant execute on function public.community_admin_user_notifications(uuid,boolean,integer,integer) to authenticated;
grant execute on function public.community_admin_user_favorites(uuid,integer,integer) to authenticated;
grant execute on function public.community_admin_user_devices(uuid) to authenticated;
grant execute on function public.community_admin_user_content_reports(uuid,integer,integer) to authenticated;
grant execute on function public.community_admin_user_photolangage(uuid,integer,integer) to authenticated;
grant execute on function public.community_admin_user_placement(uuid) to authenticated;
grant execute on function public.community_admin_user_cp_attempts(uuid,integer,integer) to authenticated;
grant execute on function public.community_admin_user_detail(uuid) to authenticated;
grant execute on function public.community_admin_user_timeline(uuid,integer,integer) to authenticated;

comment on function public.community_admin_user_notifications(uuid,boolean,integer,integer) is
  'Notifications communauté reçues par l''utilisateur, paginées, filtrables par lu/non lu.';
comment on function public.community_admin_user_content_reports(uuid,integer,integer) is
  'Signalements de contenu (quiz, culture générale, cas pratique) émis par l''utilisateur — distinct des signalements communautaires.';
comment on function public.community_admin_user_cp_attempts(uuid,integer,integer) is
  'Détail des tentatives de cas pratique : score, correction, delta XP, durée.';
