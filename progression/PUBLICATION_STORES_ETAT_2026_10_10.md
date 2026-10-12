# Publication publique COP'IQ - état au 10 octobre 2026

> Mise à jour après correction : les défauts d'autorisation de purge/code administrateur sont corrigés en production et les contrôles fondateur ont été testés. Voir [les preuves et limites des tests](./CORRECTIFS_SECURITE_PURGE_ET_PANEL_2026_10_10.md). Publication encore à différer pour les autres points de [l'audit](./AUDIT_SECURITE_ET_TESTS_2026_10_10.md), notamment les droits Premium serveur. Suite Flutter de l'audit initial : 210 réussites, 2 échecs ; RevenueCat serveur : 9/9. Aucun achat ni suppression réelle exécuté.

Ce bilan est le point d'entrée pour préparer la publication publique. Il remplace les constats historiques contredits par les mises à jour des suivis de septembre et octobre. Une case cochée indique uniquement ce qui est décrit : configuration, code ou contrôle ; elle ne vaut pas validation d'un achat sur appareil.

## Copie de référence

- Application récente : `C:\Users\kaiso\Desktop\COPIQPOLICEAPP\copiqpolice`.
- Ancienne copie : `C:\Users\kaiso\Desktop\copiqpolice`. Ne pas utiliser son absence de RevenueCat ni son ancienne version d'intl pour diagnostiquer l'application récente.
- Dossier du site demandé pour transfert à l'hébergeur : `C:\Users\kaiso\Desktop\fae16dc1`. Un transfert du site ne publie pas les binaires mobiles.
- Sources : `SUIVI_PAIEMENTS_STORES_2026_09_25.md`, `CONTROLE_STORES_SECURITE_2026_10_04.md`, `BUILD_ANDROID_SIGNATURE_ET_ABONNEMENTS.md`, `FICHE_APP_STORE_2026_10_03.md` et `CHANTIER_WEB.md`.

## Terminé ou confirmé

### Code mobile et serveur

- [x] Achats intégrés mobiles et restauration présents via `purchases_flutter: 10.13.1` et `RevenueCatService`. Contrôle des sources le 10 octobre.
- [x] Page d'abonnement récente raccordée à RevenueCat ; anciens points d'achat Stripe bloqués sur iOS/Android selon le suivi du 2 octobre. Stripe reste le parcours web et le portail des anciennes factures.
- [x] Correction locale `intl: 0.20.3` présente dans la copie récente. Le blocage signalé dans l'ancienne copie ne s'applique pas à celle-ci.
- [x] Clés SDK publiques natives et chargement par asset préparés ; aucun secret serveur destiné au bundle, selon le suivi du 2 octobre.
- [x] Droits stores isolés de Stripe, séparation sandbox/production et synchronisation atomique documentées ; migration et tests SQL avec rollback réalisés lors des sessions précédentes.
- [x] `cas_pratique_revenuecat_webhook` vérifié directement sur Supabase le 10 octobre : ACTIVE, version 21. Le code distant contrôle le secret, les applications autorisées, relit RevenueCat et appelle `apply_store_snapshot` avec déduplication.
- [x] Test générique du webhook RevenueCat vers Supabase : HTTP 200 documenté le 2 octobre. Ce test ne valide pas un achat ni l'attribution Premium.
- [x] `delete-user-cascade` vérifié directement sur Supabase le 10 octobre : ACTIVE, version 65, vérification JWT activée. L'appel dans l'app correspond bien à cette fonction.
- [x] Code distant de suppression relu : identité issue du JWT, refus d'un autre user_id, tentative de résiliation Stripe, nettoyage Storage, RPC `purge_user`, suppression Auth. Aucun compte supprimé pour ce contrôle.
- [x] Correctifs de sécurité des anciens setters d'abonnement et des rôles de profil appliqués et testés selon le suivi du 4 octobre.
- [x] Correction serveur de `record_learning_answer` documentée et testée avec rollback le 10 octobre dans `CHANTIER_WEB.md` ; bénéficie au site et à l'app.

### Android / Google Play

État issu du suivi du 4 octobre ; console Google Play non relue le 10 octobre.

- [x] Clé d'import existante récupérée et certificat comparé à Google Play.
- [x] Build signé **1.1.0+8**, accepté et diffusé en **tests internes**. Présence de Google Play Billing vérifiée dans le manifeste.
- [x] Abonnement mensuel actif en France : `copiq_premium_monthly:monthly`, **8,99 EUR/mois**.
- [x] Abonnement annuel actif en France : `copiq_premium_yearly:yearly`, **79,99 EUR/an**.
- [x] Produits Google reconnus Published dans RevenueCat, associés à `premium` et aux packages `$rc_monthly` / `$rc_annual` de l'offre `default`.
- [x] Identifiants Google avec suffixe de forfait couverts par les tests serveur documentés.
- [x] Notifications Google vers RevenueCat configurées et test de réception documenté le 2 octobre.
- [x] Textes français et coordonnées de la fiche Google Play enregistrés selon le suivi du 3 octobre.

### iOS / App Store

État issu des suivis des 2 au 4 octobre ; console Apple non relue le 10 octobre.

- [x] Application `fr.copiq.app` et équipe de signature identifiées ; connexion Apple/RevenueCat documentée comme valide.
- [x] Produits `fr.copiq.premium.monthly` et `fr.copiq.premium.yearly` associés au droit `premium` et à l'offre `default`.
- [x] Prix France documentés : **8,99 EUR/mois**, **79,99 EUR/an** ; mensuel et annuel au niveau 1 du groupe Apple.
- [x] Notifications Apple production et sandbox configurées vers RevenueCat. Aucun reçu Apple réel validé par ce seul réglage.
- [x] Fiche version **1.1.0**, textes, assistance, confidentialité et notes de vérification préparés ; contact de vérification complété le 4 octobre.
- [x] Historique d'achats et identifiant utilisateur ajoutés à App Privacy. Déclaration globale encore à finaliser.

