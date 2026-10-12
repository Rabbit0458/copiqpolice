# Dossier de preparation Apple - 12 octobre 2026

## Actualisation confidentialite

Le [bilan de finalisation](./CONFIDENTIALITE_PUBLICATION_2026_10_12.md) remplace
les constats historiques des deux sections Confidentialite et Politique publique
ci-dessous : 18 categories renseignees, textes CMS actualises, publicite non
personnalisee dans les sources, 225 tests reussis. Le titulaire doit encore
confirmer la garantie demandee par Apple avant la publication de la declaration.
Le rapport de confidentialite de l'archive Mac et les essais natifs restent requis.

## Verifie dans App Store Connect

- Version 1.1.0, statut A finaliser avant soumission. Aucun nouveau build associe.
- Description, mots-cles, URL assistance et copyright enregistres.
- Nom du compte de demonstration kaiswinston2@gmail.com renseigne et sauvegarde. Mot de passe encore absent : saisie directement chez Apple par le proprietaire.
- Six captures iPhone heritees visibles dans le gestionnaire et six captures iPad 13 pouces presentes. Comparaison visuelle au nouveau build encore necessaire ; aucun visuel invente ou remplace.
- Publication automatique apres approbation conservee, sans soumission effectuee.
- Mensuel fr.copiq.premium.monthly et annuel fr.copiq.premium.yearly : Prets pour la verification, deja dans le brouillon. Localisation francaise, image promotionnelle et capture de verification presentes. Disponibilite mensuelle : France uniquement. L'annuel filtre par pays disponibles montre France, 79,99 EUR.
- Le proprietaire confirme mensuel et annuel uniquement. Hebdomadaire fr.copiq.premium.weekly retire du brouillon de soumission, sans suppression du produit, modification tarifaire ou retrait de la vente. Le bouton Ajouter pour verification est reapparu. Le code et le serveur ne prennent pas cet identifiant en charge : ne pas le reintroduire dans l'offre RevenueCat.
- Delai de grace de facturation non configure dans Apple ; aucune modification arbitraire de cette option commerciale.

## Confidentialite : brouillon, pas publication

Le profil collecte birthday (lib/features/home/profil_page.dart). La categorie Autres donnees est maintenant configuree : fonctionnalite, liee au compte, sans suivi publicitaire pour ces donnees.

Messages, photos, assistance et autres contenus sont deja configures avec les memes finalites. Six categories SDK restent a finaliser : identifiant appareil, interaction avec le produit, publicites, pannes, performance et autres diagnostics.

| Type | Source constatee | Finalites a rapprocher du binaire final |
| --- | --- | --- |
| Identifiant utilisateur / achats | Supabase, RevenueCat, UID personnalise | Fonctionnalite et analyses ; lies au compte ; pas de suivi publicitaire constate pour les achats |
| Emplacement approximatif | Ville facultative du profil et IP AdMob | Fonctionnalite pour le profil ; publicites/analyses pour le SDK ; ancienne declaration a revoir |
| Identifiant appareil | AdMob ; pas de collecte IDFA RevenueCat explicitement activee constatee | Publicites tierces et analyses selon Google ; verification du suivi requise |
| Interactions | Navigation/journaux Supabase, AdMob | Fonctionnalite, analyses, publicites tierces pour le SDK |
| Donnees publicitaires | AdMob, et statut de recompense Supabase | Publicites tierces, analyses et prevention de fraude pour la recompense |
| Pannes / performance | AdMob, journaux techniques Supabase | Fonctionnalite, analyses ; Google mentionne aussi des usages publicitaires |
| Autres diagnostics | app_logs, stacktrace et contexte technique lies a user_id | Fonctionnalite et analyses ; distinguer des diagnostics SDK |

Ne pas confondre consentement UMP, identifiant technique et suivi inter-apps ATT. La copie iOS n'a pas de NSUserTrackingUsageDescription ; AdRequest est par defaut. Il faut examiner les manifestes des SDK du nouvel archive Xcode et tester le comportement de consentement avant de publier les reponses. Les Pods locaux n'ont pas encore ete regeneres pour toutes les nouvelles dependances iOS.

Sources :
- https://developers.google.com/admob/ios/privacy/data-disclosure
- https://www.revenuecat.com/docs/platform-resources/apple-platform-resources/apple-app-privacy

## Politique de confidentialite publique : ecarts identifies

