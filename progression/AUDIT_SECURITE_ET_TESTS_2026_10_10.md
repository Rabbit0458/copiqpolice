# Audit de sécurité et tests COP'IQ - 10 octobre 2026

## Verdict

Mise à jour après correction autorisée : **SEC-01 et SEC-02 corrigés et testés en production le 10 octobre**. Voir [le compte rendu des correctifs](./CORRECTIFS_SECURITE_PURGE_ET_PANEL_2026_10_10.md). Les descriptions ci-dessous conservent les preuves historiques de l'audit initial ; elles ne décrivent plus les droits actuels de ces deux fonctions. Publication publique encore à différer pour les autres points, notamment SEC-03 et les tests en échec.

Audit demandé : lecture du code et de la configuration distante, tests automatisés et contrôles SQL en lecture seule. Aucun correctif applicatif ou changement de permissions en production appliqué pendant cette intervention. Aucun compte supprimé, achat, remboursement, envoi en revue ni publication effectué.

## Périmètre et méthode

- Copie récente : `C:\Users\kaiso\Desktop\COPIQPOLICEAPP\copiqpolice` ; Flutter, services communs, achats RevenueCat, compte, configuration native, tests et sources web associées.
- Supabase : projet `nuoonagnkhbeeymtvrcn`, catalogue des droits, définitions de fonctions ciblées, politiques RLS, politiques Storage et conseiller sécurité.
- Les règles de droits, paiements et quotas sont communes aux quatre parcours Scolarité GPX, Scolarité PA, Exam GPX et Exam PA. Tests de progression/navigation existants exécutés ; pas de navigation exhaustive de tous les écrans ni des 1 409 fichiers.
- Recherche de secrets dans les sources et assets clients ; aucun secret imprimé dans les résultats.
- Références officielles consultées : [fonctions et permissions Supabase](https://supabase.com/docs/guides/database/functions) et [RLS](https://supabase.com/docs/guides/database/postgres/row-level-security). L'index changelog n'était pas accessible via le lecteur web. Aucun changement Supabase implémenté.
- Requêtes de recontrôle sans suppression : `CONTROLES_SECURITE_LECTURE_SEULE_2026_10_10.sql`.

## Problèmes confirmés, par priorité

### SEC-01 / P0 - Purge d'un utilisateur autorisée aux rôles clients (corrigé)

Objet distant : `public.purge_user(uid uuid)`.

Preuves : `SECURITY DEFINER`, propriétaire `postgres`, schéma public utilisable par `anon`, droits EXECUTE vrais pour `anon` et `authenticated`. Le corps vérifie seulement que `uid` n'est pas NULL ; aucun contrôle `auth.uid() = uid`, administrateur ou rôle serveur. Il supprime/modifie les données associées à l'identifiant fourni dans de nombreuses tables.

Impact : un appel direct à la RPC peut demander la purge des données d'un autre utilisateur en contournant la fonction Edge qui vérifie correctement l'identité. Il ne faut pas confondre cette RPC avec la suppression du compte Auth : cette dernière reste effectuée séparément par l'Edge Function. Aucun appel destructif réalisé ; une purge complète pourrait aussi échouer sur des contraintes, ce qui ne corrige pas le défaut d'autorisation.

Correction prioritaire : réserver EXECUTE à `service_role` en retirant PUBLIC, anon et authenticated, conserver l'appel serveur de `delete-user-cascade` et contrôler les autres dépendances. Ajouter une garde serveur interne adaptée et un test de refus pour les rôles clients. Ne pas donner accès direct à la RPC pour réparer un problème de suppression dans l'app.

### SEC-02 / P1 - Modification anonyme d'un code administrateur historique (corrigé)

Objet distant : `public.set_admin_panel_code(p_email text, p_code text)`.

Preuves : `SECURITY DEFINER`, propriétaire `postgres`, EXECUTE autorisé à anon/authenticated. Le corps met à jour `admin_users.admin_code_hash` avec le code fourni, en ciblant l'e-mail, sans vérifier l'identité ni une permission administrative.

Impact confirmé par lecture : modification non autorisée d'un secret de contrôle historique si l'e-mail d'un administrateur est connu. L'usage actuel de ce code n'a pas été trouvé dans les sources récentes ; une prise de contrôle complète du panneau actuel n'est donc pas démontrée.

Correction : désactiver l'accès client à cette fonction historique ou la remplacer par un parcours autorisé, avec contrôle du rôle, MFA et journalisation. Vérifier les autres applications qui l'utilisent avant retrait définitif.

### SEC-03 / P1 - Contenus de scolarité accessibles sans abonnement côté serveur

Objets distants : `scolarite_content_fragments`, `cours_scolarite`, `quiz_scolarite_questions`.

Preuves : lecture des fragments autorisée à tout rôle authenticated (`qual = true`) ; lecture des cours conditionnée seulement à `is_published` ; lecture des questions conditionnée seulement à `is_active`. Aucun contrôle Premium/quota dans ces politiques de lecture.

Contrôle effectué dans une transaction READ ONLY, avec rôle authenticated et UUID synthétique sans abonnement : `fragments_readable_without_subscription = true`, `courses_readable_without_subscription = true`. Aucune donnée de cours ni identité réelle retournée : seulement des booléens. Ce test simule le contexte de politique SQL, sans créer de compte ni ouvrir de session utilisateur réelle.

Impact : un utilisateur connecté peut lire les contenus via l'API en contournant le verrou visuel et le décompte côté client. Concerne les contenus Premium des parcours qui consomment ces tables.

Correction : définir les règles de lecture serveur à partir des droits vérifiés et conserver les accès gratuits voulus ; contrôler toutes les politiques permissives et les RPC de lecture, pas seulement ajouter un filtre dans Flutter. Tester comptes gratuits, payants, expirés, personnel et sandbox avant déploiement.

### SEC-04 / P2 - Récompense publicitaire accordée sur une preuve fournie par le client

Objet distant : `public.grant_rewarded_request(p_nonce text)` ; client `lib/core/services/ad_service.dart:329`.

Preuves : la fonction exige un UID, un nonce d'au moins huit caractères et limite à une récompense toutes les trente secondes, mais ne valide aucune preuve AdMob serveur. Elle décrémente directement le quota utilisé. Le client fabrique lui-même le nonce après son callback local.

Impact : un utilisateur connecté peut appeler la RPC sans regarder de publicité pour récupérer une utilisation, sous réserve des contraintes/limites existantes. Aucun crédit accordé pendant l'audit.

Correction : validation de récompense serveur, identifiant de transaction fournisseur unique et attribution idempotente ; réserver l'écriture au serveur. Le contrôle de fréquence et le nonce client ne prouvent pas le visionnage.

### SEC-05 / P2 - Énumération des e-mails et fonctions historiques trop exposées

`public.auth_email_exists(p_email text)` est accessible à anon et lit directement `auth.users` pour répondre si une adresse existe. Cela permet de confirmer l'inscription d'une adresse sans connexion ; pas de limitation de fréquence dans la fonction SQL. Aucun e-mail réel interrogé pendant l'audit.

`admin_login` est aussi accessible anonymement et compare un mot de passe haché sans limitation de fréquence visible dans son corps. Aucun essai de connexion réalisé ; les protections éventuelles de la passerelle restent à vérifier.

Les fonctions `fn_cp_apply_streak_to_progress`, `fn_cp_check_and_unlock_badges` et `fn_cp_award_xp_for_correction` sont également privilégiées, exécutables par anon et acceptent des identifiants sans garde d'identité dans leur propre corps. Revoir leurs dépendances et réserver les helpers internes au serveur ; ne pas révoquer indistinctement les 97 fonctions signalées sans examiner leur usage.

## Problèmes de fiabilité et tests

### APP-01 / P2 - Débordement sur petit écran avec texte agrandi

Test reproductible : `test/features/home/continue_preparation_panel_test.dart:86`, largeur 320 px, texte x2. Échec avec débordement horizontal de **72 pixels**. Composant partagé : `lib/features/home/widgets/continue_preparation_panel.dart`.

Correction attendue : adapter les lignes/boutons/statistiques à l'espace et au texte agrandi ; conserver le test existant et contrôler les quatre accueils utilisant le panneau. Aucun correctif visuel appliqué dans cet audit.

### TEST-01 / P2 - Faux signal d'images manquantes sous Windows

`test/content/organisation_quiz_question_test.dart:45` utilise `file.path.split('/')` : sous Windows, les chemins natifs utilisent un autre séparateur et le test ne retrouve pas les noms des fichiers.

Les **25 fichiers** sont présents dans `assets/grades`. L'échec ne prouve donc pas des images manquantes dans l'app. Utiliser une API de chemin portable et vérifier chaque préfixe ; ne pas supprimer l'assertion ni fabriquer de nouvelles images.

### APP-02 / P2 - Rafraîchissements forcés concurrents des droits

`lib/core/services/entitlement_service.dart:143` : `force: true` remplace le Completer partagé alors qu'une requête précédente peut encore être en vol. Chaque exécution complète et remet à NULL le même champ ; des réponses inversées peuvent compléter la mauvaise attente puis accéder à un champ NULL. Le cache n'est pas non plus lié explicitement à l'UID dans ce service, et une erreur retourne l'ancien état.

Risque identifié par lecture : attente non terminée, erreur et droits visuels périmés lors des transitions de compte/réseau. Pas de reproduction dédiée de cette course ; ne pas assimiler les logs Supabase non initialisé des tests de widgets à une preuve de cette course.

Correction : conserver un état de requête propre à chaque exécution, sérialiser ou invalider les requêtes anciennes et lier le cache au compte. Ajouter un test de concurrence et de changement de compte.

### WEB-01 / P2 - Dépendances signalées vulnérables

`npm audit --omit=dev --json` : **6 paquets signalés** (1 critical, 4 high, 1 moderate), notamment Next 16.2.9 et des dépendances transitives. Ce total compte des paquets, pas six failles exploitables démontrées.

Le site utilise `output: "export"` et `images.unoptimized: true` : les alertes de serveur Next, Server Actions et optimisation d'images ne prouvent pas une vulnérabilité du dossier statique hébergé. Elles concernent un éventuel serveur Next et/ou la chaîne de compilation selon chaque avis. Aucun exploit tenté. Prévoir une mise à jour compatible et recompiler/tester avant diffusion ; aucun `npm audit fix --force` exécuté.

Avis remontés par npm : [Next/Windows](https://github.com/advisories/GHSA-p293-qw3h-jr36), [Next/ImageResponse](https://github.com/advisories/GHSA-vcvr-r3jv-pc5j), [sharp](https://github.com/advisories/GHSA-wq5f-xc86-pv6w). Références issues du registre, exploitation non vérifiée.

## Résultats des commandes

| Contrôle | Résultat |
| --- | --- |
| Suite Flutter complète, puis nouvelle exécution pour conserver les diagnostics | 210 réussites, 2 échecs identiques ; exit 1 |
| Analyse Flutter | 0 erreur, 1 warning et 1 info ; exit 1 |
| Normalisation RevenueCat serveur | 9/9 réussis |
| Web : validation des contenus et résolution des signalements | 13/13 réussis |
| TypeScript web | Réussi après régénération des types de routes Next |
| Audit npm production | 6 paquets signalés ; pas de correction automatique |
| Recherche de clés secrètes/privées dans les répertoires clients ciblés | Aucun motif de clé Stripe secrète, sb_secret ou clé privée trouvé |
| Recherche structurée de JWT dans 1 933 fichiers clients texte | 1 candidat JWT, 0 rôle service_role |
| Contrôles SQL | Catalogue, fonctions et RLS relus ; simulation de lecture sans abonnement réussie, transaction annulée |

Analyse Flutter : warning `unawaited_return_in_try_block` dans `lib/features/notes/cp_user_notes_service.dart:244` ; info d'import relatif dans `test/core/ad_policy_test.dart:2`. La recherche de secrets est ciblée et ne constitue pas une analyse des binaires, de tous les fichiers privés ou de l'historique Git.

Journal de la seconde exécution complète : `AUDIT_FLUTTER_2026_10_10.log`. Le premier contrôle TypeScript échouait sur trois anciennes routes dans `.next/types/validator.ts` ; `next typegen` a régénéré ces fichiers, puis `tsc --noEmit` a réussi. Aucun changement de source nécessaire pour ce problème de cache généré.

## Protections confirmées et faux positifs écartés

- Les achats intégrés et la restauration existent dans la copie récente ; intl est déjà en 0.20.3.
- `apply_store_snapshot` est réservé à service_role ; les anciens setters `set_subscription_tier` et `set_user_subscription` ne sont plus exécutables par anon/authenticated.
- RLS active sur les tables ordinaires des schémas public/archive/beta inspectés. Les vues ordinaires publiques inspectées utilisent security_invoker ; les deux vues archive restent à examiner. Aucun verdict de fuite à partir de leur seule visibilité GraphQL.
- Les abonnements Stripe sont lisibles seulement par leur propriétaire ; les droits natifs par leur propriétaire ou le personnel autorisé. Les messages communautaires sont soumis à l'appartenance au salon pour leur lecture.
- Le profil impose un rôle initial active via une politique restrictive ; un trigger protège les changements directs de rôle.
- L'Edge Function `delete-user-cascade` existe et vérifie l'identité ; le défaut SEC-01 est l'accès direct à la RPC sous-jacente.
- Le placeholder `CasPratiqueSubscriptionService` lit un drapeau Premium dans user_metadata modifiable par le client, mais aucune utilisation externe de cette classe n'a été trouvée. Dette à retirer, pas contournement actif démontré.
- La politique des questions ne filtre pas publication_status, mais aucune question active non publiée n'était lisible dans la simulation effectuée. Risque de future exposition, pas fuite de brouillon constatée.
- Aucun contournement TLS (`badCertificateCallback`/HttpOverrides) ou autorisation globale HTTP clair trouvé dans les sources natives ciblées. Aucun test réseau dynamique sur appareil.

## Conseiller Supabase

Aucun avis de niveau ERROR renvoyé. Cela n'invalide pas SEC-01/SEC-02 : le conseiller signale les fonctions privilégiées comme WARN sans analyser toute leur logique.

- 97 fonctions SECURITY DEFINER accessibles à anon ; 280 à authenticated. Ces nombres sont des surfaces à examiner, pas autant de failles confirmées.
- 189 objets visibles dans GraphQL pour anon, 236 pour authenticated ; visibilité du schéma distincte de la lecture des lignes.
- 34 tables RLS sans politique : refus d'accès client par défaut, pas ouverture automatique.
- OTP e-mail supérieur à une heure ; protection contre les mots de passe compromis désactivée ; correctifs disponibles pour PostgreSQL 17.4.1.074.
- Extensions citext/pg_trgm dans public. Planifier le durcissement selon les dépendances.

Références : [permissions des fonctions](https://supabase.com/docs/guides/database/database-linter?lint=0028_anon_security_definer_function_executable), [mots de passe](https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection), [mise à niveau PostgreSQL](https://supabase.com/docs/guides/platform/upgrading).

## Ordre de traitement avant lancement

1. **Correction déployée** : purge réservée au serveur et modification historique de code réservée au fondateur/serveur. Tests SQL de refus et de préservation du parcours fondateur réussis. Un test complet de suppression via l'Edge Function sur un compte dédié reste à réaliser ; aucun compte réel supprimé pendant cette intervention.
2. Protéger la lecture des contenus Premium au serveur et l'attribution des récompenses ; contrôler les helpers historiques et l'énumération d'e-mails.
3. Corriger le débordement, le test de chemin Windows et la gestion des rafraîchissements de droits ; relancer les suites.
4. Traiter les dépendances/configurations de sécurité selon leur exposition réelle, puis compiler les versions finales.
5. Effectuer les achats/restaurations et tests de droits sur appareils avant la soumission publique. Les tests unitaires ne valident pas les transactions Apple/Google réelles.

## Limites

Audit ciblé, pas certification exhaustive ni test d'intrusion complet. Aucun test destructif, tentative de prise de contrôle, bruteforce ou lecture de messages privés effectué. Pas de scan CVE exhaustif des dépendances Flutter/natives, pas d'analyse de binaires signés, pas de compilation iOS ni de test d'achat sur appareil. L'hébergement public, les consoles stores et les secrets Stripe n'ont pas été réaudités dans cette intervention.
