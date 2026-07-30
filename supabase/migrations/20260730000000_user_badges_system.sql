-- COP'IQ — Système de badges de vérification (rouge admin, jaune modérateur,
-- bleu très actif ≥100 quiz, violet légende ≥2000 quiz).
--
-- Règles métier (décision explicite de l'utilisateur, 30/07/2026) :
--   - admin/modérateur : rôle attribué manuellement, aucun quota de quiz.
--   - badge bleu "active" : >= 100 sessions de quiz réellement lancées.
--   - badge violet "legend" : >= 2000 sessions de quiz réellement lancées.
--   - un utilisateur standard sans activité suffisante n'a aucun badge.
--
-- Source de vérité pour le compteur : public.quiz_history, alimentée par un
-- INSERT au lancement réel d'un quiz (pattern déjà utilisé dans ~219 fichiers
-- Flutter), PAS par un compteur de requêtes HTTP/API.

-- ═══════════════════════════════════════════════════════════════════════
-- 1. Calcul du badge — fonction pure, réutilisée partout
-- ═══════════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION public.compute_badge_type(p_role public.user_role, p_quiz_count integer)
RETURNS text
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT CASE
    WHEN p_role IN ('owner', 'admin') THEN 'admin'
    WHEN p_role = 'moderator' THEN 'moderator'
    WHEN COALESCE(p_quiz_count, 0) >= 2000 THEN 'legend'
    WHEN COALESCE(p_quiz_count, 0) >= 100 THEN 'active'
    ELSE 'none'
  END;
$$;

COMMENT ON FUNCTION public.compute_badge_type(public.user_role, integer) IS
  'Source de vérité unique pour la priorité des badges utilisateur : admin > modérateur > légende (>=2000 quiz) > actif (>=100 quiz) > aucun. Réutilisée par get_my_entitlement() et get_public_profile_badges().';

-- ═══════════════════════════════════════════════════════════════════════
-- 2. Compteur de quiz réellement lancés (une ligne quiz_history = un lancement)
-- ═══════════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION public.count_quiz_attempts(p_user_id uuid)
RETURNS integer
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path TO 'public'
AS $$
  SELECT COUNT(*)::int FROM public.quiz_history WHERE uid = p_user_id::text;
$$;

GRANT EXECUTE ON FUNCTION public.count_quiz_attempts(uuid) TO authenticated;

COMMENT ON FUNCTION public.count_quiz_attempts(uuid) IS
  'Nombre de sessions de quiz réellement lancées par un utilisateur (COUNT sur quiz_history, pas sur les requêtes HTTP).';

-- ═══════════════════════════════════════════════════════════════════════
-- 3. Verrou anti-auto-promotion : un client ne peut plus changer sa propre
--    colonne role par un UPDATE direct — seule public.set_user_role()
--    (SECURITY DEFINER, réservée owner/admin) peut le faire.
-- ═══════════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION public.prevent_direct_role_change()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.role IS DISTINCT FROM OLD.role THEN
    IF current_setting('copiq.role_change_authorized', true) IS DISTINCT FROM 'true' THEN
      RAISE EXCEPTION 'role_change_forbidden: use public.set_user_role()' USING ERRCODE = '42501';
    END IF;
  END IF;
  RETURN NEW;
END;
$$;

COMMENT ON FUNCTION public.prevent_direct_role_change() IS
  'Bloque tout UPDATE de user_profiles.role hors du chemin sécurisé public.set_user_role() (qui pose le flag de session copiq.role_change_authorized avant son propre UPDATE).';

DROP TRIGGER IF EXISTS trg_prevent_direct_role_change ON public.user_profiles;
CREATE TRIGGER trg_prevent_direct_role_change
  BEFORE UPDATE ON public.user_profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.prevent_direct_role_change();

