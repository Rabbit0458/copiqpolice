-- ============================================================================
--  COP'IQ — Dossier administrateur complet d'un utilisateur
--  ---------------------------------------------------------------------------
--  Étend `community_admin_user_detail` et ajoute les RPC paginées permettant
--  au panel d'ouvrir chaque compteur (publications, réponses, messages,
--  signalements, quiz, activité, facturation).
--
--  PRINCIPES CONSERVÉS DE LA MIGRATION 20260803062000 :
--    • Toutes les fonctions sont SECURITY DEFINER mais revalident le rôle admin
--      via public.has_admin_role('owner','admin','moderator').
--    • search_path = '' et références entièrement qualifiées.
--    • revoke from public, anon + grant execute to authenticated.
--    • Aucun identifiant Stripe, aucun secret, aucun hash n'est exposé.
--    • Le CONTENU des messages privés reste masqué : il n'est révélé que pour
--      les messages déjà capturés comme pièce jointe d'un signalement
--      (community_message_report_evidence), c'est-à-dire déjà légitimement
--      versés au dossier de modération.
--
--  AUCUNE TABLE, AUCUNE COLONNE N'EST CRÉÉE OU MODIFIÉE PAR CETTE MIGRATION.
--  Elle ne contient que des CREATE OR REPLACE FUNCTION : rejouable sans risque.
-- ============================================================================

-- ---------------------------------------------------------------------------
--  Garde commune
-- ---------------------------------------------------------------------------
create or replace function public.community_admin_guard()
returns void language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.has_admin_role('owner','admin','moderator') then
    raise exception 'Accès refusé' using errcode = '42501';
  end if;
end;
$$;

comment on function public.community_admin_guard() is
  'Garde partagée des RPC de dossier utilisateur : rôle owner/admin/moderator obligatoire.';


-- ===========================================================================
--  1. FICHE PRINCIPALE (remplace la version de 20260803062000)
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
      -- statuts réels de community_reports_status_check :
      -- new / triaged / in_progress / resolved / rejected / appealed
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
                             where i.user_id = u.user_id)
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
--  2. PUBLICATIONS
-- ===========================================================================
create or replace function public.community_admin_user_posts(
  p_user_id uuid,
  p_search  text default null,
  p_status  text default null,
  p_limit   integer default 20,
  p_offset  integer default 0
) returns table(
  id uuid, space_id text, space_label text, category_label text,
  type text, title text, content text, status text,
  is_pinned boolean, is_resolved boolean,
  reaction_count integer, comment_count integer,
  share_count integer, view_count integer,
  created_at timestamptz, edited_at timestamptz, deleted_at timestamptz,
  reports_count bigint, total_count bigint
)
language plpgsql stable security definer set search_path = '' as $$
declare
  v_limit  integer := least(greatest(coalesce(p_limit, 20), 1), 100);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
  v_search text    := nullif(trim(coalesce(p_search, '')), '');
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  return query
  select
    p.id, p.space_id,
    (select s.label from public.community_spaces s where s.id = p.space_id),
    (select c.label from public.community_categories c where c.id = p.category_id),
    p.type, p.title, p.content, p.status,
    p.is_pinned, p.is_resolved,
    p.reaction_count, p.comment_count, p.share_count, p.view_count,
    p.created_at, p.edited_at, p.deleted_at,
    (select count(*) from public.community_reports r
       where r.target_type = 'post' and r.target_id = p.id),
    count(*) over()
  from public.community_posts p
  where p.author_id = p_user_id
    and (p_status is null or p.status = p_status)
    and (
      v_search is null
      or p.title   ilike '%' || v_search || '%'
      or p.content ilike '%' || v_search || '%'
    )
  order by p.created_at desc
  limit v_limit offset v_offset;
end;
$$;


-- ===========================================================================
--  3. RÉPONSES / COMMENTAIRES
-- ===========================================================================
create or replace function public.community_admin_user_comments(
  p_user_id uuid,
  p_search  text default null,
  p_status  text default null,
  p_limit   integer default 20,
  p_offset  integer default 0
) returns table(
  id uuid, post_id uuid, post_title text, space_id text, space_label text,
  content text, status text, is_solution boolean,
  reaction_count integer, reply_count integer,
  created_at timestamptz, edited_at timestamptz, deleted_at timestamptz,
  is_reply boolean, reports_count bigint, total_count bigint
)
language plpgsql stable security definer set search_path = '' as $$
declare
  v_limit  integer := least(greatest(coalesce(p_limit, 20), 1), 100);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
  v_search text    := nullif(trim(coalesce(p_search, '')), '');
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  return query
  select
    c.id, c.post_id, p.title, p.space_id,
    (select s.label from public.community_spaces s where s.id = p.space_id),
    c.content, c.status, c.is_solution,
    c.reaction_count, c.reply_count,
    c.created_at, c.edited_at, c.deleted_at,
    (c.parent_id is not null),
    (select count(*) from public.community_reports r
       where r.target_type = 'comment' and r.target_id = c.id),
    count(*) over()
  from public.community_comments c
  left join public.community_posts p on p.id = c.post_id
  where c.author_id = p_user_id
    and (p_status is null or c.status = p_status)
    and (v_search is null or c.content ilike '%' || v_search || '%')
  order by c.created_at desc
  limit v_limit offset v_offset;
