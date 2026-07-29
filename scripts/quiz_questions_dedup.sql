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
--  STATUT : EXÉCUTÉ le 29/07/2026, catégorie par catégorie (l'exécution
--  d'un coup se heurtait au timeout de l'outil SQL utilisé pour cet audit
--  sur les plus grosses catégories — contourné en isolant chaque catégorie,
--  et pour Géographie en séparant le calcul des doublons (CTAS) de la
--  suppression proprement dite). Résultat : 6 365 050 -> 5 535 837 lignes
--  (-829 213 doublons stricts), détail par catégorie dans RESTE_A_FAIRE.md
--  section C.2. Aucune réduction du volume de contenu distinct (choix
--  explicite de l'utilisateur).
--
--  Les 14 tables `quiz_questions_backup_<categorie>` créées avant chaque
--  suppression sont TOUJOURS EN BASE (filet de sécurité) — à supprimer
--  uniquement après validation en conditions réelles (voir étape 5
--  ci-dessous), pas avant.
--
--  Ce fichier est conservé comme documentation de la méthode utilisée.
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
-- disque des 14 backups par catégorie une fois la déduplication validée en
-- conditions réelles. NE PAS exécuter tant que la validation n'est pas faite.
-- ─────────────────────────────────────────────────────────────────────────
-- DROP TABLE public.quiz_questions_backup_sport;
-- DROP TABLE public.quiz_questions_backup_police;
-- DROP TABLE public.quiz_questions_backup_droit;
-- DROP TABLE public.quiz_questions_backup_securite;
-- DROP TABLE public.quiz_questions_backup_institutions;
-- DROP TABLE public.quiz_questions_backup_france;
-- DROP TABLE public.quiz_questions_backup_musique;
-- DROP TABLE public.quiz_questions_backup_sciences;
-- DROP TABLE public.quiz_questions_backup_sante;
-- DROP TABLE public.quiz_questions_backup_mythologie;
-- DROP TABLE public.quiz_questions_backup_actualite;
-- DROP TABLE public.quiz_questions_backup_cinema;
-- DROP TABLE public.quiz_questions_backup_histoire;
-- DROP TABLE public.quiz_questions_backup_geographie;
