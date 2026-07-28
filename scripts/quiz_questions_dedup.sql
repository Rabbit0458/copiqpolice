-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Déduplication de public.quiz_questions (audit du 28/07/2026)
--
--  CONTEXTE
--  quiz_questions contient 6 365 050 lignes. Vérifié par requête SQL :
--    - Catégories "petites" (Police, Droit, Sport...) : chaque question
--      distincte est dupliquée EXACTEMENT 600 fois (ex. Police : 81 questions
--      -> 48 600 lignes). Cause identifiée dans le code Dart
--      (quiz_culture_generale_*.dart) : un système de tirage pseudo-aléatoire
--      par colonne `rand_key` qui ne nécessite qu'UNE seule ligne par
--      question — la duplication x600 n'apporte aucun bénéfice fonctionnel.
--    - Catégories "combinatoires" (Geographie, France, Institutions...) :
--      quasi pas de duplication au sens strict (ratio proche de 1), il s'agit
--      d'un générateur de variantes (pays/départements). Ce script ne touche
--      PAS à ce contenu au-delà de retirer les VRAIS doublons de texte exact.
--
--  POURQUOI CE SCRIPT N'A PAS ÉTÉ EXÉCUTÉ AUTOMATIQUEMENT
--  La table dispose déjà de 9 index (dont `quiz_questions_mod_cat_idx` sur
--  (module, category), `quiz_questions_category_id_idx`, un index partiel
--  dédié à Géographie...) — l'hypothèse initiale "pas d'index" était fausse
--  et a été corrigée après vérification (un index dupliqué créé par erreur
--  pendant cet audit a été supprimé immédiatement après coup). Le vrai
--  facteur bloquant est la taille brute de l'opération : sur 6,35M lignes
--  avec colonnes jsonb/text potentiellement TOASTées, un CREATE TABLE AS
--  SELECT ou un DELETE de masse dépasse systématiquement le timeout de
--  l'outil SQL utilisé pour cet audit. Confirmé via pg_stat_activity : la
--  requête tourne réellement plusieurs dizaines de secondes côté serveur
--  avant d'être abandonnée avec la connexion — ce n'est pas un verrou, c'est
--  un vrai temps d'exécution qui dépasse ce que cet outil peut attendre.
--  À exécuter directement depuis le SQL Editor du dashboard Supabase
--  (timeout beaucoup plus généreux) ou via `psql` / la CLI Supabase.
--
--  MÉTHODE : exécuter chaque étape SÉPARÉMENT (pas tout le fichier d'un
--  coup), et vérifier le résultat avant de passer à la suivante.
-- ════════════════════════════════════════════════════════════════════════════


-- ─────────────────────────────────────────────────────────────────────────
-- ÉTAPE 1 — Backup complet AVANT toute suppression (filet de sécurité, en
-- plus du PITR Supabase natif). ~6,35M lignes : peut prendre plusieurs
-- dizaines de secondes à quelques minutes selon le tier du projet.
-- ─────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.quiz_questions_backup_20260728 AS
  SELECT * FROM public.quiz_questions;

-- Vérification : doit renvoyer 6 365 050 (ou le total courant si la table a
-- évolué depuis l'audit).
SELECT count(*) AS backup_row_count FROM public.quiz_questions_backup_20260728;


-- ─────────────────────────────────────────────────────────────────────────
-- ÉTAPE 2 — Aperçu de l'impact AVANT suppression réelle (lecture seule).
-- Donne, par catégorie, le nombre de lignes qui seraient supprimées.
-- ─────────────────────────────────────────────────────────────────────────
SELECT module, category,
       count(*) AS total_avant,
       count(*) FILTER (WHERE rn = 1) AS total_apres,
       count(*) FILTER (WHERE rn > 1) AS lignes_a_supprimer
FROM (
  SELECT module, category,
         row_number() OVER (PARTITION BY module, category, question ORDER BY id) AS rn
  FROM public.quiz_questions
) x
GROUP BY module, category
ORDER BY lignes_a_supprimer DESC;


-- ─────────────────────────────────────────────────────────────────────────
-- ÉTAPE 3 — Suppression réelle des doublons stricts (texte de question
-- identique dans le même module/catégorie), en conservant la ligne au plus
-- petit id de chaque groupe. Ne touche PAS aux contenus combinatoires
-- réellement distincts (Geographie, France...).
-- ─────────────────────────────────────────────────────────────────────────
DELETE FROM public.quiz_questions q
USING (
  SELECT id, row_number() OVER (PARTITION BY module, category, question ORDER BY id) AS rn
  FROM public.quiz_questions
) d
WHERE q.id = d.id AND d.rn > 1;


-- ─────────────────────────────────────────────────────────────────────────
-- ÉTAPE 4 — Vérification post-suppression.
-- doublons_restants doit être 0. total_lignes doit être très inférieur à
-- 6 365 050 (de l'ordre de quelques millions de moins, essentiellement sur
-- les catégories "petites").
-- ─────────────────────────────────────────────────────────────────────────
SELECT count(*) AS total_lignes FROM public.quiz_questions;

SELECT module, category, question, count(*)
FROM public.quiz_questions
GROUP BY module, category, question
HAVING count(*) > 1
LIMIT 10;  -- doit renvoyer 0 ligne


-- NOTE (précision utilisateur du 29/07/2026) : PAS de plafonnement des
-- catégories combinatoires (Géographie, France...). L'objectif est
-- uniquement "zéro doublon exact / des questions différentes" — le volume
-- de contenu réellement distinct ne doit PAS être réduit. L'ÉTAPE 3
-- ci-dessus suffit : elle ne supprime que les répétitions de texte
-- identique, jamais du contenu unique.


-- ─────────────────────────────────────────────────────────────────────────
-- ÉTAPE 5 (à faire seulement après avoir confirmé que l'app fonctionne
-- normalement en production pendant quelques jours) — libérer l'espace
-- disque du backup une fois la déduplication validée en conditions réelles.
-- NE PAS exécuter en même temps que les étapes précédentes.
-- ─────────────────────────────────────────────────────────────────────────
-- DROP TABLE public.quiz_questions_backup_20260728;