## Restant avant publication publique

### 1. Tests de paiement sur les versions distribuées

- [ ] Ajouter un compte testeur Android et installer le build récent depuis le canal Google Play. Aucun testeur interne désigné au dernier suivi.
- [ ] Produire un build iOS signé récent sur Mac/CI, avec un numéro disponible dans App Store Connect ; l'envoyer sur TestFlight et l'installer. Le dernier build TestFlight contrôlé était 1.0.0 (5), antérieur aux corrections. Vérifier le numéro courant avant compilation plutôt que reprendre automatiquement la cible historique +7.
- [ ] Sur chaque plateforme, tester mensuel et annuel, annulation de la fenêtre d'achat, achat réussi, restauration et changement de compte.
- [ ] Vérifier les droits après achat, fermeture/réouverture, reconnexion et synchronisation Supabase ; confirmer Premium et disparition des publicités dans Scolarité GPX, Scolarité PA, Exam GPX et Exam PA.
- [ ] Tester renouvellement, annulation du renouvellement avec maintien de l'accès payé, expiration, remboursement/révocation et éventuelle période de grâce.
- [ ] Confirmer qu'un achat sandbox ne crée aucun droit de production et qu'un événement répété ne double pas les effets.
- [ ] Consigner les appareils, versions, environnement, résultats et preuves. Aucun achat de bout en bout n'est déclaré validé dans les sources disponibles.

### 2. Compte, contenu et qualité

- [ ] Tester la suppression sur un compte dédié depuis l'app : données, Auth, fichiers et nouvelle connexion impossible. La présence de la fonction est confirmée ; son exécution complète n'a pas été testée le 10 octobre.
- [ ] Vérifier la gestion des abonnements lors d'une suppression : le code distant tente la résiliation Stripe mais continue en cas d'erreur ; vérifier l'information et la gestion adaptées aux abonnements Apple/Google, sans promettre leur résiliation par cette fonction.
- [ ] Contrôler le lien web de demande de suppression et son fonctionnement depuis la fiche Google Play.
- [ ] Reprendre les anomalies app de `CHANTIER_WEB.md` : quiz Histoire/France, double quota et consommation sur menus, champs photolangage, filtrage des questions publiées, libellés techniques et accès serveur aux contenus Premium. Ces signalements restent à reproduire et traiter, sans les considérer tous comme des failles confirmées.
- [ ] Corriger/contrôler la redirection GPX « Contrôles et vérifications d'identité » signalée dans `home_page_gpx_school.dart` ; le correctif documenté concerne le site.
- [ ] Relancer les vérifications Flutter et les tests utiles sur le code final, puis vérifier connexion, quatre parcours, communauté, compte, consentement publicitaire et liens légaux sur appareil.
- [ ] Revoir les avertissements Supabase encore ouverts selon leur impact ; les comptes de fonctions accessibles ne prouvent pas à eux seuls une vulnérabilité. Aucun audit global certifié.

### 3. Fiches et prérequis des stores

- [ ] Apple : finaliser le contrat applications payantes, l'entité juridique et le statut DSA/commerçant signalés en attente au dernier contrôle ; vérifier les éventuelles demandes bancaires/fiscales dans la console.
- [ ] Apple : fournir un compte de démonstration dédié, accessible au contrôle, avec les instructions nécessaires.
- [ ] Apple : terminer App Privacy et la classification d'âge en fonction des données réellement collectées, d'AdMob et des fonctions communautaires ; confirmer les droits sur les contenus.
- [ ] Google Play : terminer/vérifier Sécurité des données, suppression de compte, publicités, classification, accès à l'app et autres rubriques demandées par la console.
- [ ] Vérifier les captures iPhone/iPad/Android contre le build final, les coordonnées et les liens publics depuis chaque fiche.
- [ ] Vérifier les textes légaux effectivement en ligne : achats natifs RevenueCat, parcours web Stripe, prix provenant des stores, AdMob/consentement, âge cible, données communautaires et suppression. Les modifications locales du site ne prouvent pas leur mise en ligne.
- [ ] Google Play : vérifier l'accès production. Les prérequis de test fermé étaient documentés comme satisfaits le 2 octobre ; cela ne prouve pas l'acceptation de la demande d'accès production.

### 4. Envoi en revue et lancement

- [ ] Associer les binaires finaux aux versions de distribution et les abonnements au dossier Apple si la console le demande.
- [ ] Vérifier les territoires (France selon la configuration documentée), prix, notes de version et mode de publication. Apple était configuré en publication automatique après approbation au dernier suivi.
- [ ] Après validation des points précédents, soumettre les dossiers à l'examen Apple et Google, puis traiter leurs éventuels retours.
- [ ] Confirmer la disponibilité publique réelle, surveiller erreurs/achats/droits et conserver les éléments nécessaires à une correction rapide.

## Limites du contrôle du 10 octobre

Lecture des fichiers de progression et du code mobile récent, puis lecture directe des fonctions Supabase de suppression et de synchronisation RevenueCat. Aucun build, achat, remboursement, suppression, envoi en revue ou déploiement effectué dans cette mise à jour documentaire. Stripe n'a pas pu être relu par le connecteur, qui demande une reconnexion ; aucune conclusion nouvelle sur les paiements web en production.

L'application dispose déjà de sa configuration de paiement native. La publication publique reste à valider par les tests sur appareil, les prérequis de console et l'acceptation des stores. Les contrôles partagés concernent les quatre parcours ; aucun test visuel individuel de tous leurs écrans n'est déclaré terminé.
