# COP’IQ — Journal évolutif des mises à jour bêta

Ce document centralise les corrections réalisées pendant les tests Android et
iOS. Il doit être complété à chaque nouvelle amélioration avant publication
d’une version bêta.

## Corrections terminées

### Mise à jour mobile obligatoire

- Ajout du contrôle de version bloquant au démarrage sur iOS et Android.
- Pilotage séparé du numéro de version et du numéro de build depuis Supabase.
- Écran inaccessible au retour tant que la version minimale imposée n'est pas
  installée, avec ouverture directe de la fiche du store.
- Le build 3 installe ce mécanisme ; il permettra d'imposer les builds suivants.

### Accueil personnalisé

- Le sélecteur de mode affiche désormais « Bienvenue Prénom 👋 » en utilisant
  d'abord le prénom, puis le nom d'utilisateur du profil Supabase.
- Si le profil est incomplet, le message reste simplement « Bienvenue 👋 ».

### Abonnement annuel Stripe

- La fonction de paiement contrôle maintenant que chaque tarif configuré est
  actif et correspond bien à la bonne périodicité.
- Si l'identifiant du tarif annuel de test a changé, elle retrouve
  automatiquement le tarif actif à 86,99 € par an dans le même environnement
  Stripe, au lieu d'afficher une erreur générique.
- La nouvelle version de la fonction Checkout est déployée sur Supabase.

### Suivi — historique et compréhension des erreurs

- Harmonisation de la récupération des tentatives sur Scolarité GPX,
  Scolarité PA, Exam GPX et Exam PA.
- L'activité récente utilise maintenant la meilleure date disponible
  (fin, complétion ou démarrage), ce qui rétablit les tentatives récentes.
- Les réponses enregistrées sont rattachées à chaque tentative : question,
  réponse donnée et bonne réponse sont consultables depuis la carte d'activité.
- Une tentative ouverte puis quittée sans réponse reste visible avec la mention
  « Aucune question répondue », mais ne modifie plus la moyenne, la régularité,
  la série de jours ni les objectifs.
- Les anciens résultats dépourvus d'un historique question par question restent
  lisibles sans inventer de détail qui n'avait pas été enregistré.

### Accueils et sélection des programmes — titres entièrement visibles

- Suppression des points de suspension sur les titres de cartes de contenu.
- Les intitulés peuvent désormais occuper plusieurs lignes sur les petits
  écrans sans changer de police ni masquer la fin du titre.
- Les programmes « Policier en intervention — Socle initial » et « Policier en
  intervention — Socle avancé » sont maintenant clairement distinguables.
- Harmonisation contrôlée sur les accueils et sélecteurs Scolarité GPX,
  Scolarité PA, Exam GPX et Exam PA, sans modification de la navigation ni des
  données pédagogiques.

### Forum — affichage des réponses avec mention

- Correction du texte anormalement agrandi, coloré et souligné lorsqu’une
  réponse contenait une mention `@utilisateur`.
- Les réponses utilisent désormais la même typographie que les commentaires
  ordinaires.
- La mention reste mise en évidence en bleu, sans modifier le reste du texte.
- La logique des réponses, mentions et notifications n’a pas été modifiée.

### Tests psychotechniques — confirmation de fin de quiz

- Remplacement du libellé trop long « Mettre fin et voir mes résultats » par
  « Terminer le quiz ».
- Taille du texte stabilisée pour éviter tout débordement sur les petits écrans.
- La sauvegarde des réponses et l’ouverture des résultats restent inchangées.
- Les parcours psychotechniques GPX utilisant le composant partagé ont été
  couverts ; les confirmations PA homologues ont été contrôlées et utilisent
  déjà une disposition sans débordement.

### Panel administrateur — améliorations déjà intégrées au chantier bêta

- Modernisation visuelle uniforme des pages administrateur.
- Enrichissement du dossier utilisateur et de ses données Supabase.
- Amélioration du centre des signalements et de la modération du forum.
- Ajout de l’historique communautaire et des informations de plateforme lorsque
  celles-ci sont disponibles.

