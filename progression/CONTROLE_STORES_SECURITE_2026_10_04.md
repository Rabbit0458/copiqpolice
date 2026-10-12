# Contrôle stores et sécurité — 4 octobre 2026

> Mise à jour du 10 octobre : les failles de purge et de code administrateur ont été corrigées en production après l'audit initial. Voir [les correctifs et tests du panneau fondateur](./CORRECTIFS_SECURITE_PURGE_ET_PANEL_2026_10_10.md). Les autres points de [l'audit](./AUDIT_SECURITE_ET_TESTS_2026_10_10.md), dont les droits Premium serveur, restent à traiter avant publication. Les correctifs du 4 octobre restent en place.

> Reprise du 10 octobre : bilan consolidé dans [PUBLICATION_STORES_ETAT_2026_10_10.md](./PUBLICATION_STORES_ETAT_2026_10_10.md). Les sections historiques ci-dessous décrivant l'absence de produits Google ou de signature sont dépassées par l'état final du 4 octobre. Suppression de compte : fonction `delete-user-cascade` ACTIVE v65 confirmée directement sur Supabase ; absence du fichier dans l'ancienne copie locale ne signifie pas absence du service. Aucun achat ni test de suppression exécuté lors de cette reprise.

Copie de travail : C:\Users\kaiso\Desktop\COPIQPOLICEAPP\copiqpolice.

## État final de la reprise Android du 4 octobre (prioritaire sur les constats historiques ci-dessous)
- Version **1.1.0+8** signée, acceptée et diffusée sur le canal **Tests internes** de Google Play. Pas de publication publique. Aucun testeur interne désigné.
- Les deux abonnements Google sont créés et actifs en **France** : mensuel 8,99 EUR TTC (`copiq_premium_monthly:monthly`), annuel 79,99 EUR TTC (`copiq_premium_yearly:yearly`).
- RevenueCat reconnaît les deux produits comme Published. Ils sont tous deux attachés au droit `premium` (entlacc932816a), vérifié dans la page de ce droit après sauvegarde.
- Offre `default` : `$rc_monthly` contient le mensuel Android et `$rc_annual` l'annuel Android. Les associations iOS existantes sont conservées. La page de l'offre confirme les deux rattachements après sauvegarde.
- 9 tests serveur réussis, incluant les deux identifiants Google avec suffixe de forfait de base. Aucun achat, restauration ou remboursement sur appareil n'a été exécuté : le paiement de bout en bout n'est donc pas encore validé.
- Périmètre : configuration Android commune aux quatre parcours GPX, PA, Exam GPX et Exam PA. Aucun écran pédagogique individuel modifié ni testé visuellement dans cette reprise.
- Reste avant lancement public : test Android via un compte testeur, droits Premium et publicité après achat/restauration/expiration, obligations et déclarations stores déjà listées ci-dessous. iOS nécessite encore son build, ses tests et les contrats Apple.
- Preuves : `preuves-stores/google-play-build-8-2026-10-04.png`, `google-play-mensuel-actif-2026-10-04.png`, `google-play-annuel-actif-2026-10-04.png`, `revenuecat-offre-android-2026-10-04.png`.

## Fiches
- Google Play : nom COP'IQ – Prépa Police, description courte et complète françaises enregistrés le 3 octobre ; quatre parcours, gratuit/publicités, Premium mensuel/annuel, renouvellement et gestion Google Play, indépendance et liens officiels. État confirmé : modifications prêtes à envoyer pour examen. Aucune soumission effectuée.
- Google Play : coordonnées existantes contact@copiq.fr, téléphone professionnel +33981311558, site https://copiq.fr/.
- Apple : textes, mots-clés, assistance https://copiq.fr/contact/, confidentialité https://copiq.fr/privacy/ et EULA Apple contrôlés dans la version 1.1.0. Contact de vérification Kais Ouartani complété avec les coordonnées professionnelles Google Play puis enregistré le 4 octobre.
- Compte de démonstration Apple toujours à fournir ; aucun mot de passe personnel utilisé.

