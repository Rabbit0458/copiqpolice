# Preparation de la soumission publique - 12 octobre 2026

Ce bilan prend priorite sur les anciens etats pour les points verifies ci-dessous.
Aucune soumission ni publication de l'application effectuee. Le lancement public reste a differer.

Actualisation confidentialite : [bilan du 12 octobre](./CONFIDENTIALITE_PUBLICATION_2026_10_12.md).
Ce complement remplace les constats historiques ci-dessous sur la politique
obsolete, les six categories Apple manquantes et les 221 tests : politiques CMS
actualisees, 18 types Apple renseignes, annonces non personnalisees dans les
sources recentes, 225 tests reussis. Confirmation finale Apple demandee au titulaire.

## Termine et verifie

- Flutter : protection contre les reponses Premium tardives d'un ancien compte ; remise a zero des caches au changement de compte.
- Les rafraichissements simultanes des droits partagent leur requete sans laisser de Future bloquee.
- Une erreur de verification Premium reste une erreur, et non un statut gratuit verifie pour la publicite.
- Date de remise a zero du quota calculee sur window_start + 7 jours.
- Cinq tests de regression ajoutes dans test/core/subscription_refresh_test.dart.
- Deux echecs preexistants corriges : chemin des images de grades sous Windows et debordement du panneau de reprise a 320 px avec texte agrandi.
- Derniere suite Flutter complete : 221 tests reussis, aucun echec. Apres ajout de l'anti-double-clic au bouton de nouvel essai, 9 tests cibles reussis. Derniere analyse Flutter : aucun diagnostic.
- Script Mac scripts/build-ios-public.sh prepare pour analyser, tester et generer l'IPA ; non execute sur Windows. Aucun envoi automatique.

## Scolarite Premium : serveur de production

Le proprietaire a confirme que tous les cours et quiz Scolarite GPX/PA sont Premium.
Deux migrations appliquees via Supabase et conservees dans supabase/migrations :

- 20261012053934_protect_school_premium_reads.sql : lecture des cours publies, questions actives et fragments conditionnee au Premium ; politiques administrateur conservees.
- 20261012054654_enforce_school_rpc_rls.sql : quiz_scolarite_session, quiz_scolarite_counts et organisation_quiz_session passent en SECURITY INVOKER pour respecter ces politiques.

Tests realises sous le role authenticated avec les identites reelles, en transactions annulees :

| Compte | Cours lisibles | Questions lisibles | Fragments lisibles |
| --- | ---: | ---: | ---: |
| Gratuit | 0 | 0 | 0 |
| Premium de verification | 1246 | 49297 | 85125 |
| Administrateur avec quiz.write | 1246 | 49297 | 85125 |
| Second compte administrateur Premium | 1246 | 49297 | 85125 |

Appels RPC sur un module existant : compte gratuit = 0 question et compteur nul ; Premium et administrateur = 3 questions demandees, compteur 2081. Visiteur : appel quiz_scolarite_session refuse (permission denied). Les politiques d'ecriture administrateur n'ont pas ete modifiees ; aucun test destructif ni parcours complet du panel effectue.

Les tables des examens GPX/PA et leurs 10 acces gratuits n'ont pas ete modifiees.
Cette protection concerne l'API distante ; elle ne rend pas secrets les contenus deja embarques dans le binaire ou mis en cache.

## Compte de verification Apple

- Compte choisi explicitement par le proprietaire : kaiswinston2@gmail.com.
- Essai manuel Premium de 30 jours accorde, sans droit administrateur ni paiement.
- Expiration : 11 novembre 2026 a 05:34:36 UTC.
- Marqueur : app_store_review_manual_trial. is_user_premium verifie a true.
- Le champ payment_source conserve la valeur legacy par defaut stripe ; il ne constitue pas une preuve d'achat.
- Aucun mot de passe change, recupere ou inscrit dans ce document. Le proprietaire doit renseigner directement les identifiants de verification dans App Store Connect et tester la connexion sur le nouveau build.

## App Store Connect

