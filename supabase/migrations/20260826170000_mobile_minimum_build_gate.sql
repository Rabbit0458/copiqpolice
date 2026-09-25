-- Pilotage précis des mises à jour mobiles par numéro de build.
ALTER TABLE public.cp_app_version_config
  ADD COLUMN IF NOT EXISTS min_build_number integer NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS latest_build_number integer NOT NULL DEFAULT 0;

CREATE OR REPLACE FUNCTION public.app_minimum_version(
  p_platform text DEFAULT 'android'
)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
DECLARE r public.cp_app_version_config;
BEGIN
  SELECT * INTO r
  FROM public.cp_app_version_config
  WHERE platform = lower(COALESCE(p_platform, 'android'));

  IF r.platform IS NULL THEN
    RETURN jsonb_build_object(
      'min_version', '0.0.0',
      'latest_version', '0.0.0',
      'min_build_number', 0,
      'latest_build_number', 0,
      'force_update', false,
      'store_url', '',
      'message', null
    );
  END IF;

  RETURN jsonb_build_object(
    'platform', r.platform,
    'min_version', r.min_version,
    'latest_version', r.latest_version,
    'min_build_number', r.min_build_number,
    'latest_build_number', r.latest_build_number,
    'store_url', r.store_url,
    'message', r.message,
    'force_update', r.force_update
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.app_minimum_version(text) TO anon, authenticated;

-- Le build 3 contient le premier verrou. Il est déclaré comme dernier build,
-- mais n'est pas encore imposé tant qu'il n'est pas disponible sur les stores.
UPDATE public.cp_app_version_config
SET min_version = '1.0.0',
    min_build_number = 3,
    latest_version = '1.0.0',
    latest_build_number = 3,
    force_update = true
WHERE platform IN ('ios', 'android');

-- En bêta iOS, ouvre directement TestFlight. À remplacer par la fiche App
-- Store définitive lors de la publication publique.
UPDATE public.cp_app_version_config
SET store_url = 'itms-beta://'
WHERE platform = 'ios'
  AND store_url LIKE '%id000000000%';