end;
$$;


-- ===========================================================================
--  4. MESSAGES PRIVÉS — métadonnées seules
--     Le contenu n'est renvoyé que si le message a déjà été versé comme
--     pièce à un signalement (community_message_report_evidence).
-- ===========================================================================
create or replace function public.community_admin_user_messages(
  p_user_id uuid,
  p_limit   integer default 20,
  p_offset  integer default 0
) returns table(
  id uuid, room_id uuid, room_title text, room_kind text,
  space_id text, space_label text,
  type text, status text,
  content_length integer,
  disclosed_content text,
  is_evidence boolean,
  created_at timestamptz, edited_at timestamptz, deleted_at timestamptz,
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
    m.id, m.room_id, r.title, r.kind, r.space_id,
    (select s.label from public.community_spaces s where s.id = r.space_id),
    m.type, m.status,
    char_length(coalesce(m.content, '')),
    ev.content,
    (ev.content is not null),
    m.created_at, m.edited_at, m.deleted_at,
    count(*) over()
  from public.community_messages m
  left join public.community_rooms r on r.id = m.room_id
  left join lateral (
    select e.content from public.community_message_report_evidence e
    where e.source_message_id = m.id limit 1
  ) ev on true
  where m.sender_id = p_user_id
  order by m.created_at desc
  limit v_limit offset v_offset;
end;
$$;


-- ===========================================================================
--  5. SIGNALEMENTS (reçus ou émis)
-- ===========================================================================
create or replace function public.community_admin_user_reports(
  p_user_id   uuid,
  p_direction text default 'received',
  p_status    text default null,
  p_limit     integer default 20,
  p_offset    integer default 0
) returns table(
  id uuid, direction text, space_id text, space_label text,
  target_type text, target_id uuid,
  reason text, details text, status text, priority text,
  resolution text,
  reporter_id uuid, reporter_email text,
  subject_user_id uuid, subject_email text,
  assigned_to uuid, assigned_email text,
  created_at timestamptz, acknowledged_at timestamptz, resolved_at timestamptz,
  appealed_at timestamptz,
  total_count bigint
)
language plpgsql stable security definer set search_path = '' as $$
declare
  v_limit  integer := least(greatest(coalesce(p_limit, 20), 1), 100);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
  v_dir    text    := coalesce(p_direction, 'received');
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;
  if v_dir not in ('received','sent') then
    raise exception 'Direction invalide' using errcode = '22023';
  end if;

  return query
  select
    r.id, v_dir, r.space_id,
    (select s.label from public.community_spaces s where s.id = r.space_id),
    r.target_type, r.target_id,
    r.reason, r.details, r.status, r.priority, r.resolution,
    r.reporter_id,
    (select up.email from public.user_profiles up where up.user_id = r.reporter_id),
    r.subject_user_id,
    (select up.email from public.user_profiles up where up.user_id = r.subject_user_id),
    r.assigned_to,
    (select a.email from public.admin_users a where a.auth_uid = r.assigned_to limit 1),
    r.created_at, r.acknowledged_at, r.resolved_at, r.appealed_at,
    count(*) over()
  from public.community_reports r
  where (
      (v_dir = 'received' and r.subject_user_id = p_user_id)
   or (v_dir = 'sent'     and r.reporter_id     = p_user_id)
  )
  and (p_status is null or r.status = p_status)
  order by r.created_at desc
  limit v_limit offset v_offset;
end;
$$;


-- ===========================================================================
--  6. QUIZ — synthèse par module + historique paginé
-- ===========================================================================
create or replace function public.community_admin_user_quiz_summary(p_user_id uuid)
returns table(
  track text, mode text, module_key text,
  answers bigint, correct bigint, wrong bigint,
  accuracy numeric, avg_response_ms numeric,
  first_at timestamptz, last_at timestamptz
)
language plpgsql stable security definer set search_path = '' as $$
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  return query
  select
    q.track, q.mode, q.module_key,
    count(*),
    count(*) filter (where q.is_correct),
    count(*) filter (where q.is_correct is false),
    round(100.0 * count(*) filter (where q.is_correct) / nullif(count(*), 0), 1),
    round(avg(q.response_time_ms)::numeric, 0),
    min(q.answered_at), max(q.answered_at)
  from public.quiz_answer_history q
  where q.user_id = p_user_id
  group by q.track, q.mode, q.module_key
  order by max(q.answered_at) desc;
end;
$$;

create or replace function public.community_admin_user_quiz(
  p_user_id uuid,
  p_module  text default null,
  p_limit   integer default 25,
  p_offset  integer default 0
) returns table(
  id uuid, track text, mode text, module_key text, quiz_key text,
  question_text text, user_answer text, correct_answer text,
  is_correct boolean, difficulty text, response_time_ms integer,
  answered_at timestamptz, total_count bigint
)
language plpgsql stable security definer set search_path = '' as $$
declare
  v_limit  integer := least(greatest(coalesce(p_limit, 25), 1), 100);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  return query
  select
    q.id, q.track, q.mode, q.module_key, q.quiz_key,
    q.question_text, q.user_answer, q.correct_answer,
    q.is_correct, q.difficulty, q.response_time_ms,
    q.answered_at, count(*) over()
  from public.quiz_answer_history q
  where q.user_id = p_user_id
    and (p_module is null or q.module_key = p_module)
  order by q.answered_at desc
  limit v_limit offset v_offset;
end;
$$;


-- ===========================================================================
--  7. ABONNEMENT — historique + factures (sans identifiants Stripe)
-- ===========================================================================
create or replace function public.community_admin_user_billing(p_user_id uuid)
returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare v_result jsonb;
begin
  perform public.community_admin_guard();
  if p_user_id is null then raise exception 'Utilisateur obligatoire' using errcode = '22023'; end if;

  select jsonb_build_object(
    'subscriptions', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', b.id, 'plan', b.plan, 'status', b.status,
        'current_period_start', b.current_period_start,
        'current_period_end',   b.current_period_end,
        'created_at', b.created_at, 'updated_at', b.updated_at
      ) order by b.created_at desc)
      from public.billing_subscriptions b where b.user_id = p_user_id
    ), '[]'::jsonb),

    /* stripe_invoice_id et hosted_invoice_url volontairement omis */
    'invoices', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', i.id, 'invoice_number', i.invoice_number,
        'amount_cents', i.amount_cents, 'currency', i.currency,
        'status', i.status, 'plan', i.plan,
        'period_start', i.period_start, 'period_end', i.period_end,
        'created_at', i.created_at, 'paid_at', i.paid_at, 'due_at', i.due_at
      ) order by i.created_at desc)
      from public.billing_invoices i where i.user_id = p_user_id
    ), '[]'::jsonb),

    /* payload Stripe brut volontairement omis : il contient des identifiants */
    'events', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', e.id, 'event_type', e.event_type,
        'created_at', e.created_at, 'processed_at', e.processed_at
      ) order by e.created_at desc)
      from (
        select * from public.subscription_events se
        where se.user_id = p_user_id
        order by se.created_at desc limit 50
      ) e
    ), '[]'::jsonb)
  ) into v_result;

  return v_result;
