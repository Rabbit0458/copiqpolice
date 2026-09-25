# COP'IQ — Suivi de livraison 1.1.0 (build 6)

Dernière mise à jour : 18 septembre 2026  
Statut global : **préparation de la release candidate**  
Branche cible : `codex/release-v6`  
Territoire initial : France  
Langue initiale : français

## 1. Objectif et périmètre figé

La version 1.1.0 (build 6) doit être la dernière version candidate avant la
soumission sur l'App Store et Google Play. Elle couvre uniquement :

- Scolarité GPX ;
- Scolarité PA ;
- Concours GPX ;
- Concours PA ;
- le panel administrateur nécessaire au pilotage de ces quatre parcours ;
- la sécurité, les paiements, les médias, la conformité et l'observabilité
  nécessaires à une publication fiable.

Hors périmètre de la release :

- le module « Je suis actif », qui doit rester invisible hors aperçu owner ;
- les parcours Réserve, qui doivent rester invisibles ;
- la banque Organisation PN de 30 000 questions ;
- la version web complète des quatre parcours ;
- les améliorations secondaires qui ne corrigent ni une panne, ni une faille,
  ni une exigence de boutique.

## 2. Décisions validées

- Version commerciale : `1.1.0`.
- Numéro de build : `6`.
- Abonnements : mensuel à 8,99 € et annuel à 79,99 €.
- Aucun essai gratuit.
- Un droit unique RevenueCat : `premium`.
- Produits natifs : `copiq_premium_monthly` et
  `copiq_premium_yearly`.
- RevenueCat unifie StoreKit et Google Play Billing.
- Stripe reste la solution d'achat du site web.
- Les abonnements Stripe, Apple, Google et les droits offerts sont reconnus
  par le même moteur d'autorisation Supabase.
- Compte COP'IQ obligatoire avant tout achat.
- Codes promotionnels Apple, Google, Stripe et codes internes COP'IQ.
- Publicités uniquement pour les comptes gratuits, sans interstitiel forcé.
- Publicités non personnalisées par défaut avec consentement Google UMP.
- Sentry pour les erreurs et PostHog pour les événements anonymisés.
- Médias pédagogiques lourds déplacés vers un bucket public Supabase avec URL
  stable, cache persistant et repli visuel.
- Publication progressive : 10 %, 25 %, 50 %, puis 100 %.

## 3. Règle de suivi

### Tableau Trello opérationnel

Le tableau `Application COP'IQ` contient cinq listes dédiées à la V6 :

- `🚀 V6 — À faire` ;
- `🛠️ V6 — En cours` ;
- `🧪 V6 — Validation` ;
- `🚧 V6 — Bloqué` ;
- `✅ V6 — Validé`.

Treize cartes `[V6-00]` à `[V6-12]` reprennent les phases de ce document. Ce
fichier reste la source de vérité détaillée ; Trello sert au statut quotidien.

Chaque tâche terminée doit comporter une preuve :

- lien vers le commit ou liste des fichiers modifiés ;
- commande/test exécuté et résultat ;
- capture d'écran pour les validations visuelles ;
- référence de migration ou de fonction déployée ;
- lien TestFlight/Google Play pour les validations boutique.

Une tâche n'est pas considérée terminée si elle a seulement été codée sans
test reproductible.

## 4. Phase 0 — Sécuriser le point de départ

- [ ] Créer la branche `codex/release-v6` sans supprimer les changements existants.
- [ ] Inventorier les 5 888 changements locaux et distinguer source, génération et déchets de build.
- [ ] Sauvegarder l'état Git initial et la liste complète des fichiers modifiés.
- [ ] Exporter la liste des 349 migrations Supabase distantes.
- [ ] Rapprocher les migrations distantes des 171 fichiers SQL locaux.
- [ ] Récupérer ou documenter les migrations distantes absentes du dépôt.
- [ ] Récupérer les dix Edge Functions distantes sans source locale correspondante.
- [ ] Examiner les sept Edge Functions locales qui ne sont pas déployées.
- [ ] Produire un inventaire exact local/distant des fonctions et migrations.
- [ ] Préparer une procédure de sauvegarde et de rollback avant toute migration.

Critère de sortie : un tiers peut reconstruire l'état de production à partir
du dépôt et des secrets documentés.

## 5. Phase 1 — Corriger les blocages actuels

