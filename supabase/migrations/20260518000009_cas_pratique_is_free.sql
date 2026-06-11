-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║  COP'IQ — Cas Pratique — Migration 018 : cas démo gratuit              ║
-- ║  Tâche      : CODE-064                                                  ║
-- ║                                                                         ║
-- ║  - Ajoute la colonne `is_free` à `cas_pratique_cases`.                  ║
-- ║  - Index partiel sur is_free=true pour les lectures côté liste.         ║
-- ║  - Marque le premier cas legacy (slug='case_1') comme `is_free=true`   ║
-- ║    par défaut — l'admin pourra changer ce choix.                       ║
-- ║                                                                         ║
-- ║  Le paywall complet (Stripe, subscription tier, edge function check)  ║
-- ║  est CODE-084. Ici on pose juste le data layer + le flag.              ║
-- ╚════════════════════════════════════════════════════════════════════════╝

BEGIN;

ALTER TABLE public.cas_pratique_cases
    ADD COLUMN IF NOT EXISTS is_free boolean NOT NULL DEFAULT false;

COMMENT ON COLUMN public.cas_pratique_cases.is_free IS
    'CODE-064 : si true, le cas est accessible à tous les users (même free tier). Sinon il est gated par le paywall (CODE-084).';

-- Index partiel : on optimise les requêtes "WHERE is_free = true" (page
-- d'onboarding / preview anonyme).
CREATE INDEX IF NOT EXISTS idx_cp_cases_is_free
    ON public.cas_pratique_cases(is_free)
    WHERE is_free = true;

-- Au moins 1 cas démo gratuit : on marque case_1 si présent.
UPDATE public.cas_pratique_cases
   SET is_free = true
 WHERE slug = 'case_1'
   AND is_free = false;

COMMIT;