end;
$$;


-- ===========================================================================
--  8. TIMELINE — activité chronologique consolidée
--     Chaque source est bornée avant l'union pour éviter un tri global coûteux.
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
  )
  select e.occurred_at, e.kind, e.label, e.detail, e.ref_type, e.ref_id
  from events e
  where e.occurred_at is not null
  order by e.occurred_at desc
  limit v_limit offset v_offset;
end;
$$;


-- ===========================================================================
--  9. PERMISSIONS
-- ===========================================================================
revoke all on function public.community_admin_guard() from public, anon;
revoke all on function public.community_admin_user_detail(uuid) from public, anon;
revoke all on function public.community_admin_user_posts(uuid,text,text,integer,integer) from public, anon;
revoke all on function public.community_admin_user_comments(uuid,text,text,integer,integer) from public, anon;
revoke all on function public.community_admin_user_messages(uuid,integer,integer) from public, anon;
revoke all on function public.community_admin_user_reports(uuid,text,text,integer,integer) from public, anon;
revoke all on function public.community_admin_user_quiz_summary(uuid) from public, anon;
revoke all on function public.community_admin_user_quiz(uuid,text,integer,integer) from public, anon;
revoke all on function public.community_admin_user_billing(uuid) from public, anon;
revoke all on function public.community_admin_user_timeline(uuid,integer,integer) from public, anon;

grant execute on function public.community_admin_user_detail(uuid) to authenticated;
grant execute on function public.community_admin_user_posts(uuid,text,text,integer,integer) to authenticated;
grant execute on function public.community_admin_user_comments(uuid,text,text,integer,integer) to authenticated;
grant execute on function public.community_admin_user_messages(uuid,integer,integer) to authenticated;
grant execute on function public.community_admin_user_reports(uuid,text,text,integer,integer) to authenticated;
grant execute on function public.community_admin_user_quiz_summary(uuid) to authenticated;
grant execute on function public.community_admin_user_quiz(uuid,text,integer,integer) to authenticated;
grant execute on function public.community_admin_user_billing(uuid) to authenticated;
grant execute on function public.community_admin_user_timeline(uuid,integer,integer) to authenticated;

comment on function public.community_admin_user_posts(uuid,text,text,integer,integer) is
  'Publications d''un utilisateur, paginées et filtrables, pour le dossier admin.';
comment on function public.community_admin_user_messages(uuid,integer,integer) is
  'Métadonnées des messages privés. Le contenu n''est révélé que s''il a déjà été versé comme pièce à un signalement.';
comment on function public.community_admin_user_billing(uuid) is
  'Abonnements, factures et évènements de facturation, sans identifiant ni payload Stripe.';
comment on function public.community_admin_user_timeline(uuid,integer,integer) is
  'Activité chronologique consolidée. Chaque source est bornée avant l''union.';