## Corrections de démarrage et conformité terminées

### Retour personnalisé des utilisateurs connectés

- Lorsqu'une session existante est restaurée au lancement, un accueil bref
  affiche « Nous sommes ravis de vous revoir » avec le prénom disponible.
- Le message reste lisible environ cinq secondes, apparaît puis disparaît avec
  un fondu fluide avant l'ouverture du sélecteur de mode.
- Le logo officiel chargé depuis le stockage Supabase est affiché avec un repli
  local si le réseau est indisponible.
- Le PNG du logo est affiché brut et transparent, sans bulle, bordure, fond ni
  halo ; le fond et le contraste du texte s'adaptent automatiquement au thème
  clair ou sombre de l'utilisateur.
- Une validation verte animée confirme que le profil a été récupéré, suivie
  d'un message remerciant l'utilisateur de faire partie de l'aventure COP'IQ.
- Si le profil ne contient pas de prénom exploitable, le message reste naturel
  et s'affiche sans donnée personnelle manquante.
- L'écran disparaît automatiquement vers le sélecteur de mode et respecte la
  préférence système de réduction des animations.
- Ce retour n'est jamais affiché pendant l'inscription, la première connexion
  ou lorsque l'utilisateur n'est pas authentifié.
- L'étape est intégrée au démarrage partagé et couvre donc Scolarité GPX,
  Scolarité PA, Exam GPX et Exam PA.

### Démarrage, avertissement légal et onboarding

- Suppression de la remise à zéro qui forçait l’avertissement et l’onboarding
  à chaque lancement en production.
- Ajout d’une décision de démarrage unique qui distingue la session Supabase,
  l’onboarding terminé, l’appareil déjà configuré et la révision légale acceptée.
- Une session encore valide ouvre directement le sélecteur de mode ; une
  session absente ou expirée conduit à la connexion sans rejouer l’onboarding.
- Ajout d’un repli hors connexion utilisant la dernière configuration légale
  connue, avec le texte intégré à l’application comme ultime secours.
- Ajout dans le Centre d’information du panel des commandes pour modifier ou
  désactiver l’avertissement et publier une nouvelle révision à réafficher une
  seule fois à tous les appareils.

### Conditions générales de vente

- L’acceptation est maintenant enregistrée par le serveur lors de la création
  du compte avec la date du clic, la date serveur, la version des CGV, la source
  et la plateforme.
- Ajout d’un historique de consentement durable dans Supabase.
- Les comptes historiques sont marqués « acceptation historique reconstituée » :
  le panel affiche la date de création disponible sans la présenter comme
  l’heure exacte du clic, qui n’avait jamais été collectée.
- Le dossier utilisateur affiche maintenant la date et l’heure, la version des
  CGV et l’avertissement explicite lorsque la date est reconstituée.

## Vérifications avant la prochaine publication

- Installation neuve avec avertissement activé et désactivé.
- Utilisateur existant connecté et déconnecté.
- Session Supabase expirée.
- Nouvelle révision de l’avertissement affichée une seule fois.
- Bouton « Passer » de l’onboarding.
- Création de compte avec acceptation et refus des CGV.
- Horodatage CGV visible dans le panel administrateur.
- Contrôle sur Android et iOS.
# Centre sécurisé des versions mobiles

- Liens officiels contrôlés le 27 août 2026 : TestFlight public du groupe BETA-TESTEURS et fiche Google Play du test fermé.
- Ajout d'un écran propriétaire « Versions mobiles » dans le panel administrateur.
- Préparation séparée d'une version iOS/Android avec numéro de build, message et liens des stores.
- Confirmation obligatoire de la disponibilité du même build sur les deux stores avant activation.
- Refus serveur d'une mise à jour obligatoire si une URL manque, si elle est invalide, ou si le build n'est pas confirmé comme disponible sur iOS et Android.
- Activation atomique : le minimum obligatoire ne change qu'une fois toutes les protections validées.
- Bouton d'arrêt d'urgence de l'obligation de mise à jour.
- Écritures directes interdites depuis le navigateur ; opérations réservées au propriétaire authentifié en double authentification.
- Journalisation des préparations, confirmations, activations et désactivations dans le journal d'audit administrateur.