## Abonnements et contrats
- Apple : mensuel fr.copiq.premium.monthly et annuel fr.copiq.premium.yearly, niveau 1, prêts pour vérification. Ancien hebdomadaire toujours présent dans le store, hors des deux plans exposés par le code.
- Google Play : page Abonnements confirmant aucun abonnement et demandant l'import d'un nouveau APK. Création des produits Google et liaison à l'offre RevenueCat restent bloquées par le binaire compatible à charger.
- Apple Business : contrat gratuit actif ; contrat payant Nouveau ; mise à jour de l'entité juridique et statut DSA demandés. Aucun contrat signé ni information juridique inventée.
- Aucun achat/restauration réel effectué. Build iOS 1.1.0+7 à construire sur Mac ; binaire Android signé à préparer.

## Corrections de sécurité appliquées en production
1. Deux anciennes fonctions SECURITY DEFINER étaient exécutables par anon et authenticated : set_subscription_tier et set_user_subscription. Elles sont désormais réservées à service_role. Aucun appel trouvé dans les sources Flutter, web et Edge Functions inspectées. Le relais RevenueCat apply_store_snapshot conserve son accès serveur exclusivement.
2. user_profiles autorisait la création de son propre profil sans restriction de rôle. Une politique INSERT restrictive impose désormais le rôle initial active aux clients authentifiés.
3. set_user_role ne refusait pas explicitement un profil absent (rôle NULL). Le contrôle refuse désormais ce cas avant toute modification.

Migrations locales :
- supabase/migrations/20261003155053_restrict_legacy_subscription_rpc.sql
- supabase/migrations/20261004064728_harden_profile_role_authorization.sql

Tests SQL transactionnels avec rollback réussis : refus des deux anciens setters pour anon/authenticated ; refus d'une promotion par un profil absent et d'une insertion de profil owner. Privilèges serveur conservés et relus. Aucun abonnement ou compte réel modifié par les tests.

## Tests et limites de l'audit
- 17 tests Flutter réussis : plans, sérialisation des achats/changements de compte, clés publiques de configuration, politique publicitaire.
- 8 tests de normalisation RevenueCat réussis : annulation, expiration/remboursement, sandbox, grâce, produits inconnus, réponses invalides et transferts.
- Périmètre partagé : Scolarité GPX, Scolarité PA, Exam GPX et Exam PA ; contrôles sur services communs et droits serveur, pas une navigation de chaque écran ni un audit exhaustif des 1 409 fichiers de la cartographie.
- Conseiller Supabase relancé : aucun avis ERROR renvoyé, mais avertissements persistants. 97 fonctions privilégiées accessibles anonymement et 280 aux utilisateurs connectés nécessitent une revue des gardes internes ; ces comptes ne signifient pas autant de failles confirmées. 189/236 objets visibles dans le schéma GraphQL ; visibilité du schéma ne prouve pas l'accès aux lignes.
- Autres avertissements : expiration OTP supérieure à une heure, protection contre les mots de passe compromis désactivée, correctifs PostgreSQL disponibles (version 17.4.1.074), deux extensions dans public. Aucun changement global de base ni mise à niveau avec interruption effectué.
- Politique de confidentialité et CGU publiques encore à harmoniser (RevenueCat, AdMob, anciens tarifs et âge cible). Classification et droits sur les contenus nécessitent les informations du titulaire.

Ce contrôle ciblé et les correctifs ne constituent pas une certification de sécurité globale. Les dossiers ne sont pas prêts à une publication publique tant que les points ci-dessus et les déclarations de données ne sont pas finalisés.

## Vérification RevenueCat
Offre default relue le 4 octobre : deux packages $rc_monthly et $rc_annual, chacun relié au produit Apple correspondant et à un produit Test Store. Aucun produit Google Play rattaché. La présence du Test Store ne signifie pas que les clés SDK natives utilisent ce magasin ; les tests locaux vérifient le chargement des clés natives publiques et le refus d'une clé de test en remplacement.

## Tentative de création Android — 4 octobre 2026
Page Google Play Abonnements rechargée : aucune offre, seul bouton « Importer un nouveau APK ». Impossible de créer les produits depuis cet écran avant un binaire compatible.
Recherche des fichiers .jks/.keystore/key.properties/.aab dans Desktop, Downloads et Documents : aucune clé release ni AAB trouvé ; seule une clé de debug du SDK Flutter est présente, inutilisable pour publier cette app.
GitHub Rabbit0458/copiqpolice : paramètres Actions secrets consultés ; aucun secret de dépôt ni d'environnement. Le workflow attend ANDROID_KEYSTORE_BASE64, ANDROID_KEYSTORE_PASSWORD, ANDROID_KEY_PASSWORD et ANDROID_KEY_ALIAS ; ils ne sont donc pas configurés.
Ancienne trace RESTE_A_FAIRE.md : android/app/upload-keystore.jks (alias copiq-release), générée historiquement le 29 juillet. Rechercher cette clé et android/key.properties sur le Mac ou une sauvegarde. Aucun remplacement créé.
Plans attendus dans le code : copiq_premium_monthly et copiq_premium_yearly. Ils ne sont PAS créés dans Google Play ni rattachés à RevenueCat Android. Le branchement serveur et SDK existant ne suffit pas sans ces produits.

