# COP’IQ — Publicités : fréquence, calendrier et état de livraison

Mis à jour le 2 octobre 2026. Copie de travail : `C:\Users\kaiso\Desktop\COPIQPOLICEAPP\copiqpolice`.

## Où modifier les publicités

Après déploiement du nouveau panneau : **Administration → Centre d’information → Publicités** (`/admin/informations`).

1. Se connecter avec le compte propriétaire et une session avec double authentification.
2. Activer ou désactiver les publicités.
3. Choisir le délai minimum : raccourcis **15, 20 ou 30 minutes**, ou saisir un entier de 5 à 1 440 minutes.
4. Facultativement choisir une date/heure de début et de fin.
5. Cliquer sur **Enregistrer les publicités** et attendre la confirmation.

Les heures saisies sont celles du navigateur, dont le fuseau est affiché. Elles sont enregistrées en UTC. Début inclus, fin exclue. Champ vide = aucune limite correspondante. Une fin passée coupe les annonces. Pour relancer une campagne, effacer cette fin ou la déplacer dans le futur.

**Valeurs enregistrées en base : activé, 20 minutes, aucune date de début ou de fin.** Aucun changement de fréquence n’a été livré aux anciennes versions mobiles qui gardent leurs paramètres intégrés.

Ce document est un guide : modifier son texte ne change pas la configuration de l’application.

## Ce que règle l’intervalle

C’est le minimum entre deux annonces automatiques sur un même appareil. Ce n’est pas un minuteur imposant une annonce toutes les 20 minutes. Il faut aussi une transition compatible, une annonce disponible et l’autorisation de demander des annonces via le consentement Google.

Le premier affichage éligible n’attend pas nécessairement 20 minutes. Après un affichage, son heure est conservée sur l’appareil, même après redémarrage. La durée d’une vidéo ou le délai avant son bouton de fermeture est déterminé par AdMob, pas par ce réglage.

Les annonces volontaires avec récompense respectent l’interrupteur et les dates, mais pas l’intervalle des annonces automatiques. Leur quota dépend du mécanisme serveur existant ; ce réglage ne change pas ce quota.

## Gratuit et Premium

- Le service exclut les comptes reconnus Premium, y compris les droits remontés par RevenueCat dans le service d’abonnement commun.
- Un état d’abonnement non initialisé ou en erreur bloque l’affichage.
- Une lecture de configuration impossible ou invalide bloque les annonces pour la tentative concernée.
- Deux annonces ne peuvent pas être lancées simultanément par ce service.
- Un changement de compte pendant une annonce récompensée empêche de créditer la récompense au nouveau compte.
- Le délai automatique est mémorisé après le début effectif d’affichage, et non après un échec de chargement.

## Périmètre contrôlé

Cartographie `CARTOGRAPHIE_COMPLETE_SCOLARITE_GPX_PA.md` et inventaire `migration_data/sources.jsonl` consultés. Recherche globale dans les sources Flutter : le routeur principal observe la fermeture des dialogues dont `barrierLabel` vaut `Résultat` et appelle le service commun.

| Parcours | Fichiers avec ce dialogue |
|---|---:|
| Scolarité GPX | 107 |
| Scolarité PA | 69 |
| Exam GPX | 17 |
| Exam PA | 18 |

Liste précise : `ADS_RESULT_ROUTES_AUDIT.txt`. L’écran partagé `SavingScreen` appelle également le même service. Les écrans de résultat autonomes sans ce dialogue ne déclenchent pas automatiquement une publicité par cet observateur. Aucun affichage arbitraire pendant un cours, une question ou une navigation n’a été ajouté. Les chiffres décrivent la couverture statique, pas 211 tests sur appareil.

## Réalisé et vérifié

- Colonnes de calendrier/fréquence ajoutées à `app_runtime_config` sur Supabase Production.
- Fonction `admin_ads_config_set` : propriétaire actif, session AAL2, validation des dates et intervalle, journal d’audit. Lecture publique des paramètres non secrets ; aucun droit d’écriture client ajouté.
- Tests SQL transactionnels puis rollback : aller-retour propriétaire, refus sans MFA, refus non-propriétaire/anonyme, dates inversées et fréquence invalide rejetées ; écriture directe cliente sans effet.
- Six tests Flutter : 15/20/30 minutes, frontières de calendrier et fuseaux horaires, désactivation, valeurs invalides et horloge reculée.
- Analyse Flutter sans erreur ; TypeScript et build Next.js réussis, 102 pages.
- Conseiller de sécurité consulté : exposition en lecture de la configuration et fonction RPC authentifiée signalées. Elles sont intentionnelles ; l’écriture RPC impose propriétaire et MFA côté serveur. Référence : https://supabase.com/docs/guides/database/database-linter

