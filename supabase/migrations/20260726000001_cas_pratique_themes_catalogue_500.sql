-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Extension de la taxonomie pour le catalogue 500
--
--  Ajoute les 11 thèmes manquants pour couvrir les grandes familles de
--  situations professionnelles GPX. Les 9 thèmes existants ne sont PAS
--  modifiés : leurs slugs, couleurs et sort_order restent tels quels afin de
--  ne pas invalider les cas déjà rattachés ni les filtres enregistrés côté
--  client (CasPratiqueFilters sérialise les theme_slugs en local).
--
--  Idempotent : ON CONFLICT (slug) DO NOTHING. Rejouable sans effet de bord.
--
--  Taxonomie finale : 20 thèmes.
--    Existants (1-9)  : deontologie, procedure-penale, controle-identite,
--                       usage-force, violences-conjugales, mineurs,
--                       circulation, stupefiants, secours-personnes
--    Ajoutés  (10-20) : ci-dessous
-- ════════════════════════════════════════════════════════════════════════════

INSERT INTO public.cas_pratique_themes (slug, label, color_hex, icon, sort_order)
VALUES
    ('accueil-public',            'Accueil du public',        '#0EA5E9', 'support_agent_rounded',      10),
    ('police-secours',            'Police-secours',           '#DC2626', 'emergency_rounded',          11),
    ('atteintes-biens',           'Atteintes aux biens',      '#B45309', 'inventory_2_rounded',        12),
    ('numerique',                 'Infractions numériques',   '#7C3AED', 'devices_rounded',            13),
    ('ordre-public',              'Ordre public',             '#0F766E', 'groups_rounded',             14),
    ('gestion-conflits',          'Gestion des conflits',     '#EA580C', 'forum_rounded',              15),
    ('equipe-hierarchie',         'Équipe et hiérarchie',     '#1D4ED8', 'diversity_3_rounded',        16),
    ('personnes-vulnerables',     'Personnes vulnérables',    '#DB2777', 'accessible_rounded',         17),
    ('discriminations',           'Discriminations',          '#9333EA', 'balance_rounded',            18),
    ('situations-sensibles',      'Situations sensibles',     '#334155', 'gpp_maybe_rounded',          19),
    ('situations-exceptionnelles','Situations exceptionnelles','#65A30D','crisis_alert_rounded',       20)
ON CONFLICT (slug) DO NOTHING;
