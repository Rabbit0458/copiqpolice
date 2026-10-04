# Paiements stores — état actualisé le 2 octobre 2026

## État de reprise du 2 octobre — prioritaire sur le journal historique ci-dessous

### Transfert Mac et build 7 — dernière mise à jour

- L’utilisateur choisit de compiler sur son Mac avec Xcode. Guide : `LANCER_BUILD_7_SUR_MAC.md` ; préparation : `scripts/prepare-mac-ios.sh`. Version conservée : 1.1.0+7.
- Les deux clés publiques RevenueCat sont maintenant embarquées comme asset ; initialisation native sans dart-define possible, avec validation du préfixe de plateforme. Les paramètres explicites restent prioritaires. Aucun secret serveur ajouté au bundle.
- GitHub reconnecté et vérifié : la liste Actions affiche 18 anciens runs CI en échec, dernier commit e55f226 du 25 septembre. Cette reconnexion ne signifie pas que la copie locale modifiée a été poussée ou compilée.
- Aucun build iOS réalisé sur ce PC Windows. Les achats sur l’iPhone et la publication restent à valider après compilation.
- Vérifications locales : 17 tests réussis (chargement réel des assets iOS/Android sans defines, configuration invalide, plans, sérialisation achat/identité, calendrier publicitaire). Analyse ciblée des trois fichiers Dart modifiés et syntaxe Bash vérifiées. Portée : service natif partagé à l’initialisation, commun aux quatre parcours GPX/PA scolarité et examens ; aucune validation visuelle ou transaction sur appareil dans cette étape.

### Notifications terminées — mise à jour prioritaire

### Préparation des tests sur appareils — 2 octobre

- Utilisateur équipé d’un iPhone. Aucun mobile connecté au PC détecté par Flutter. Émulateur Android `Pixel_9_Pro_XL` disponible avec image Google Play, non lancé ; il ne remplace pas le catalogue d’abonnements Google encore à compléter.
- TestFlight contrôlé : dernière version disponible **1.0.0 (5)**, chargée le **8 septembre 2026 à 03:58** selon Apple ; 27 installations, expiration annoncée dans 66 jours. Ce build précède les corrections actuelles, donc ne valide pas leur fonctionnement. Build cible local : 1.1.0+7.
- Équipe de signature confirmée dans les métadonnées Apple : `W2S6S626U9`, bundle `fr.copiq.app`, identiques au projet Xcode local.
- Xcode Cloud affiche l’écran de démarrage, aucune chaîne configurée. GitHub Actions accessible publiquement mais session déconnectée ; connexion demandée pour vérifier les secrets existants.
- Piste Mac retrouvée dans `PROMPT_REPRISE_CLAUDE_CODE_MODULE_ACTIF_A_Z.md` : compilation iOS sans signature exécutée historiquement dans `/Users/kaiso/Desktop/copiqpolice`. Disponibilité du Mac demandée. Aucun certificat recréé et aucune clé existante révoquée.
- Achat de validation non lancé : il faut d’abord livrer le build courant. Ensuite vérifier achat mensuel/annuel, annulation utilisateur, restauration, changement de compte, expiration/remboursement et séparation sandbox/production dans RevenueCat, Supabase et les quatre parcours. Ne pas marquer ces scénarios réussis à partir du seul HTTP 200 du webhook.

### État des notifications

- Droit Diffuseur Pub/Sub accordé au compte officiel Google Play, uniquement sur `Play-Store-Notifications`. Test Google Play reçu dans RevenueCat le 2 octobre à 20:19 UTC. Preuve : `preuves-stores/google-notifications-received-2026-10-02.png`.
- Secrets de synchronisation configurés dans Supabase ; secret de webhook partagé uniquement avec RevenueCat, clé SDK publique pour la lecture des abonnements, applications iOS/Android explicitement autorisées côté serveur. Aucune clé secrète RevenueCat V1 créée.
- Fonction `cas_pratique_revenuecat_webhook` déployée, version 21 ACTIVE. Authentification personnalisée par secret, vérification RevenueCat et synchronisation native isolée. Huit tests de normalisation réussis. Contrôles HTTP distants : GET 405, POST non authentifié 401.
- Webhook RevenueCat `COPIQ Supabase Subscription Sync`, ID `whintgrb7749ea06d`, tous événements, production et sandbox, destination Supabase COP’IQ. Test officiel reçu le 2 octobre à 21:27:54 UTC : **HTTP 200**, `received:true,test:true`. Preuve : `preuves-stores/revenuecat-supabase-test-200-2026-10-02.png`.
- Notifications Apple production/sandbox déjà enregistrées vers RevenueCat. Aucun achat ni notification Apple réelle validé. Le test générique RevenueCat n’exerce pas la lecture d’un abonnement ni l’attribution de droits : tests sur appareils toujours requis.
- Les mentions ci-dessous indiquant « droit Google en attente », « nouveau webhook non déployé » ou accord serveur manquant sont désormais historiques. Aucun build signé ni publication store effectué.