## Pas encore livré ni certifié pour publication

Le nouveau panneau est maintenant généré dans `fae16dc1/admin/informations/`, avec ses scripts dans `fae16dc1/_next/`. Ancien export sauvegardé dans `fae16dc1-backup-2026-10-02T20-08-35-920Z`. Les 17 routes critiques et les 18 ressources référencées par cette page sont présentes. Le JavaScript livré contient l’appel réel `admin_ads_config_set`. La lecture HTTP de production confirme activé, 20 minutes, sans dates ; URL Supabase identique dans le panneau et Flutter.

Cet export reste local : aucun transfert vers l’hébergeur, aucun nouveau build signé soumis. Il faut envoyer le contenu complet de `fae16dc1`, notamment `_next/`, et livrer le build mobile. Les anciens builds ne prennent pas en compte ces nouveaux réglages. L’aller-retour dans un navigateur connecté au panneau et l’affichage sur appareils restent à valider ; les contrôles réalisés portent sur le code compilé, l’API et les permissions SQL.

Les identifiants AdMob de production figurent déjà dans le code release ; les builds debug utilisent les identifiants de test. Cela ne prouve pas que le compte AdMob, les consentements, les déclarations stores, la validation serveur des récompenses ou la diffusion réelle sont prêts. Ces points nécessitent une vérification dédiée et des essais iOS/Android avec appareils de test configurés. Ne pas cliquer sur des annonces réelles pour tester.

Les paiements ne sont pas encore validés de bout en bout. Voir `SUIVI_PAIEMENTS_STORES_2026_09_25.md` : notifications Google et relais RevenueCat/Supabase désormais configurés avec tests de transport réussis (voir mise à jour prioritaire du suivi), signatures/builds à retrouver ou préparer, produits Google et offering à compléter, achats/restaurations/remboursements à valider, dossier de production Google à renseigner. **Ne pas considérer cette application comme prête à publier sur la seule base de ces réglages publicitaires.**

## Mise à jour AdMob du 3 octobre 2026

Le message « COPIQ — Consentement européen iOS et Android » est maintenant **Publié** dans AdMob (état contrôlé après publication), pour les deux applications du compte contact@copiq.fr, éditeur pub-5486022144325892.

- Français par défaut, anglais supplémentaire ; ciblage EEE, Royaume-Uni et Suisse.
- Boutons Autoriser, Refuser et Gérer les options ; refus activé pour toutes les régions proposées dans le paramétrage du bouton.
- URL de confidentialité des deux applications : https://copiq.fr/privacy/.
- Liste de partenaires existante conservée : 198 dans les paramètres du compte ; aperçu du formulaire affichant 210 partenaires. Aucun partenaire ajouté et aucune synchronisation de consentement entre applications activée.
- AdMob indique un délai de propagation possible d'une heure. L'affichage réel dans le build 7 reste à tester sur appareil.
- Preuve : `preuves-stores/admob-consentement-publie-2026-10-03.png`.

### Concordance des quatre blocs publicitaires

Les blocs existants ont été lus dans AdMob et comparés au service Flutter ; tous correspondent, sans modification des identifiants.

| Plateforme | Interstitiel | Récompensé | ID application |
|---|---|---|---|
| Android | 9625359483 | 3779020910 | 4218004611 |
| iOS | 8648204215 | 5012211534 | 6461024573 |

Préfixe commun : ca-app-pub-5486022144325892. Aucun groupe de médiation actif et aucune campagne active sur ces quatre blocs. AdMob n'impose pas de limite de fréquence : le délai de 20 minutes reste celui du service commun de l'application, configurable depuis le panneau après son déploiement.

Périmètre : configuration commune aux quatre parcours Scolarité GPX, Scolarité PA, Exam GPX et Exam PA via le service partagé. Les exceptions de déclenchement des écrans de résultats décrites plus haut restent inchangées ; aucune validation sur appareil n'est déduite de cette vérification des identifiants.

### Reste à valider avant diffusion publique

Associer les fiches publiques des stores dans AdMob et terminer leur examen ; vérifier app-ads.txt ; mettre à jour la politique de confidentialité publique (mentions anciennes de Stripe/Firebase et consentement annoncé comme à venir) ; terminer les déclarations de données des stores ; tester consentement, refus, révocation, absence de publicité Premium et récompenses avec appareils de test. La publication du formulaire de consentement n'est ni la publication de l'application ni une certification de conformité de tout le projet.
