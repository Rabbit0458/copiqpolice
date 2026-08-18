# Mise à jour — Scolarité Gardien de la paix

## Objectif

La scolarité GPX adopte désormais la même architecture validée que la
scolarité Policier adjoint, sans partager leurs données métier.

## Accueil GPX

- Le message d’accueil affiche le prénom réel issu de `user_profiles.first_name`.
- Le fallback reste le nom d’utilisateur lorsque le prénom est absent.
- Le bouton `Espace GPX` ouvre le sélecteur des programmes GPX.
- L’icône école conserve l’accès au sélecteur général mode/grade.
- Le raccourci forum redondant de l’en-tête est supprimé.
- Le carrousel conserve ses cartes, favoris, reprise et redirections.
- La clé visuelle du carrousel est propre à GPX.
- L’ancien bloc de progression lourd est remplacé par `Ta prochaine étape`.
- Cette recommandation choisit un vrai sous-cours GPX à chaque nouvelle
  ouverture, reste stable pendant la session et ouvre sa route réelle.

## Barre inférieure

Ordre définitif :

1. Accueil
2. Suivi
3. Forum
4. Favoris
5. Profil

Le forum occupe donc la position immédiatement à gauche des favoris. Le
sélecteur de programme n’intercepte plus cet onglet.

## Suivi de scolarité GPX

L’ancienne page Journal est remplacée par le centre de suivi premium déjà
éprouvé pour PA : moyenne, activités, régularité, objectif quotidien,
recommandations et historique.

La source de données est `GpxSchoolProgressService`. Sa requête Supabase est
strictement limitée à l’utilisateur connecté et aux valeurs :

- `track = gpx`
- `mode = school`
- session terminée (`finished_at IS NOT NULL`)

La clé locale de l’objectif est `gpx_school_daily_goal`. Aucun résultat PA,
GPX concours ou autre parcours ne peut être agrégé dans ce suivi.

## Registre pédagogique

Les résultats sont regroupés en six familles :

- Institution & organisation
- Police judiciaire & droit pénal
- Sécurité routière
- Intervention professionnelle
- Accueil du public & victimes
- Fondamentaux de scolarité

Les recommandations du suivi reviennent sur `/home-gpx-school`, route sûre,
quand une route pédagogique plus précise n’est pas garantie.

## Fichiers principaux

- `lib/features/home/home_page_gpx_school.dart`
- `lib/features/home/gpx_school_progress_service.dart`
- `lib/main.dart`
- `test/features/home/gpx_school_progress_service_test.dart`

## Validation attendue

- Analyse Flutter sans erreur.
- Tests du registre GPX réussis.
- Vérification visuelle clair/sombre sur petit et grand écran.
- Test avec deux comptes pour confirmer l’isolation des résultats.