## Refonte du centre « Mon suivi »

- Création d'un historique pédagogique unifié pour Scolarité GPX, Scolarité PA,
  Exam GPX et Exam PA.
- Chaque nouvelle réponse conserve désormais la question, la réponse donnée, la
  bonne réponse, les choix proposés, l'explication, la difficulté, la position
  dans le quiz et le temps de réponse lorsqu'ils sont disponibles.
- Ajout d'un carnet d'erreurs durable permettant de retrouver les erreurs
  anciennes, leur correction et leur explication, puis de relancer le module
  concerné.
- Les détails d'une tentative affichent maintenant les bonnes et les mauvaises
  réponses au lieu de présenter uniquement un score global.
- Les quiz ouverts puis quittés sans aucune réponse restent visibles comme
  tentatives incomplètes mais ne diminuent plus la progression générale.
- Synchronisation sécurisée avec Supabase : l'identité de l'utilisateur est
  déterminée par sa session, les écritures anonymes sont refusées et un compte
  ne peut ni lire ni écrire l'historique d'un autre compte.
- Ajout d'une protection contre les doublons lors des synchronisations réseau.
- Les 91 tables historiques de réponses encore utilisées par les anciens quiz
  alimentent automatiquement le nouvel historique pour les futures réponses.
- Les anciens scores agrégés restent consultables. Lorsqu'aucun détail par
  question n'avait été enregistré à l'époque, l'application l'indique clairement
  au lieu de fabriquer une correction impossible à prouver.
- Correction d'un blocage de sécurité qui empêchait certaines pages historiques
  d'enregistrer les réponses détaillées des utilisateurs authentifiés.
- Réparation du classement des tentatives : chaque activité est maintenant
  rattachée explicitement à Scolarité GPX, Scolarité PA, Exam GPX ou Exam PA.
- Le quiz « Infractions à la circulation routière » conserve désormais un
  instantané complet de chaque réponse : choix proposés, réponse donnée, bonne
  réponse, explication, difficulté et position dans la séance.
- Uniformisation complète des 212 écrans qui enregistrent réellement des
  réponses : 108 en Scolarité GPX, 69 en Scolarité PA, 17 en Exam GPX et 18 en
  Exam PA. Tous transmettent désormais le même instantané détaillé au centre de
  suivi, avec mise en attente locale si le réseau est indisponible.
- Les 184 créations de tentative sont désormais toutes identifiées par le
  parcours, le mode et le grade afin qu'aucune activité récente ne soit rangée
  dans la mauvaise section du suivi.

## Coach COP’IQ personnalisé

- Ajout d'une priorité du jour calculée à partir des matières les moins
  maîtrisées, des erreurs récurrentes et de la récence des réponses.
- Mise en place de la répétition espacée à 1, 3, 7 puis 30 jours selon la
  consolidation réelle de chaque question.
- Ajout du mode « Corriger mes erreurs » avec correction, explication et accès
  direct au module concerné.
- Ajout des niveaux « À découvrir », « Fragile », « En progression » et
  « Maîtrisé » dans le suivi des matières.
- Détection des notions échouées plusieurs fois et estimation d'une durée de
  séance personnalisée.
- Conservation des tendances sur 7 jours, 30 jours et l'ensemble de
  l'historique, avec objectifs quotidiens personnalisables.
- Création dans Supabase d'un profil de maîtrise privé par utilisateur,
  parcours, mode et question, avec prochaine date de révision.
- Ajout d'une file d'attente hors connexion : les réponses sont resynchronisées
  automatiquement et protégées contre les doublons au retour du réseau.
- Le moteur reste explicable : ses conseils proviennent uniquement des réponses
  et scores réellement enregistrés, sans fabriquer de diagnostic pédagogique.
# Coach pédagogique COP’IQ — suivi avancé