La page https://copiq.fr/privacy/ charge bien son contenu apres JavaScript (version affichee du 19 aout 2026). Ce n'est pas une page vide. Le contenu charge differe de la source locale statique Desktop/fae16dc1 : ne pas remplacer tout le site sans reconciler les sources.

Corrections a preparer pour le build public :
- Remplacer l'ancienne indication d'achat mobile par navigateur Stripe par les achats natifs Apple/Google via RevenueCat ; Stripe demeure le prestataire des achats Web.
- Ajouter RevenueCat a la liste des prestataires pour UID de compte, droits et historique d'achats.
- Actualiser la mention UMP en cours d'integration : le recueil UMP est implemente ; validation native et suivi ATT restent a confirmer.
- Ne pas declarer Firebase Analytics/Crashlytics, Sentry ou PostHog actifs dans ce build sans integration effective : ils ne figurent pas dans pubspec.yaml. Distinguer d'eventuels services actifs sur le Web ou dans une autre version.
- Ajouter explicitement date de naissance facultative, photos/pieces jointes, journaux app_logs et collecte approximative par IP AdMob.
- Revoir la coherence du public vise 16+, de l'avertissement et de la classification Apple 18+. Ne pas promettre un blocage technique de l'age absent du code.

Aucun texte juridique distant modifie ou publie pendant cette preparation. Les autres engagements de conservation, transferts et moderation n'ont pas ete revalides integralement.

## Passage sur MacBook

1. Transferer la copie mobile recente complete avec ses modifications, pas seulement la branche distante : plusieurs fichiers sont non commites. Ne jamais incorporer les secrets serveur dans l'app ni dans le paquet transmis.
2. Dans le dossier du projet sur Mac, executer `bash scripts/build-ios-public.sh`. Version source : 1.1.0+9. Le script analyse, teste et genere l'IPA sans l'envoyer. Xcode, Flutter et CocoaPods requis.
3. Dans Xcode, verifier equipe/signature et rapport de confidentialite de l'archive. Examiner les SDK reellement embarques, les API a motifs requis et les declarations de suivi.
4. Envoyer l'archive signee via Xcode Organizer ou l'IPA via Transporter. Attendre le traitement Apple et repondre au questionnaire de chiffrement d'apres le binaire reel, sans reponse arbitraire.
5. Installer ce build depuis TestFlight pour les essais ci-dessous. Cela ne transforme pas la cible de publication en beta : les essais precedent la soumission publique.
6. Associer le nouveau build a la version 1.1.0, verifier les deux abonnements dans le brouillon et saisir directement le mot de passe du compte de demonstration.

## Essais natifs avant soumission

| Scenario | Resultat attendu | Etat |
| --- | --- | --- |
| Compte gratuit | Menus sans debit ; un seul debit par exercice nomme ; refus avant chargement au quota epuise | A tester sur appareil |
| GPX/PA scolarite | Aucun acces distant gratuit, acces Premium et panel conserves | SQL verifie, parcours natifs a tester |
| Recompense | Une publicite terminee, un credit signe, aucun double credit ; refus/fermeture sans gain | Signature/SQL testes, visionnage natif a tester |
| Mensuel / annuel | Prix StoreKit, achat Sandbox, acces Premium, aucune pub | A tester avec compte autorise Sandbox |
| Restauration | Droits retablis pour le bon compte ; pas de fuite vers un autre compte | A tester |
| Annulation / expiration | Annulation conserve acces jusqu'a echeance ; expiration/revocation retire acces | Normalisation testee, cycle natif a tester |
| Connexion demonstration | Acces aux contenus sans privilege administrateur | A tester avec mot de passe reel |
| Communaute | Publication/photo, signalement/blocage et suppression de compte | A tester sans donnees personnelles |
| iPhone / iPad | Pas de debordement, captures fideles au build | A tester |

## Interventions du proprietaire

- DSA : autorisation de publier les coordonnees recue le 12 octobre. Adresse saisie chez Apple ; verification telephonique du 09 en attente du combine. Ne pas stocker de code de verification dans ce dossier.
- Entite juridique : confirmation des informations dans Business, puis accord explicite au moment d'accepter le contrat payant. Aucun contrat accepte.
- Completer dans Apple les demandes fiscales/bancaires effectivement affichees, sans communiquer les secrets dans le chat.
- Saisir le mot de passe du compte de verification directement dans App Store Connect.

Ce dossier prepare la soumission ; il ne certifie ni les paiements natifs, ni la conformite exhaustive, ni une publication obtenue.