- Export administrateur régénéré dans `fae16dc1/admin/informations/` avec les ressources `_next/`. Sauvegarde de l’ancien dossier conservée. 17 routes critiques, 18 ressources de la page et liaison RPC compilée vérifiées. Lecture HTTP des réglages en production réussie ; panneau et mobile pointent sur le même Supabase. Aucun transfert hébergeur effectué.

- Publicités : calendrier et intervalle configurables ajoutés au code du panneau (Centre d’information → Publicités) et au service Flutter commun. Base Production mise à jour, défaut 20 minutes sans limites de dates, propriétaire + MFA requis pour écrire. Six tests Flutter, analyse, TypeScript et build web réussis ; tests SQL avec rollback réussis. Ni panneau ni nouveau build mobile déployés. 211 dialogues de résultat contrôlés statiquement sur les quatre parcours ; écrans autonomes non assimilés à ces dialogues. Guide : `PUBLICITES_REGLAGES_ET_PUBLICATION.md`.

- Apple : connexion RevenueCat toujours valide. Notifications production et Sandbox enregistrées vers RevenueCat et vérifiées. Preuve : `preuves-stores/apple-notifications-2026-10-02.png`. Aucun reçu testé de bout en bout.
- Classement Apple déjà corrigé le 26 septembre : mensuel et annuel au niveau 1, historique hebdomadaire au niveau 2. Groupe ajouté au brouillon. Fiche version 1.0 sans build associé ; compte de vérification et coordonnées à compléter.
- Google : accord explicite reçu le 2 octobre ; clé JSON créée pour le compte de service existant puis transférée uniquement à RevenueCat COP’IQ. ID `73a06d1febc3d70ebce115853aebef88702bf290`, trois anciennes clés conservées. Fichier privé hors dépôt dans Téléchargements. RevenueCat affiche **Valid credentials**. Aucun secret consigné ici.
- Notifications Google : Cloud Pub/Sub API activée, RevenueCat affiche « Connected to Google ». Topic `projects/copiq-revenuecat/topics/Play-Store-Notifications`, abonnement `RevenueCat-Subscriber-appae3f1d1de1`. Topic enregistré dans Google Play, notifications activées. Test d’envoi en échec : droit de publication du compte officiel Google Play absent. Formulaire préparé avec le seul rôle Diffuseur Pub/Sub sur ce topic ; accord spécifique demandé, non enregistré à ce stade. Aucun événement reçu confirmé.
- Google Play : produits encore absents ; import d’un build compatible facturation demandé. Accès production non demandé ; les trois prérequis du test fermé sont affichés satisfaits (version fermée, 12 testeurs, 14 jours). Questionnaire à remplir avec des réponses factuelles.
- Signature : recherche dans le profil Windows et D: sans clé COP’IQ. Seulement clés debug/exemples et fichiers OneDrive sans rapport ; ne pas les utiliser.
- GitHub retrouvé : https://github.com/Rabbit0458/copiqpolice ; navigateur non connecté. Connexion demandée pour vérifier les secrets de compilation sans afficher leur contenu. Dernier CI visible du 25 septembre en échec. Aucun push.
- Copie de travail toujours sans `.git`. L’ancienne copie Desktop possède des travaux distincts ; ne pas les écraser ni les pousser par confusion.
- Web/admin : erreurs TypeScript corrigées (API Stripe alignée sur le SDK installé, imports TypeScript des tests autorisés). TypeScript et **build Next.js réussis, 102 pages**. Export statique : API routes et middleware non servis par cet export. Aucun déploiement web réalisé.
- Huit tests de normalisation RevenueCat réussis le 2 octobre. Les validations par achats réels/sandbox et les quatre parcours restent à réaliser.
- Deux anciens points d’entrée Stripe (`StripePaymentService.startCheckout`, `CpPayments.startCheckout`) bloqués avant authentification/réseau sur Android et iOS. Le portail des anciennes factures reste disponible. Deux tests de rejet natif réussis et analyse des quatre fichiers sans erreur. Les six tests plans/file des opérations passent également.
- CI Flutter aligné sur 3.47.5. Compilation iOS : transmission de `MATCH_GIT_URL` et `APPLE_TEAM_ID`, validation des paramètres manquants et préparation du trousseau temporaire CI ajoutées. Certificats existants uniquement (`readonly`), aucune génération ni révocation. Validation YAML réalisée ; exécution Mac/Fastlane encore indisponible.
- Webhook distant v17 sauvegardé hors dépôt dans le répertoire privé de sauvegarde Codex. Nouveau webhook toujours non déployé. Accord spécifique demandé pour le secret partagé RevenueCat/Supabase et son déploiement ; lecture serveur prévue via la clé SDK publique existante, sans clé RevenueCat V1 aux droits étendus.
- Publication publique explicitement demandée et autorisée par l’utilisateur. Aucun envoi en revue ni publication effectué tant que builds signés et paiements complets ne sont pas validés.

