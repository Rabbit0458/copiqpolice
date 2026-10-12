# Confidentialite - finalisation du 12 octobre 2026

Ce bilan remplace les anciens constats « six categories SDK a configurer » et
« politique publique obsolete ». Il ne vaut pas validation du binaire iOS.

## Decision du proprietaire

Lancement avec annonces non personnalisees, sans suivi publicitaire entre
applications. Aucun changement du prix, des droits Premium ou du panel admin.

## Flutter et Android

- Deux formats recenses : interstitiel et recompense. Tous les parcours GPX/PA,
  examens et scolarite utilisent le service commun ; aucune autre demande
  d'annonce trouvee dans lib. Les deux formats utilisent maintenant
  AdPrivacyPolicy.request, avec nonPersonalizedAds=true.
- UMP conserve avant chargement ; acces « Mes choix publicitaires » conserve
  dans le centre juridique lorsque Google l'exige. Non personnalise ne signifie
  ni absence de donnees ni dispense de consentement.
- iOS : cle publicitaire proprietaire Google desactivee avant initialisation ;
  annonces desactivees avant iOS 14.5 pour eviter l'IDFA disponible sans ATT.
  Aucun ajout de demande ATT. En cas d'echec de configuration, pas d'annonce.
- Android : retrait AD_ID et des permissions Ad Services AD_ID, ATTRIBUTION et
  TOPICS, y compris des manifestes transitifs. Absence des quatre permissions
  verifiee dans le manifeste debug effectivement fusionne par Gradle. Ce constat
  ne signifie pas qu'aucun identifiant technique ne puisse etre traite par le SDK.
- Premium sans annonces et verification signee des recompenses conserves.

## Documents en ligne et copie d'hebergement

- Deux documents CMS publies mis a jour : privacy
  08018ca8-eab5-4204-8969-e4c6209f2f8d et cookies
  96852353-b60f-474b-ad93-4f57eb6b654e, version 1.1.0.
- Politique verifiee dans le navigateur a https://copiq.fr/privacy/ : mise a jour
  du 12 octobre, RevenueCat, achats natifs, journaux lies au compte, date de
  naissance, messages/photos, IP approximative, annonces non personnalisees,
  UMP et limites de la verification d'age.
- Les dispositions mobiles nouvelles designent explicitement la version 1.1.0
  preparee pour publication : le nouveau code n'est pas encore distribue.
- Supabase reste le CMS utilise par l'application ; aucun droit CMS/admin modifie.
- Sauvegarde des deux textes et metadonnees anterieurs dans
  confidentialite_2026_10_12/AVANT_documents.json et AVANT_*.md.
- Copie Desktop/fae16dc1 : sources privacy/cookies, copies content/legal et pages
  HTML privacy/cookies/preferences regenerees. Option --privacy-only ajoutee au
  generateur pour ne pas reecrire le reste du site. Pas de transfert FTP realise.
- Les clauses anterieures hors de ce perimetre (par exemple moderation des
  messages, conservation detaillee et prestataires Photolangage) ont ete
  conservees ; leur conformite technique exhaustive n'est pas certifiee ici.

## Declaration Apple

- 18 types renseignes, plus aucune categorie « Configurer » restante.
- Coordonnees : fonctionnalite seulement, liees au compte, pas de suivi.
- Messages/photos/assistance/autres contenus et date de naissance :
  fonctionnalite, lies a l'identite, pas de suivi.
- Identifiant utilisateur et achats : fonctionnalite et analyses, lies,
  pas de suivi publicitaire (RevenueCat et compte COP'IQ).
- Identifiant appareil : publicites tierces et analyses, lie, sans suivi.
- Emplacement approximatif : fonctionnalite (ville), publicites tierces et
  analyses (IP AdMob), lie, sans suivi.
- Interactions, donnees publicitaires, pannes et performance : fonctionnalite,
  publicites tierces et analyses, liees, sans suivi.
- Autres diagnostics COP'IQ : fonctionnalite et analyses, lies, sans suivi.
- Bouton final Publier ouvert : Apple demande une garantie d'exactitude et de
  conformite. Confirmation du titulaire demandee avant ce dernier clic.
  Etat a ce point : declaration sauvegardee en brouillon, pas encore publiee.
- Capture : confidentialite_2026_10_12/APPLE_CONFIRMATION_PUBLICATION.jpg.

## Verification

- Suite Flutter complete : 225 tests reussis. Analyse complete : aucun diagnostic.
- Apres le retrait supplementaire des permissions Ad Services : 4 tests de
  confidentialite repasses avec succes et fusion Gradle reussie ; quatre
  permissions publicitaires absentes du manifeste fusionne.
- Controle du centre juridique : 9 pages valides.
- Avertissements Gradle preexistants sur versions Kotlin/Gradle/AGP et attributs
  package de plugins ; aucun contournement ou mise a jour massive applique.

## Avant soumission

1. Confirmation finale de la declaration Apple par le titulaire.
2. Reprendre les sources recentes sur Mac, generer l'archive et controler le
   rapport de confidentialite des SDK reellement embarques.
3. Tester sur iPhone les choix UMP, annonces non personnalisees et recompense,
   changement de consentement et absence de pubs Premium. Verifier aussi que
   les textes du formulaire AdMob ne promettent pas une personnalisation active.
4. Generer egalement un nouvel AAB Android avant sa prochaine distribution ;
   verifier le manifeste release et les declarations Google Play du nouveau build.

Pas de nouvelle IPA/AAB produite, pas de capture de trafic natif ni de soumission
de l'application pendant cette finalisation.

## Sources techniques

- https://developers.google.com/admob/ios/privacy/data-disclosure
- https://developers.google.com/admob/ios/privacy/strategies
- https://developers.google.com/admob/android/privacy/sandbox
- https://support.google.com/admob/answer/7676680
- https://developer.apple.com/app-store/app-privacy-details/
- https://www.revenuecat.com/docs/platform-resources/apple-platform-resources/apple-app-privacy