- [ ] Corriger l'overflow de « Continue ta préparation » à 320 px avec texte à 200 %.
- [ ] Corriger ou simuler correctement `app_links` dans le test de la page Profil.
- [ ] Obtenir 100 % de réussite sur la suite Flutter.
- [ ] Corriger les 103 erreurs ESLint du panel.
- [ ] Traiter ou justifier les 70 avertissements ESLint.
- [ ] Corriger le défaut `git diff --check` restant.
- [ ] Remplacer ou masquer la référence pédagogique « Article XXX ».
- [ ] Rechercher les placeholders, contenus de test et médias cassés accessibles.
- [ ] Vérifier que Réserve est invisible, y compris par lien profond et ancien choix local.
- [ ] Vérifier que « Je suis actif » est invisible pour tous les comptes standards.

Critère de sortie : analyses, tests et lint sans erreur bloquante.

## 6. Phase 2 — Sécurité Supabase

- [ ] Retirer l'accès direct des utilisateurs aux réponses de `cas_pratique_answer_keys`.
- [ ] Ajouter des tests SQL prouvant l'impossibilité de lire les réponses attendues.
- [ ] Auditer les fonctions `SECURITY DEFINER` exécutables par `anon` et `authenticated`.
- [ ] Révoquer toutes les exécutions non nécessaires.
- [ ] Vérifier le `search_path` et les noms qualifiés des fonctions privilégiées.
- [ ] Classer les 32 tables RLS sans policy : volontaire ou anomalie.
- [ ] Contrôler l'exposition GraphQL des tables publiques.
- [ ] Ajouter les index utiles aux clés étrangères réellement sollicitées.
- [ ] Ajouter une clé primaire adaptée à `community_reactions`.
- [ ] Réduire ou justifier les policies permissives multiples.
- [ ] Activer la protection contre les mots de passe compromis.
- [ ] Réduire la durée de validité des OTP.
- [ ] Planifier la mise à jour PostgreSQL après sauvegarde.
- [ ] Relancer les advisors Supabase sécurité et performance.
- [ ] Documenter chaque alerte restante et sa justification.

Critère de sortie : aucune faille critique ou élevée non acceptée explicitement.

## 7. Phase 3 — Migration des médias vers Supabase Storage

- [ ] Inventorier tous les assets avec taille, dimensions, format et usages.
- [ ] Identifier les médias pédagogiques lourds à externaliser.
- [ ] Conserver localement logo, icônes et visuels indispensables au démarrage.
- [ ] Créer la structure stable `courses/<parcours>/<module>/<fichier>.webp`.
- [ ] Convertir et redimensionner les médias sans perte visuelle perceptible.
- [ ] Calculer une empreinte pour détecter doublons et collisions.
- [ ] Créer ou vérifier le bucket public destiné aux médias pédagogiques.
- [ ] Uploader sans écraser un objet différent portant le même nom.
- [ ] Vérifier chaque URL publique par requête HTTP avant raccordement.
- [ ] Générer l'inventaire fichier local → objet Storage → URL publique.
- [ ] Remplacer les références dans Scolarité GPX et PA.
- [ ] Remplacer les références dans Concours GPX et PA.
- [ ] Ajouter cache persistant, chargement progressif et retry.
- [ ] Ajouter un visuel COP'IQ de secours.
- [ ] Signaler les médias indisponibles dans le panel administrateur.
- [ ] Conserver temporairement les copies locales pendant la recette.
- [ ] Mesurer la taille Android et iOS après migration.
- [ ] Supprimer les grosses copies locales uniquement après validation du build 6.

Critère de sortie : aucun média cassé, fonctionnement hors connexion après mise
en cache et réduction substantielle du poids livré.

## 8. Phase 4 — Abonnements natifs et droits Premium

### 8.1 RevenueCat et produits

- [x] Créer/configurer le projet RevenueCat COP'IQ.
- [ ] Déclarer les applications iOS et Android.
- [ ] Utiliser l'UUID Supabase comme App User ID RevenueCat.
- [x] Créer l'entitlement `premium`.
- [x] Créer l'offering courant.
- [ ] Raccorder `copiq_premium_monthly` à 8,99 €.
- [ ] Raccorder `copiq_premium_yearly` à 79,99 €.
- [x] Configurer d'abord les environnements sandbox/test.
- [ ] Documenter les clés publiques et conserver les secrets uniquement côté serveur.

État au 19/09/2026 : le projet RevenueCat `COP'IQ` utilise désormais le droit
canonique `premium`. L'offering `default` contient uniquement les packages
mensuel et annuel du Test Store ; le package hebdomadaire a été retiré. Les
produits réels Apple et Google restent à raccorder après validation des deux
configurations boutique.

### 8.1.1 Connexion Google Play à RevenueCat