## Journal historique des 25 et 26 septembre

Source de travail : `C:\Users\kaiso\Desktop\COPIQPOLICEAPP\copiqpolice`.
Cette copie est distincte de `C:\Users\kaiso\Desktop\copiqpolice`. Aucun dépôt Git détecté dans la copie de travail.

## Réalisé dans les consoles

- RevenueCat projet `e6854375` : application iOS `appd097721373`, bundle `fr.copiq.app`, clé d’achats Apple raccordée et statut « Valid credentials ». Ancienne clé conservée. Aucun secret recopié ici.
- Produits iOS créés dans RevenueCat et association `premium` vérifiée : mensuel `fr.copiq.premium.monthly` (`prod0bcfd1470a`), annuel `fr.copiq.premium.yearly` (`prode35ba86e4f`). Inclusion enregistrée et vérifiée dans l’offering par défaut `ofrngc59a1fc3c4` : `$rc_monthly` et `$rc_annual`. Produits Test Store conservés ; aucun produit Google rattaché pour le moment.
- App Store Connect : les abonnements mensuel, annuel et historique hebdomadaire existent déjà. Mensuel France 8,99 €, sans offre introductive. Le 26 septembre, tarif annuel France corrigé de 86,99 € à 79,99 € pour correspondre au paywall Flutter ; enregistrement vérifié en rouvrant le prix initial. Autres territoires conservés (seule la France est disponible à la vente). Niveaux du groupe à vérifier. Aucune soumission effectuée.
- Notes de vérification de l’annuel corrigées à 79,99 €/an en France le 26 septembre. Retrait temporaire du brouillon pour modification, sauvegarde, puis réintégration au même brouillon confirmée par « ajouté pour vérification » et statut « Prêt pour la vérification ». Aucune soumission lancée. Capture de vérification encore à contrôler. Notifications Apple pas encore configurées.
- Groupe Apple contrôlé : mensuel niveau 1, historique hebdomadaire niveau 2, annuel niveau 3. Le mensuel et l’annuel offrent le même service et doivent être regroupés au même niveau. Les cases de modification sont désactivées tant que ces éléments sont ajoutés au brouillon : retirer temporairement les éléments concernés du brouillon avant de changer le niveau, puis les réintégrer. Aucun niveau changé à ce stade ; mode édition fermé.
- Supabase : migration `20260925095908_store_entitlements_isolated.sql` appliquée. Droits natifs séparés de Stripe, environnements test/réel séparés, accès serveur atomique avec déduplication. Tests SQL transactionnels annulés après vérification ; aucun droit de test persistant.
- Stripe : compte professionnel contact@copiq.fr identifié. Le tableau de bord en mode réel ne prouve pas que les secrets du backend sont en mode réel.

## Préparé localement, pas encore livré

- Flutter : achats/restauration et identité Supabase renforcés, messages d’erreur corrigés, protection avant et après achat contre un changement de compte. File d’exécution commune aux transactions natives et changements d’identité : pas de logIn/logOut pendant l’achat/restauration ; rejet d’une deuxième opération boutique simultanée. Contrôle d’identité répété après attente dans la file. Validation réelle sur appareil encore nécessaire.
- Signature Android : suppression du repli silencieux sur la clé debug pour les builds release.
- Chaînes de build : clés publiques RevenueCat spécifiques iOS/Android requises. Flutter mis à niveau 3.47.5 / Dart 3.13.4 ; intl 0.20.3.
- Clés SDK publiques officielles récupérées dans RevenueCat et enregistrées dans `config/revenuecat.public.json`. Pour les builds locaux, ajouter `--dart-define-from-file=config/revenuecat.public.json` aux autres paramètres existants. Ce fichier ne contient aucune clé secrète serveur. Les builds Android CI (AAB/APK/symboles) chargent ce fichier ; Fastlane iOS/Android le lit par défaut, avec possibilité de surcharge par variable d’environnement.
- Correctif du déploiement Google Play : Fastlane reçoit désormais le chemin du JSON écrit par le workflow, au lieu de recevoir son contenu dans une variable interprétée comme chemin.
- Nouveau webhook : vérification auprès de RevenueCat, liste d’applications autorisées, synchronisation native isolée. **Non déployé** tant que les secrets serveur et le webhook RevenueCat ne sont pas configurés. L’ancienne fonction distante reste en place.
- Administration : vue agrégée Apple/Google, test/réel. **Non déployée**.