- Fiche francaise 1.1.0 enregistree, droits relatifs aux contenus tiers declares selon la confirmation du proprietaire.
- Questionnaire d'age enregistre : violence realiste peu frequente (quelques cas pratiques), sans violence explicite prolongee ni images sexuelles.
- Classification calculee par Apple : 18+ dans 173 pays/regions, 19+ en Coree du Sud ; ancienne classification OS avant 26 : 17+ avec exceptions regionales.
- La cible editoriale 16+ ne remplace pas la classification imposee par Apple. Ne pas modifier artificiellement les reponses pour reduire la classification.
- Preuve : [classification enregistree](./CLASSIFICATION_APPLE_2026_10_12.jpg).
- Aucun build 1.1.0 disponible a associer : seuls les builds 1 a 5 en version 1.0.0 etaient proposes.
- Identifiants de verification encore a renseigner directement chez Apple.
- Contrat d'apps gratuites actif ; contrat d'apps payantes indique Nouveau et demande de mise a jour de l'entite juridique. Aucun contrat accepte par l'agent.
- Statut DSA commercant a completer par le proprietaire ; aucune declaration arbitraire effectuee.
- Confidentialite observee : 7 types declares (nom, email, telephone, autres coordonnees, identifiant utilisateur, emplacement approximatif, historique d'achats). Pas de publication effectuee : revue encore necessaire des contenus utilisateurs/messages/photos, diagnostics et donnees publicitaires selon SDK/configuration effective.

## Restant avant soumission

Complement de preparation : [dossier Apple, controles et passage Mac](./DOSSIER_PUBLICATION_APPLE_2026_10_12.md). Nom de demonstration sauvegarde ; mot de passe encore absent. Hebdomadaire retire du brouillon sur confirmation du proprietaire, mensuel et annuel conserves. Six captures iPad verifiees presentes. Politique publique charge correctement mais contient des mentions Stripe mobile/consentement obsolete a actualiser.

1. Verifier sur appareil les parcours de quota : le double debit par observateur/navigation est corrige, les routes d'exercices nommees attendent l'autorisation avant construction. Les nouvelles sessions internes a une meme page et les navigations non nommees restent a auditer.
2. Tester une vraie publicite recompensee sur le nouveau build : validation serveur signee deployee et activee, rappels AdMob iOS et Android valides et enregistres. L'ancien credit declaratif client est desormais interdit ; un ancien binaire doit etre mis a jour.
3. Tester les achats Sandbox sur iPhone : droits serveur autorises seulement pour une liste de testeurs a expiration, dont le compte Apple choisi. Les essais SQL ne remplacent pas l'achat/restauration natifs.
4. Finaliser les declarations de confidentialite a partir des SDK effectivement actifs et des donnees de communaute.
5. Completer les formalites Apple : entite juridique, contrat payant et DSA. Intervention du proprietaire pour les engagements contractuels.
6. Transferer la copie recente avec ses modifications sur le MacBook ; generer et envoyer un build iOS signe recent (version actuelle 1.1.0+9), puis l'associer a la fiche.
7. Tester sur iPhone : connexion de verification, achats mensuel/annuel, restauration, expiration, acces Premium et absence de pubs ; tester aussi un compte gratuit et la pub recompensee.
8. Verifier captures, informations de verification et etat des abonnements Apple avant soumission. Le delai d'approbation depend d'Apple.

## Securite : controles supplementaires

Conseiller Supabase relance le 12 octobre. Les alertes automatiques ne sont pas toutes des vulnerabilites exploitables : les fonctions administrateur peuvent etre protegees dans leur corps et les tables par RLS. Ne pas revoquer en masse sans analyse, au risque de casser le panel.

- Exposition des fonctions SECURITY DEFINER a reexaminer : [regle Supabase](https://supabase.com/docs/guides/database/database-linter?lint=0029_authenticated_security_definer_function_executable).
- Protection contre mots de passe compromis desactivee : [documentation](https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection).
- Duree OTP superieure a une heure : [recommandations](https://supabase.com/docs/guides/platform/going-into-prod#security).
- Correctifs de securite PostgreSQL disponibles : [procedure de mise a jour](https://supabase.com/docs/guides/platform/upgrading). Planifier avec sauvegarde et verification, pas de mise a jour aveugle pendant la preparation du lancement.

La correction purge/code administrateur du 10 octobre reste documentee separement. Ce bilan ne certifie pas un audit exhaustif ni une validation des paiements reels.

## Complement : quotas, recompenses et achats de test

- ExamAccessGate commun GPX/PA : autorisation avant creation de l'exercice, Future conservee entre reconstructions ; menus, historique et scolarite non debites. Observateur de navigation et raccourci GPX ne consomment plus en parallele.
- Migration 20261012055747_secure_rewarded_ssv_and_sandbox_testers.sql appliquee en production.
- Edge Function admob_reward_ssv deployee : verification ECDSA avec cles officielles Google, challenge opaque lie au compte/bloc/fenetre et expiration de 30 minutes ; transaction unique et anti-rejeu. Aucun email/UID envoye en custom_data.
- AdMob : URL validee puis sauvegardee pour iOS 5012211534 et Android 3779020910. rewarded_ssv_config.enabled=true apres sauvegarde des deux blocs. Preuve Android : ADMOB_SSV_ANDROID_2026_10_12.jpg.
- Tests de privileges : ancien grant_rewarded_request interdit a anon et authenticated ; grant_verified_reward reserve au serveur.
- Tests SQL annules : credit unique, rejeu sans second credit, autre transaction refusee ; Sandbox accepte pour testeur autorise, refuse apres expiration de l'autorisation ou revocation de l'achat. Aucune fausse transaction durable ni paiement reel cree.
- 8 tests de signature AdMob et 9 tests de normalisation RevenueCat reussis (17/17). 4 nouveaux tests Flutter de barriere d'acces ; suite complete 221/221 avant dernier durcissement anti-double-clic.
- Les droits administrateur existants n'ont pas ete modifies par cette migration.

## Complement : confidentialite et compte Apple

- Brouillon Apple enrichi de 7 a 18 types : messages, photos, assistance, autres contenus, identifiant appareil, interactions, publicites, pannes, performance, autres diagnostics et autres donnees (age/date de naissance a rapprocher du profil).
- Messages, photos, assistance et autres contenus configures : fonctionnalite de l'app, lies au compte, pas de suivi publicitaire par ces contenus.
- Autres donnees (birthday du profil) configure : fonctionnalite, lie au compte, sans suivi pour cette categorie. Six categories SDK doivent encore etre parametrees apres verification du suivi. Aucune publication de confidentialite effectuee. Les anciennes finalites des coordonnees et de la localisation restent a rapprocher des usages reels.
- Sentry et PostHog sont des facades inactives dans cette copie ; ne pas leur attribuer de collecte. Les journaux app_logs Supabase sont actifs et lies au compte. AdMob et RevenueCat sont actifs.
- Suivi publicitaire a verifier avant publication : AdRequest par defaut, consentement UMP present, aucune cle NSUserTrackingUsageDescription trouvee dans Info.plist. Ne pas assimiler consentement UMP et autorisation ATT ; verifier la configuration AdMob iOS et le comportement sur appareil.
- Business Apple recontrole : apps gratuites Actif ; apps payantes Nouveau ; mise a jour de l'entite juridique et DSA toujours requises. Formulaires consultes sans envoi, contrat non accepte. Le proprietaire doit confirmer les coordonnees qui seront publiques.