- [x] Créer le projet Google Cloud dédié `copiq-revenuecat`.
- [x] Activer Google Play Android Developer API.
- [x] Activer Google Play Developer Reporting API.
- [x] Activer Cloud Pub/Sub API.
- [x] Créer le compte de service RevenueCat dédié.
- [x] Accorder uniquement `Pub/Sub Editor` et `Monitoring Viewer` côté Google Cloud.
- [ ] Inviter le compte de service dans Google Play avec les droits minimaux RevenueCat.
- [ ] Transmettre une seule clé JSON active à RevenueCat, sans l'enregistrer dans Git.
- [ ] Supprimer les clés Google générées mais non utilisées après validation de la clé conservée.
- [ ] Ajouter l'application Google Play `fr.copiq.app` dans RevenueCat.
- [ ] Importer un AAB signé intégrant Google Play Billing.
- [ ] Créer et activer les abonnements mensuel et annuel dans Google Play.
- [ ] Raccorder les produits Google Play aux packages RevenueCat mensuel et annuel.
- [ ] Configurer et valider les notifications développeur en temps réel.

Blocage constaté au 19/09/2026 : Google Play indique que COP'IQ ne propose
encore aucun abonnement et demande d'abord l'import d'un nouvel APK/AAB. La
création des produits Android doit donc suivre l'intégration du SDK et la
génération du build 6, pas la précéder.

### 8.2 Application mobile

- [ ] Intégrer/configurer le SDK RevenueCat iOS.
- [ ] Intégrer/configurer le SDK RevenueCat Android.
- [ ] Identifier RevenueCat après authentification Supabase.
- [ ] Déconnecter RevenueCat lors du changement de compte.
- [ ] Interdire l'achat sans compte COP'IQ.
- [ ] Créer l'écran Premium Gratuit/Premium.
- [ ] Afficher les prix localisés fournis par les boutiques.
- [ ] Implémenter l'achat mensuel.
- [ ] Implémenter l'achat annuel.
- [ ] Implémenter « Restaurer mes achats ».
- [ ] Ajouter une restauration automatique après connexion.
- [ ] Ajouter « Gérer mon abonnement » selon Apple, Google ou Stripe.
- [ ] Détecter et avertir en cas de double abonnement.
- [ ] Supprimer toute publicité lorsqu'un droit Premium est actif.
- [ ] Conserver le dernier droit vérifié hors connexion pendant sept jours maximum.
- [ ] Ne jamais faire confiance à un simple booléen Premium modifiable côté client.

### 8.3 Supabase et webhooks

- [ ] Créer le schéma canonique des droits multi-fournisseurs.
- [ ] Conserver séparément provenance, produit, période, statut et événements.
- [ ] Vérifier les signatures des webhooks RevenueCat et Stripe.
- [ ] Traiter activation, renouvellement, échec, expiration, remboursement et révocation.
- [ ] Garantir l'idempotence des webhooks.
- [ ] Reconnaître les abonnés Stripe existants sur mobile.
- [ ] Empêcher qu'un achat boutique soit lié à plusieurs comptes COP'IQ.
- [ ] Ajouter une procédure owner de récupération sécurisée.
- [ ] Lancer une réconciliation automatique quotidienne.
- [ ] Créer les alertes de webhook, doublon, remboursement et incohérence.
- [ ] Ajouter les statistiques MRR, ARR, conversion, churn et remboursements.

### 8.4 Droits offerts et codes

- [ ] Ajouter les durées 7 jours, 1/3/6 mois, 1 an et permanent.
- [ ] Réserver l'attribution manuelle à owner+AAL2.
- [ ] Exiger un motif et journaliser chaque action.
- [ ] Séparer droits payants et droits offerts.
- [ ] Appliquer automatiquement le droit le plus avantageux.
- [ ] Créer les codes internes avec durée, expiration et quota d'utilisation.
- [ ] Supporter les offres Apple, Google et Stripe sans les confondre avec les codes internes.

Critère de sortie : achats, restauration, renouvellement, expiration,
remboursement et reconnaissance Stripe validés sur les deux plateformes.

## 9. Phase 5 — Suspension, consommation et modération

- [ ] Séparer sanction communautaire et droit d'accès pédagogique payé.
- [ ] Une sanction forum ne doit pas supprimer l'accès aux cours Premium.
- [ ] Retirer Premium automatiquement seulement après expiration, remboursement ou révocation fournisseur.
- [ ] Geler temporairement les opérations sensibles en cas de soupçon de fraude.
- [ ] Exiger une décision humaine avant une sanction contractuelle définitive.
- [ ] Enregistrer faits, preuves, motif, auteur, durée et voies de contestation.
- [ ] Envoyer une notification motivée à l'utilisateur sanctionné.
- [ ] Ajouter une procédure de recours et de restauration.
- [ ] Adapter CGU, CGV et politique de confidentialité.
- [ ] Faire valider les textes finaux par un professionnel du droit.