## Reprise après récupération de la clé Android
- Clé `android/copiq-release-key.jks` et `android/key.properties` maintenant présents dans la copie COPIQPOLICEAPP. Ouverture de la clé privée réussie avec le mot de passe local, sans divulgation.
- Certificat SHA-256 de la clé comparé au certificat d'importation Google Play : correspondance exacte E5:F9:34:8E:51:83:6D:B5:41:77:3D:A1:8E:87:75:02:4C:83:5C:3A:0D:FB:54:87:67:10:FA:14:04:DB:EF:B5. Aucun remplacement de clé nécessaire.
- Chemin Mac périmé dans key.properties remplacé par `../copiq-release-key.jks`, relatif à android/app. Les fichiers de signature restent exclus de Git.
- Première compilation bloquée : Flutter installé exige Gradle >= 8.14 et Android Gradle Plugin >= 8.11.1. Wrapper passé de 8.11.1 à 8.14.4 et AGP de 8.9.1 à 8.11.1 ; compilation release 1.1.0+7 relancée avec config/revenuecat.public.json. Aucun contournement des contrôles de dépendances.
- Google Play : version 5 (1.0.0) visible sur BETA TESTEUR. Brouillon de test interne créé pour accueillir le nouveau binaire ; aucun déploiement effectué à ce stade.
- Compilation réussie : `build/app/outputs/bundle/release/app-release.aab` (421,2 MB), versionName 1.1.0, versionCode 7, permission com.android.vending.BILLING présente dans le manifeste fusionné. Certificat du bundle signé identique au certificat d'import Play.
- SHA-256 du fichier AAB : A2C830A7B0C6C28F94412A3A43C68CC0EDF3A7C3BBC49418670446652C508D46. Import lancé dans le brouillon de test interne ; acceptation à vérifier.
- Résultat import version 7 : refus « Le code de version 7 a déjà été utilisé ». Bibliothèque Play vérifiée : versions 6 et 7 déposées le 20 septembre 2026 ; maximum 7. Reconstruction du même code avec `--build-number=8` en cours. Le refus porte sur le numéro, pas sur la signature.
- Version 8 compilée avec succès (345 secondes), manifeste versionCode=8 vérifié. pubspec.yaml mis à 1.1.0+8 pour les compilations suivantes. SHA-256 AAB : 9D16737AD781DAAF5ABB40B47B9BFDF5850C61588A14105393F64CA64916E6DC. Nouvel import lancé dans le même brouillon, renommé « 8 (1.1.0) — validation abonnements ».
- Google Play a accepté le bundle 8 (1.1.0), SDK cible 36, Android API 24 minimum. Brouillon enregistré avec l'artefact. Page des abonnements encore verrouillée immédiatement après import ; poursuite de l'examen du canal interne.
- Release 8 diffusée le 4 octobre à 19:22 sur le canal interne uniquement, ce qui a débloqué la création des abonnements. Aucun testeur interne désigné ; le canal indique Inactif malgré la release « Accessible aux testeurs internes ». Pas de publication publique.
- Google Play : `copiq_premium_monthly` / forfait `monthly` actif, renouvellement mensuel, France 8,99 EUR TTC ; `copiq_premium_yearly` / forfait `yearly` actif, renouvellement annuel, France 79,99 EUR TTC. Disponibilité limitée à la France. Délai de grâce par défaut 7 jours ; blocage automatique 53 jours. Aucune offre d'essai ajoutée.
- RevenueCat : produits Google créés `prod0d77155d93` (copiq_premium_monthly:monthly) et `prod4f1b101d32` (copiq_premium_yearly:yearly), tous deux reconnus Published par le store. Mensuel attaché à premium ; annuel et packages à vérifier après enregistrement.
