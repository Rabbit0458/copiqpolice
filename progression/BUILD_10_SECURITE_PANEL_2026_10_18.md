# Build 10 - securite et panel - 18 octobre 2026

## Perimetre confirme

Source du panel : copiq-web. Dossier FTP : fae16dc1 dans COPIQPOLICEAPP/copiqpolice.
L'ancien dossier Desktop/fae16dc1 n'est pas modifie.
Les protections communes couvrent Exam GPX, Exam PA, Scolarite GPX, Scolarite PA,
ainsi que les messages utilisant les tables community_*.

## Serveur deploye

- Les auteurs ne peuvent ni restaurer un contenu masque/retire ni modifier les
  champs de moderation, l'auteur, les compteurs ou le rattachement d'un contenu.
- Les sanctions actives interdisent les editions correspondantes, y compris
  celles d'anciens contenus. La suppression par l'auteur reste autorisee.
- Les RPC de moderation conservent leurs controles de scope et leur journal.
- Le moderateur n'obtient plus les permissions generales de gestion de l'app.
- Un administrateur ne peut pas retrograder un fondateur. Les protections sur
  user_profiles et admin_users empechent le retrait du dernier fondateur.
- Consultation des abonnements et octroi/retrait des cadeaux : fondateur seul.
  L'ancien writer set_user_subscription n'est plus executable par les clients.
- Les achats sont lus depuis store_entitlements, deja alimente par le webhook
  RevenueCat. Le webhook existant n'a pas ete remplace ni redeploye.
- Les cadeaux ne modifient pas store_entitlements. Les achats Stripe historiques
  ne peuvent pas etre ecrases par le formulaire de cadeau.
- Purge User reste non executable par anon et authenticated.

Migrations appliquees :

- 20261018090322_build10_forum_founder_subscription_security.sql
- 20261018103621_build10_author_guard_variable_fix.sql
- 20261018103756_build10_billing_write_boundaries.sql
- 20261018103904_build10_preserve_account_cleanup.sql
- 20261018104532_build10_subscription_status_labels.sql
- 20261018104621_build10_restrict_account_directory.sql

## Panel

- Navigation et acces direct a Abonnements reserves au fondateur.
- Moderateur : acces au forum uniquement ; les autres pages ne montent pas leurs
  composants ni leurs requetes lorsqu'elles sont ouvertes directement.
- Sources Apple/Google/Stripe/cadeau, environnement, echeance, verification et
  arret du renouvellement visibles. Actualiser relit le serveur, sans forcer une
  interrogation des boutiques ; une livraison webhook reste necessaire.
- Retirer le cadeau conserve les droits verifies des boutiques.
- Correction d'un controle de role du dossier utilisateur : il utilisait le
  role de la cible au lieu du role du membre du staff connecte.
- Onglet facturation et export reserves au fondateur pour les donnees bancaires;
  les autres fonctions du dossier restent accessibles aux administrateurs.

## Verification executee

- flutter test : 229 tests reussis.
- flutter analyze : aucune anomalie.
- Tests web existants : 20 tests reussis.
- TypeScript, ESLint cible et compilation Next : reussis.
- audit:release : 98 HTML et 90 bundles controles, audit valide.
- Test SQL supabase/tests/build10_security_regression.sql : PASS. Transactions
  annulees integralement ; aucune publication ou sanction de test conservee.
- Creation/edition/suppression testees dans les quatre espaces GPX/PA.
- Refus des restaurations auteur, epinglage, editions sanctionnees ; maintien
  des suppressions et des restaurations par un moderateur autorise.
- Refus des changements fondateur par admin et du retrait du dernier fondateur.
- Refus des cadeaux par admin/moderateur, acces fondateur conserve.
- Sandbox sans autorisation : pas de Premium. Achat Google de production simule
  en transaction : retirer un cadeau conserve le Premium et sa source boutique.
- Tests navigateur Playwright : owner/admin/moderator, captures bureau et mobile,
  aucune erreur JavaScript ; donnees de test interceptees, pas de vraie connexion.
  Script : copiq-web/tests/build10-admin-browser.mjs.

## Encore a faire avant validation publique

- Envoyer le dossier FTP regenere sur l'hebergeur. Pas d'envoi FTP effectue ici.
- Generer et envoyer le build iOS 10 depuis le Mac ; aucun IPA/AAB cree ici.
  La version locale est preparee en 1.1.0+10 pour la generation sur le Mac.
- Achats reels de test Apple ET Android : achat, restauration, changement de
  compte, renouvellement, expiration/remboursement et livraison du webhook.
- Controle publicitaire sur appareil : gratuit avec annonces et recompense
  serveur, Premium sans annonces. Les tests locaux ne prouvent pas la diffusion.
- P2 deja identifie : community_can_publish ne prend pas encore en charge le mode
  actif. Correction separee a prevoir avant ouverture de ce forum.
- Conseils Supabase : correctifs PostgreSQL disponibles, protection contre les
  mots de passe compromis desactivee, expiration OTP trop longue. Ne pas lancer
  une maintenance de base de production sans preparer sauvegarde et fenetre.
  Autres avertissements de linter sur les endpoints historiques a trier : ceci
  n'est pas une certification de securite exhaustive de toute la base.

Sources de remediation :
https://supabase.com/docs/guides/platform/upgrading
https://supabase.com/docs/guides/auth/password-security
https://supabase.com/docs/guides/platform/going-into-prod#security