## 10. Phase 6 — Publicité, consentement et observabilité

- [ ] Conserver uniquement bannières discrètes et publicités récompensées.
- [ ] Interdire les interstitiels forcés.
- [ ] Désactiver AdMob pour Premium.
- [ ] Intégrer Google UMP pour le consentement européen.
- [ ] Rendre le refus aussi simple que l'acceptation.
- [ ] Ajouter le réglage de consentement au profil.
- [ ] Utiliser des publicités non personnalisées par défaut.
- [ ] Configurer Sentry sans donnée pédagogique ou personnelle sensible.
- [ ] Configurer PostHog avec consentement et événements anonymisés.
- [ ] Interdire e-mail, nom, questions, réponses et contenu communautaire dans les événements.
- [ ] Vérifier App Privacy iOS et Data Safety Android.
- [ ] Ajouter/valider le manifeste de confidentialité iOS.

## 11. Phase 7 — Panel administrateur

- [ ] Corriger le lint complet et les avertissements exploitables.
- [ ] Vérifier responsive ordinateur et tablette.
- [ ] Ajouter le centre Premium multi-fournisseurs.
- [ ] Ajouter l'attribution manuelle et les codes COP'IQ.
- [ ] Ajouter les alertes de paiement et de médias.
- [ ] Ajouter MRR, ARR, conversion, churn, remboursements et répartition par fournisseur.
- [ ] Ne jamais inventer une statistique absente.
- [ ] Afficher source, fraîcheur, période et taille d'échantillon.
- [ ] Protéger toutes les actions sensibles par owner+AAL2.
- [ ] Vérifier un compte owner autorisé et un compte standard refusé.
- [ ] Vérifier la modification réelle d'un cours GPX et d'un cours PA.
- [ ] Régénérer `fae16dc1` seulement après validation.

## 12. Phase 8 — Recette des quatre parcours

À exécuter sur Scolarité GPX, Scolarité PA, Concours GPX et Concours PA :

- [ ] Connexion, déconnexion et session expirée.
- [ ] Reprise automatique du dernier parcours choisi.
- [ ] Rafraîchissement du mode picker depuis Supabase.
- [ ] Recherche et navigation principales.
- [ ] Cours, images distantes, cache et repli hors connexion.
- [ ] Tous les niveaux et difficultés de quiz.
- [ ] Sélection du nombre de questions.
- [ ] Arrêt d'un quiz après seulement quelques réponses.
- [ ] Calcul uniquement sur les réponses réellement données.
- [ ] Historique, carnet d'erreurs, progression et reprise.
- [ ] Favoris et forum.
- [ ] Profil, export et suppression de compte.
- [ ] CGV et avertissement légal.
- [ ] Notifications acceptées et refusées.
- [ ] Taille de texte à 200 %, contraste et cibles tactiles.
- [ ] Écrans étroits et grandes hauteurs.
- [ ] Aucune apparition de Réserve ou « Je suis actif ».

## 13. Phase 9 — Matrice de paiement

- [ ] Achat mensuel Apple sandbox.
- [ ] Achat annuel Apple sandbox.
- [ ] Achat mensuel Google test.
- [ ] Achat annuel Google test.
- [ ] Paiement Stripe mensuel test.
- [ ] Paiement Stripe annuel test.
- [ ] Carte refusée et authentification 3D Secure Stripe.
- [ ] Restauration Apple.
- [ ] Restauration Google.
- [ ] Renouvellement Apple/Google.
- [ ] Échec de renouvellement et retrait du droit lorsque l'entitlement devient inactif.
- [ ] Annulation avec maintien de l'accès jusqu'à la fin de la période payée.
- [ ] Remboursement/révocation et retrait du droit.
- [ ] Webhook envoyé deux fois sans double effet.
- [ ] Double abonnement détecté et avertissement affiché.
- [ ] Droit offert puis expiration.
- [ ] Code interne valide, expiré, épuisé et déjà utilisé.
- [ ] Prix localisés et textes légaux corrects.

## 14. Phase 10 — Builds et boutiques