-- Ré-application de set_user_role() (inchangée dans sa logique d'autorisation)
-- avec l'ajout du flag de session qui autorise son propre UPDATE à passer le
-- trigger ci-dessus.
CREATE OR REPLACE FUNCTION public.set_user_role(p_user_id uuid, p_role text)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
DECLARE
  v_actor_role text;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'not_authenticated';
  END IF;

  SELECT role::text INTO v_actor_role
  FROM public.user_profiles
  WHERE user_id = auth.uid();

  IF v_actor_role NOT IN ('owner','admin') THEN
    RAISE EXCEPTION 'forbidden';
  END IF;

  -- Only an owner can promote another to owner
  IF p_role = 'owner' AND v_actor_role <> 'owner' THEN
    RAISE EXCEPTION 'forbidden_owner_promotion';
  END IF;

  PERFORM set_config('copiq.role_change_authorized', 'true', true);

  UPDATE public.user_profiles
     SET role = p_role::user_role,
         updated_at = now()
   WHERE user_id = p_user_id;
END;
$function$;

-- ═══════════════════════════════════════════════════════════════════════
-- 4. RPC batchée pour afficher le badge d'auteurs tiers (forum, etc.)
--    Colonnes strictement limitées au nécessaire : jamais email/phone/city.
--    Batchée pour éviter le N+1 (un seul appel par écran, liste d'IDs).
-- ═══════════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION public.get_public_profile_badges(p_user_ids uuid[])
RETURNS TABLE (
  user_id uuid,
  username text,
  avatar_index integer,
  role text,
  quiz_attempts_count integer,
  badge_type text
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path TO 'public'
AS $$
  SELECT
    p.user_id,
    p.username,
    p.avatar_index,
    p.role::text,
    public.count_quiz_attempts(p.user_id) AS quiz_attempts_count,
    public.compute_badge_type(p.role, public.count_quiz_attempts(p.user_id)) AS badge_type
  FROM public.user_profiles p
  WHERE p.user_id = ANY(p_user_ids);
$$;

GRANT EXECUTE ON FUNCTION public.get_public_profile_badges(uuid[]) TO authenticated;

COMMENT ON FUNCTION public.get_public_profile_badges(uuid[]) IS
  'Infos publiques minimales (username, avatar, badge) pour une liste d''auteurs — utilisée par le forum pour éviter le N+1. Ne jamais exposer email/phone/city/birthday ici.';

CREATE OR REPLACE FUNCTION public.get_public_profile_badge(p_user_id uuid)
RETURNS TABLE (
  user_id uuid,
  username text,
  avatar_index integer,
  role text,
  quiz_attempts_count integer,
  badge_type text
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path TO 'public'
AS $$
  SELECT * FROM public.get_public_profile_badges(ARRAY[p_user_id]);
$$;

GRANT EXECUTE ON FUNCTION public.get_public_profile_badge(uuid) TO authenticated;

-- ═══════════════════════════════════════════════════════════════════════
-- 5. get_my_entitlement() étendue avec quiz_attempts_count + badge_type
--    (réutilise l'unique RPC déjà branchée dans EntitlementService Flutter
--    plutôt que d'ajouter un second appel réseau pour son propre badge).
-- ═══════════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION public.get_my_entitlement()
RETURNS json
LANGUAGE plpgsql
STABLE SECURITY DEFINER
SET search_path TO 'public'
AS $function$
DECLARE
  v_uid uuid := auth.uid();
  v_role text;
  v_plan text;
  v_status text;
  v_valid_until timestamptz;
  v_cancel_at_period_end boolean;
  v_used int;
  v_resets_at timestamptz;
  v_premium boolean;
  v_quiz_count int;
BEGIN
  IF v_uid IS NULL THEN
    RETURN json_build_object('authenticated', false);
  END IF;

  SELECT role::text INTO v_role
  FROM public.user_profiles
  WHERE user_id = v_uid;

  SELECT plan::text, status::text, valid_until, cancel_at_period_end
  INTO v_plan, v_status, v_valid_until, v_cancel_at_period_end
  FROM public.subscription_payement
  WHERE user_id = v_uid
  ORDER BY updated_at DESC
  LIMIT 1;

  v_premium := public.is_user_premium(v_uid);

  SELECT used, window_start + interval '7 days'
  INTO v_used, v_resets_at
  FROM public.free_weekly_usage
  WHERE user_id = v_uid;

  v_quiz_count := public.count_quiz_attempts(v_uid);

  RETURN json_build_object(
    'authenticated', true,
    'user_id', v_uid,
    'role', COALESCE(v_role, 'user'),
    'is_owner', (v_role = 'owner'),
    'is_admin', (v_role IN ('owner','admin')),
    'premium', v_premium,
    'plan', COALESCE(v_plan, 'free'),
    'status', COALESCE(v_status, 'active'),
    'valid_until', v_valid_until,
    'cancel_at_period_end', COALESCE(v_cancel_at_period_end, false),
    'free_used', COALESCE(v_used, 0),
    'free_limit', 10,
    'free_remaining', GREATEST(0, 10 - COALESCE(v_used, 0)),
    'free_resets_at', v_resets_at,
    'quiz_attempts_count', v_quiz_count,
    'badge_type', public.compute_badge_type(COALESCE(v_role, 'user')::user_role, v_quiz_count)
  );
END;
$function$;

-- ═══════════════════════════════════════════════════════════════════════
-- 6. Atténuation anti-spam sur quiz_history : un utilisateur ne peut pas
--    créer 2 lancements en rafale (< 3s d'écart) pour gonfler son compteur
--    par appel API direct. Ce n'est pas une preuve cryptographique de
--    session réelle, seulement un garde-fou raisonnable et peu coûteux —
--    cohérent avec l'usage réel (un vrai quiz prend au minimum plusieurs
--    secondes entre deux lancements distincts).
-- ═══════════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION public.quiz_history_rate_limit()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_last timestamptz;
BEGIN
  SELECT MAX(started_at) INTO v_last
  FROM public.quiz_history
  WHERE uid = NEW.uid;

  IF v_last IS NOT NULL AND NEW.started_at < v_last + interval '3 seconds' THEN
    RAISE EXCEPTION 'quiz_history_rate_limited' USING ERRCODE = '42901';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_quiz_history_rate_limit ON public.quiz_history;
CREATE TRIGGER trg_quiz_history_rate_limit
  BEFORE INSERT ON public.quiz_history
  FOR EACH ROW
  EXECUTE FUNCTION public.quiz_history_rate_limit();
