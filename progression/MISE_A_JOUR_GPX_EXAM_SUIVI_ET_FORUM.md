# Mise à jour — GPX Exam : suivi et communauté

## Résultat livré

Le parcours **Concours Gardien de la paix** possède désormais le même socle de suivi premium que PA Exam. L’ancien onglet « journal » est remplacé par un tableau de progression personnel, strictement limité au périmètre Supabase `track = gpx` et `mode = exam`.

La communauté utilise l’espace `gpx_exam`. L’utilisateur peut consulter les autres espaces et le fil global, mais il ne peut publier et répondre que dans son parcours actif. Cette règle est contrôlée dans Flutter et à nouveau dans Supabase.

## Sources de progression

- `quiz_history` : quiz GPX terminés, filtrés par utilisateur, `track = gpx`, `mode = exam`.
- `tests_psychotechnique_history` : résultats psychotechniques du concours, modes `concours` et `concours_global`.
- `cas_pratique_attempts` : cas pratiques terminés, score, durée et date de fin.
- `quiz_answer_history` : détail canonique des réponses PA/GPX Exam, protégé par RLS et réservé au propriétaire de la donnée.

Les résultats PA, GPX School et PA School ne sont jamais intégrés aux statistiques GPX Exam.

## Modules et reprises d’entraînement

Le suivi classe les activités dans cinq familles : culture générale, tests psychotechniques, langue étrangère, institution policière et cas pratiques. Chaque recommandation et chaque carte matière renvoie exclusivement vers une route `/gpx_exam/concours/...`.

Les routes de reprise utilisent uniquement des pages enregistrées dans le routeur : actualité pour la culture générale, calcul rapide pour les psychotechniques, anglais pour les langues, culture policière pour l’institution et l’accueil des cas pratiques. Les anciens chemins de hubs non enregistrés ont été supprimés du registre de progression.

Les sélecteurs de période et de tri utilisent une feuille de choix premium adaptée à iOS : grand rayon, options illustrées, état sélectionné explicite, zones tactiles d’au moins 44 px et prise en charge de VoiceOver. Les boutons principaux partagent désormais une forme, une hauteur, une couleur et une typographie cohérentes.

## Indicateurs disponibles

- score global pondéré par le nombre réel de questions ;
- objectif quotidien modifiable et sauvegardé séparément sous `gpx_exam_daily_goal` ;
- série de jours actifs ;
- activité du jour et de la semaine ;
- historique et évolution sur 7 jours, 30 jours ou toute la période ;
- moyenne, meilleur résultat et dernier résultat par matière ;
- recommandation automatique vers la matière la moins maîtrisée ;
- erreurs détaillées dès que les quiz alimentent la table canonique ;
- chargement partiel résilient si une source optionnelle est temporairement indisponible.

## Accueil adaptatif

L’ancien bloc statique « Focus du jour » est remplacé par « Ta prochaine étape ». La carte exploite le même instantané de progression que l’onglet de suivi : elle propose un démarrage guidé lorsque l’historique est vide, puis cible automatiquement la matière la moins maîtrisée. Elle affiche le niveau actuel, le nombre d’activités et une route GPX valide. La recommandation est recalculée au démarrage, au retour d’un exercice et lorsque l’application revient au premier plan.

## Communauté GPX Exam vérifiée

- espace Supabase : `gpx_exam` ;
- libellé : « Concours Gardien de la paix » ;
- 7 catégories actives et publiables ;
- fil `global` disponible en lecture ;
- création et commentaires contrôlés par `community_can_publish` ;
- une catégorie doit appartenir au même espace que la publication ;
- profils, notifications, messages privés, likes, favoris, réponses imbriquées, signalements et modération restent partagés avec les autres parcours.

## Fichiers Flutter principaux

- `lib/features/home/home_page_gpx_exam.dart`
- `lib/features/home/gpx_exam_progress_repository.dart`
- `lib/features/home/gpx_exam_progress_service.dart`
- `lib/features/home/gpx_exam_progress_source_registry.dart`
- `lib/features/home/pa_exam_progress_page.dart` (interface commune configurable)
- `lib/features/home/pa_exam_progress_calculator.dart` (moteur commun configurable)
- `lib/features/forum/community_page.dart`
- `lib/features/forum/community_repository.dart`

## Migration Supabase

`supabase/migrations/20260804103000_gpx_exam_progress_foundation.sql` crée de manière additive l’historique détaillé PA/GPX, applique les règles RLS et ajoute les index des quatre chemins de lecture du suivi. Elle ne supprime ni ne réécrit aucun résultat existant.

## Validation

- analyse Flutter ciblée : aucune erreur ;
- tests du registre, des routes et du calcul GPX ;
- contrôle réel Supabase : 51 sessions GPX Exam existantes détectées ;
- contrôle réel du forum : espace actif, 7 catégories actives et 7 catégories publiables par les utilisateurs ;
- contrôle RLS : résultats personnels lisibles uniquement par leur propriétaire, publication communautaire limitée au parcours actif.