- [ ] Passer `pubspec.yaml` à `1.1.0+6` seulement après validation du code.
- [ ] Faire échouer le build Android si la clé de production manque.
- [ ] Générer un AAB release signé.
- [ ] Mesurer la taille téléchargée par appareil.
- [ ] Générer une IPA/App Store Archive signée.
- [ ] Vérifier symboles, dSYM et rapports de crash.
- [ ] Compléter les fiches App Store Privacy et Google Data Safety.
- [ ] Préparer les notes de version françaises.
- [ ] Envoyer le build sur Google Play Internal Testing.
- [ ] Envoyer le build sur TestFlight.
- [ ] Tester sur iPhone réel.
- [ ] Tester Android sur émulateurs et appareil d'un bêta-testeur réel.
- [ ] Confirmer que le même build est disponible sur les deux plateformes.
- [ ] Préparer Supabase pour le build 6 sans activer l'obligation prématurément.

## 15. Phase 11 — Déploiement progressif

- [ ] Envoyer e-mail et message in-app après disponibilité sur les deux boutiques.
- [ ] Déployer à 10 % et observer pendant 24 heures.
- [ ] Passer à 25 % et observer pendant 24 heures.
- [ ] Passer à 50 % et observer pendant 48 heures.
- [ ] Passer à 100 % si tous les indicateurs sont sains.
- [ ] Suspendre automatiquement la progression en cas de crashs, paiements ou connexions anormaux.
- [ ] Activer la mise à jour obligatoire uniquement après confirmation des deux stores.
- [ ] Archiver les preuves de publication et le manifeste final.

## 16. Conditions de GO / NO-GO

### GO

- [ ] Tous les tests automatisés passent.
- [ ] Aucun lint bloquant.
- [ ] Aucun secret exposé.
- [ ] Aucune faille critique ou élevée non traitée.
- [ ] Aucun crash bloquant connu.
- [ ] Les quatre parcours passent la recette.
- [ ] Les abonnements fonctionnent sur Apple, Google et Stripe.
- [ ] Les restaurations, expirations et remboursements sont validés.
- [ ] Aucun média requis n'est cassé.
- [ ] Réserve et « Je suis actif » restent invisibles.
- [ ] Les textes légaux et déclarations boutiques sont validés.
- [ ] Les builds signés proviennent d'un état Git identifié.

### NO-GO automatique

- fuite de réponses attendues ou de données personnelles ;
- achat encaissé sans droit Premium ;
- droit Premium accordé sans preuve fournisseur ou attribution owner auditée ;
- impossibilité de restaurer un achat ;
- crash au démarrage, connexion impossible ou perte de progression ;
- build signé avec une clé incorrecte ;
- contenu Réserve/Actif accessible publiquement ;
- média essentiel manquant ;
- impossibilité de reproduire le build soumis.

## 17. Accès externes requis pendant l'exécution

- [ ] Accès owner Supabase avec AAL2.
- [ ] Accès App Store Connect et Apple Developer.
- [x] Accès Google Play Console — compte COP'IQ vérifié le 19/09/2026.
- [x] Accès RevenueCat — projet COP'IQ vérifié le 19/09/2026.
- [ ] Accès Stripe test puis live.
- [ ] Accès au domaine et au fournisseur e-mail COP'IQ.
- [ ] Clés de signature Android et certificats/profils iOS.
- [ ] Compte bêta-testeur Android réel.

Les secrets ne doivent jamais être copiés dans ce document, Trello, Git ou une
capture d'écran. Ils doivent rester dans les coffres de secrets prévus.

## 18. Journal des preuves

| Date | Phase | Tâche | Preuve | Résultat | Réserve |
|---|---|---|---|---|---|
| 18/09/2026 | Cadrage | Décisions release 1.1.0+6 | Conversation propriétaire | Validé | Accès externes à connecter pendant l'exécution |
| 18/09/2026 | Pilotage | Création du tableau Trello V6 | 5 listes et 13 cartes `[V6-00]` à `[V6-12]` | Validé | Le détail reste dans ce fichier |
| 18/09/2026 | Paiements | Ouverture de RevenueCat | `https://app.revenuecat.com/login` | Bloqué | Connexion manuelle du propriétaire nécessaire |
| 19/09/2026 | Paiements | Normalisation RevenueCat | Entitlement `premium`, offering `default` mensuel + annuel | Validé en Test Store | Produits réels Apple/Google encore à raccorder |
| 19/09/2026 | Android | Socle Google Cloud RevenueCat | Projet `copiq-revenuecat`, 3 API activées, compte de service et rôles minimaux | Validé | Invitation Play et clé RevenueCat à finaliser |
| 19/09/2026 | Android | Audit des abonnements Google Play | Page Abonnements de `fr.copiq.app` | Bloqué par le build | Google réclame d'abord un AAB/APK intégrant la facturation |