## Contrôles

- Analyse Flutter des trois fichiers paiement/droits/paywall : aucun problème.
- Tests Flutter : 6 réussis (4 plans et 2 file d’exécution : changement de compte attend l’achat, puis une erreur d’achat ne bloque pas l’opération suivante).
- Tests de normalisation RevenueCat : 8 réussis.
- `deno check` du nouveau webhook : réussi.
- Analyse syntaxique YAML du workflow et format des clés SDK publiques : réussis. Ruby indisponible localement, Fastlane non exécuté ; aucune compilation signée validée.
- SQL : sandbox sans droit de production, achat production, révocation, déduplication et rollback vérifiés ; permissions d’écriture clientes refusées.
- Compilation TypeScript web encore bloquée par version Stripe incompatible et imports de tests préexistants. Pas de build de publication validé.
- Aucun achat Apple/Google réel ou sandbox testé de bout en bout.

## Dépendances restantes

1. Compléter l’offering avec Google quand ses produits seront disponibles, intégrer les clés SDK publiques aux builds signés/CI et configurer les notifications Apple.
2. Confirmation spécifique encore attendue pour créer une clé JSON du compte service Google existant puis la transférer uniquement à RevenueCat COP’IQ. Ne pas interpréter les relances automatiques comme une approbation.
3. Retrouver la clé de signature Android existante (.jks/.keystore) ou le service de build qui la conserve. Ne pas créer de remplacement silencieux. `android/key.properties` absent.
4. Google Play exige un APK/AAB compatible facturation avant création des abonnements ; aucun produit Play créé à ce stade.
5. Configurer secrets serveur et webhook, déployer puis tester achats, restauration, annulation, expiration, remboursement et changement de compte.
   Une confirmation spécifique a été demandée pour la clé RevenueCat V1 « COPIQ Supabase Subscription Sync », son stockage exclusivement dans les secrets Supabase COP’IQ et le secret de webhook partagé. Formulaire préparé, clé non générée. V1 ne propose pas de restriction de permissions dans le formulaire observé ; la clé possède donc une portée sensible, explicitée dans la question. Évaluer aussi l’alternative API publique pour la seule lecture ou API V2 restreinte avant décision technique définitive.
6. Produire les builds signés Android et iOS (Mac/CI requis pour iOS), terminer les fiches et valider les tests avant soumission.
7. Reconnexion App Store Connect confirmée le 26 septembre. Prix annuel corrigé et vérifié ; poursuivre notes/capture de vérification, niveaux et notifications Apple.

## Périmètre

Logique commune des droits et paiements pour Scolarité GPX, Scolarité PA, Exam GPX et Exam PA, ainsi que le panel administrateur. Cartographie et inventaire consultés. Les quatre parcours n’ont pas encore été testés individuellement avec des reçus stores : ne pas considérer la publication prête.

## Mise à jour du classement Apple — 26 septembre

Mensuel et annuel sont désormais tous deux au niveau 1 : modification enregistrée et vérifiée dans le tableau Apple. Ancien hebdomadaire conservé au niveau 2. Apple exigeait le retrait temporaire des trois produits du brouillon pour déverrouiller le classement ; ils ont ensuite été réajoutés, avec statut Prêt pour la vérification. Le brouillon vide précédent a été remplacé automatiquement par un nouveau brouillon contenant les trois abonnements. Aucune soumission envoyée. Apple signale encore deux prérequis : ajouter le groupe d’abonnements associé et une version iOS au brouillon. Fenêtre de soumission et mode modification fermés.

Groupe COP’IQ Premium ajouté au brouillon Apple le 26 septembre, statut Prêt pour la vérification. Le brouillon contient maintenant quatre éléments (trois abonnements et le groupe). Le seul blocage affiché dans ce brouillon est l’absence de version iOS associée. Vérification de la fiche Distribution : version 1.0, aucun build chargé, identifiants de vérification à fournir. Aucun envoi effectué.