- Ajout d’un indice de préparation explicable : connaissances, régularité, durabilité, vitesse et couverture.
- Ajout de la date cible du concours avec compte à rebours et synchronisation Supabase.
- Ajout d’un bilan hebdomadaire durable, de badges pédagogiques et d’une recherche globale dans l’historique.
- Ajout du diagnostic des erreurs, du risque d’oubli, des pièges récurrents et de fiches générées depuis les corrections.
- Ajout d’une séance adaptative de dix questions, priorisée à partir des erreurs dues, récurrentes et notions anciennes.
- La révision espacée, « Corriger mes erreurs » et la priorité du jour restent disponibles depuis la page Mon suivi.
- Préparation de la mémorisation du niveau de confiance après une réponse : « Je savais », « J’hésitais » ou « Au hasard ».
- Les données du Coach sont privées, protégées par RLS et séparées pour chaque utilisateur.
- La même page et la même logique sont utilisées dans Scolarité GPX, Scolarité PA, Exam GPX et Exam PA.

## Coach COP’IQ — calendrier officiel et pilotage

- Synchronisation automatique quotidienne des calendriers prévisionnels GPX et
  Policier adjoint depuis les pages officielles de la Police nationale.
- 241 échéances officielles initiales récupérées : 32 GPX et 209 PA, avec
  session, zone, type d’épreuve, dates et lien vers la source officielle.
- Conservation automatique de la dernière copie valide si la source est
  indisponible ou si sa structure change, afin de ne jamais remplacer le
  calendrier de l’application par une liste vide.
- Sélection d’une date officielle directement dans le Coach, avec adaptation
  automatique du compte à rebours et du plan de préparation.
- Ajout d’un plan jusqu’au concours, du temps de travail cumulé, d’une
  projection pédagogique à 30 jours et d’un rappel local personnalisé.
- Ajout d’un Coach conversationnel explicable pour répondre aux questions sur
  la priorité du jour, la baisse de score, le niveau de préparation et la durée
  de travail recommandée.
- Ajout dans le panel administrateur d’un centre Coach en lecture seule :
  profils configurés, dates renseignées, auto-évaluations, bilans hebdomadaires
  et état de la synchronisation officielle.
- Accès au centre Coach réservé au propriétaire connecté en double
  authentification ; aucun secret ni droit d’écriture serveur n’est exposé au
  navigateur.
# Banque de quiz Organisation de la Police nationale — build suivant

- Questions Organisation désormais hébergées et versionnées dans Supabase pour GPX et PA.
- 4 choix systématiques, validation séparée de la sélection et corrections pédagogiques détaillées.
- Ajout de 25 planches visuelles de grades et galons avec solution, explication et image de secours.
- Couverture dédiée des cours : organigramme du ministère, organigrammes PN, hiérarchie, règles d’emploi PA, horaires de sécurité publique, DGSI et Préfecture de Police.
- Historique question par question synchronisé avec le suivi : réponse choisie, bonne réponse, version de la question et temps de réponse.
- Les quiz quittés sans aucune réponse ne dégradent plus la progression.
- Signalement d’une question enrichi d’un instantané complet et mis en attente hors connexion si nécessaire.
- Cache local de secours pour continuer un quiz après une perte de réseau.

## Module professionnel « Je suis actif »

- Ajout d'un nouveau mode professionnel accessible depuis le sélecteur de parcours.
- Mise en place d'une vérification sécurisée en quatre questions, contrôlée uniquement côté serveur.
- Accès accordé uniquement avec quatre réponses correctes ; temporisation automatique après deux échecs.
- Conservation des tentatives et réponses soumises pour assurer un historique vérifiable.
- Ajout d'un espace professionnel avec recherche et catégories opérationnelles clairement identifiées.
- Les contenus non encore validés sont annoncés comme « Bientôt disponible » et ne simulent aucune fonctionnalité.
- Ajout au panel administrateur d'un centre propriétaire pour attribuer, révoquer ou restaurer les accès.
- Toutes les actions sensibles sont contrôlées côté serveur, protégées par RLS et inscrites au journal d'audit.
