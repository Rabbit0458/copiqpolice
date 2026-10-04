# Contrôle stores et sécurité — 4 octobre 2026

Copie de travail : C:\Users\kaiso\Desktop\COPIQPOLICEAPP\copiqpolice.

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
