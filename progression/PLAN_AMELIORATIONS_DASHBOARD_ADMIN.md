# COP’IQ — Plan d’améliorations du dashboard administrateur

> Document de travail évolutif — version initiale des priorités du dashboard.
>
> Objectif : transformer le panel administrateur en véritable centre de pilotage de COP’IQ, sans modifier les parcours utilisateurs ni les logiques métier déjà fonctionnelles.

## Principes non négociables

- Préserver le fonctionnement actuel de l’application mobile, du site et de la synchronisation avec Supabase.
- Uniformiser les données des quatre parcours existants : **Scolarité GPX**, **Scolarité PA**, **Concours GPX** et **Concours PA**.
- Conserver le parcours **Je suis actif** dans une zone séparée tant qu’il est en développement.
- N’afficher que des données réellement collectées ; ne jamais estimer ou inventer un chiffre.
- Protéger les statistiques par les contrôles d’accès administrateur et l’authentification renforcée.
- Respecter les seuils de confidentialité : masquer ou regrouper les résultats lorsqu’un échantillon est trop faible.
- Préserver les boutons et redirections existants dans les home pages et le mode picker.
- Le dashboard doit rester utilisable sur ordinateur, tablette et petit écran.

## Périmètre des priorités initiales

1. Centre de décisions et détection des changements importants.
2. Analyse pédagogique détaillée des parcours, thèmes, difficultés et questions.
3. Pilotage économique avec intégration des données des boutiques.
4. Cohortes, rétention et comparaison des mises à jour.
5. Performance, fraîcheur des données et robustesse du dashboard.

Les axes 1 à 85 de ce document constituent tous des **priorités initiales**. L’ordre proposé ci-dessous sert uniquement à organiser la réalisation et les dépendances ; il ne transforme aucun axe en idée secondaire ou optionnelle.

---

## 1. Centre de décisions et détection des changements

### Objectif

Permettre au propriétaire de comprendre en quelques secondes ce qui mérite une action, au lieu de parcourir de nombreuses cartes de chiffres.

### Éléments à créer

- Une synthèse en haut du dashboard : **À surveiller**, **En amélioration**, **Stable**.
- Une comparaison automatique avec la période précédente : 7/14, 30/60 ou 90/180 jours.
- Des alertes lisibles, par exemple :
  - baisse de l’activité quotidienne ;
  - baisse du taux de réponses correctes ;
  - hausse des erreurs techniques ;
  - diminution de la rétention J+7 ;
  - hausse des signalements sur un contenu ;
  - augmentation des désabonnements ou remboursements.
- Un niveau de gravité : information, attention, critique.
- Un bouton **Voir le détail** qui ouvre directement la section et le filtre concernés.
- Une date de dernière actualisation et une indication claire de la période analysée.
- Un historique des alertes : détectée, consultée, résolue, ignorée.

### Règles de calcul

- Comparer des périodes de même durée et dans le même fuseau horaire Europe/Paris.
- Afficher une variation en valeur absolue et en pourcentage.
- Ne pas déclencher d’alerte sous un seuil minimal de données.
- Utiliser des seuils configurables, par exemple : variation supérieure à 20 % et au moins 20 réponses ou 5 apprenants.
- Distinguer une vraie baisse d’une journée incomplète ou d’un retard de remontée des données.

### Interface attendue

- Une zone compacte, priorisée par gravité.
- Couleurs accessibles : bleu pour l’information, ambre pour l’attention, rouge uniquement pour le critique, vert pour l’amélioration.
- Icônes SVG cohérentes avec le design COP’IQ.
- États de chargement avec skeleton ou indicateur discret.
- Animation courte de 150 à 300 ms uniquement lors de l’apparition ou de la résolution d’une alerte.
- Navigation clavier et focus visible sur chaque action.

### Critères de validation

- Le propriétaire identifie la priorité du jour sans ouvrir toutes les sections.
- Chaque alerte affiche sa définition, sa période et son échantillon.
- Une alerte insuffisamment documentée n’est pas affichée comme une conclusion.
- Cliquer sur une alerte ouvre la bonne section avec le bon filtre.

---

## 2. Analyse pédagogique détaillée

### Objectif

Passer d’un suivi global des quiz à un outil qui indique précisément quels contenus améliorer.

### Périmètre

Appliquer la même logique aux quatre parcours :

- Scolarité GPX ;
- Scolarité PA ;
- Concours GPX ;
- Concours PA.

Le module **Je suis actif** reste identifié séparément et ne doit pas être mélangé aux comparaisons tant qu’il est en développement.

### Indicateurs à afficher

- réponses sauvegardées ;
- bonnes réponses ;
- taux de réussite ;
- apprenants distincts ;
- quiz commencés et terminés lorsque ces événements existent ;
- progression par module, catégorie, sous-catégorie et difficulté ;
- questions les plus souvent ratées ;
- questions avec le plus grand nombre de tentatives ;
- questions signalées par les utilisateurs ;
- temps de réponse uniquement si ce temps est effectivement collecté ;
- évolution de chaque indicateur sur 7, 30 et 90 jours.

### Règle pédagogique essentielle

Le taux de réussite est calculé uniquement sur les réponses réellement sauvegardées par l’application. La longueur choisie pour une série — par exemple 500 questions — ne doit jamais être comptée comme 500 réponses si l’utilisateur n’en a répondu que 24.

### Vue recommandée

1. Sélecteur de parcours.
2. Sélecteur de module ou catégorie.
3. Sélecteur de difficulté.
4. Tableau triable des contenus.
5. Détail d’une question avec historique agrégé et signalements associés.
6. Export CSV filtré.

### Protection contre les mauvaises conclusions

- Masquer le pourcentage sous 20 réponses ou 5 apprenants.
- Afficher à la place : **Échantillon insuffisant**.
- Afficher le volume à côté de chaque pourcentage.
- Signaler lorsqu’un apprenant a changé de parcours entre deux périodes.
- Exclure les réponses supprimées ou invalidées.

### Critères de validation

- Un clic permet de passer du parcours à la question problématique.
- Les quatre parcours ont exactement les mêmes définitions d’indicateurs.
- Le résultat affiché correspond à une requête vérifiable dans Supabase.
- Le classement ne favorise pas artificiellement un contenu ayant très peu de réponses.

---

## 3. Pilotage économique et abonnements

### Objectif

Mesurer la rentabilité réelle de COP’IQ, et pas uniquement le nombre de comptes Premium actifs.

### Indicateurs à intégrer

- chiffre d’affaires brut ;
- produit net après commissions ;
- achats et renouvellements ;
- essais commencés et convertis ;
- taux de conversion vers Premium ;
- abonnements actifs, annulés, expirés et en impayé ;
- remboursements ;
- churn mensuel ;
- revenu moyen par abonné payant ;
- valeur estimée sur la durée de vie, uniquement lorsque les données sont suffisantes ;
- répartition iOS/Android et par offre ;
- évolution par version de l’application et période.

### Sources

- App Store Connect Analytics Reports API pour iOS.
- Google Play Developer Reporting / données de ventes pour Android.
- Événements de paiement et webhooks validés par le serveur.
- Table interne normalisée pour éviter de mélanger statut d’abonnement et transaction.

### Architecture recommandée

- Importer les rapports côté serveur ou via une fonction sécurisée.
- Ne jamais placer de clé privée App Store, Google Play ou Stripe dans le navigateur.
- Stocker les événements avec un identifiant d’origine unique pour éviter les doublons.
- Construire des agrégats journaliers et mensuels dans Supabase.
- Afficher la date de dernière importation et les éventuels retards.

### Interface attendue

- Onglets **Revenus**, **Abonnements**, **Conversion**, **Remboursements**.
- Sélecteurs période, boutique, offre et plateforme.
- Graphique de tendance avec tableau accessible en alternative.
- Encadré expliquant brut/net et la date de clôture des données.
- Badge **Données incomplètes** lorsque l’import d’une boutique est en retard.

### Critères de validation

- Aucun montant ne s’affiche tant que sa source n’est pas raccordée et vérifiée.
- Les transactions sont dédupliquées.
- Le total du dashboard est réconciliable avec les rapports des boutiques.
- Les remboursements et annulations ne sont pas confondus avec les nouveaux achats.

---

## 4. Cohortes, rétention et comparaison des mises à jour

### Objectif

Comprendre si les utilisateurs reviennent, progressent et restent après une nouvelle version ou une modification de parcours.

### Cohortes à proposer

- semaine d’inscription ;
- mois d’inscription ;
- premier parcours choisi ;
- parcours actuel ;
- plateforme iOS/Android ;
- version de l’application ;
- source d’acquisition lorsqu’elle sera instrumentée.

### Mesures

- rétention J+1, J+7, J+14, J+30 et J+90 ;
- utilisateurs actifs par cohorte ;
- première réponse à un quiz ;
- première série terminée ;
- retour après une mise à jour ;
- progression moyenne basée uniquement sur les réponses enregistrées ;
- conversion Premium par cohorte ;
- désinstallation ou absence de retour lorsqu’elle est mesurable légalement et techniquement.

### Vues recommandées

- matrice de rétention par cohorte ;
- comparaison de deux versions ;
- courbe des retours dans le temps ;
- filtre parcours + plateforme + version ;
- export CSV pour analyse externe.

### Règles d’interprétation

- Une cohorte doit être assez ancienne pour atteindre le jour affiché.
- Afficher le nombre de personnes de la cohorte à côté du taux.
- Masquer les résultats trop faibles.
- Ne pas conclure qu’une version est meilleure sans période comparable.
- Séparer la rétention d’un utilisateur de la durée réelle d’une session, qui nécessite une instrumentation dédiée.

### Critères de validation

- Le dashboard compare des cohortes de même définition.
- Le propriétaire peut isoler une mise à jour précise.
- Les résultats restent compréhensibles sans connaissance statistique avancée.
- Les cohortes ne révèlent jamais l’identité d’un utilisateur individuel.

---

## 5. Performance, fraîcheur et robustesse

### Objectif

Garder un panel rapide, fiable et agréable même lorsque le nombre d’utilisateurs, de réponses et de journaux augmente.

### Côté interface

- Charger les sections lourdes progressivement.
- Conserver les chiffres précédents pendant une actualisation en arrière-plan.
- Afficher immédiatement un état de chargement clair.
- Éviter les décalages de mise en page en réservant l’espace des graphiques.
- Réduire les re-rendus inutiles avec des composants mémorisés lorsque nécessaire.
- Prévoir les états vide, erreur, retard de données et accès refusé.
- Respecter `prefers-reduced-motion`.
- Garder les tableaux utilisables au clavier et sur petit écran.

### Côté Supabase/Postgres

- Utiliser des fonctions d’agrégation owner-only plutôt que d’exposer des lignes individuelles.
- Ajouter les index correspondant aux filtres et aux dates réellement utilisés.
- Vérifier les plans avec `EXPLAIN` avant et après chaque optimisation.
- Éviter les scans complets répétés sur les journaux volumineux.
- Préparer des agrégats journaliers pour les statistiques historiques lourdes.
- Utiliser Supabase Cron pour les calculs périodiques lorsque le temps réel n’est pas nécessaire.
- Fixer une durée maximale et un nombre limité de jobs concurrents.
- Ne jamais exposer de clé `service_role` au client.
- Conserver RLS et les contrôles owner/AAL2 sur les fonctions administrateur.

### Fraîcheur à afficher

- **Temps réel** : alertes critiques et état des services.
- **Moins d’une minute** : activité et réponses récentes.
- **Quotidien** : cohortes, tendances longues et revenus importés.
- Afficher partout : heure de collecte, fuseau horaire, période et source.

### Critères de validation

- Le dashboard ne devient pas vide pendant un rafraîchissement.
- Une erreur d’une section n’empêche pas les autres sections de s’afficher.
- Les requêtes lourdes ont un plan contrôlé et un temps acceptable.
- Un test de montée en charge est prévu avant d’ajouter de nouveaux indicateurs.

---

## Plan de réalisation conseillé

### Phase 1 — Fiabiliser et décider

- Valider les définitions des indicateurs.
- Ajouter la comparaison à la période précédente.
- Créer le centre de décisions.
- Ajouter les états d’erreur, vide et données insuffisantes.

### Phase 2 — Améliorer le pilotage pédagogique

- Ajouter les filtres parcours/module/difficulté.
- Ajouter le classement des questions à revoir.
- Relier les signalements aux contenus.
- Tester les exports CSV.

### Phase 3 — Mesurer la croissance

- Mettre en place les cohortes.
- Comparer les versions de l’application.
- Ajouter les événements d’acquisition manquants.

### Phase 4 — Raccorder les revenus

- Importer les rapports iOS.
- Importer les rapports Android.
- Réconcilier les transactions et remboursements.
- Afficher uniquement les montants validés.

### Phase 5 — Industrialiser

- Ajouter les agrégats journaliers.
- Planifier les calculs lourds.
- Ajouter les alertes de qualité des données.
- Documenter les procédures de contrôle et de restauration.

## Liste de contrôle avant mise en production

- [ ] Les quatre parcours sont contrôlés.
- [ ] Le module Je suis actif est séparé et clairement marqué comme développement.
- [ ] Aucune statistique n’est inventée.
- [ ] Les seuils d’échantillon sont visibles.
- [ ] Les contrôles owner/AAL2 sont vérifiés.
- [ ] Les clés privées restent côté serveur.
- [ ] Les graphiques ont une alternative sous forme de tableau.
- [ ] Les actions ont un état de chargement et une confirmation claire.
- [ ] Le mode sombre, le contraste, le clavier et les petits écrans sont testés.
- [ ] Les temps de réponse des requêtes sont documentés.
- [ ] Une sauvegarde et une procédure de retour arrière existent.
- [ ] Le dossier de publication contient la version validée et son manifeste.

## Idées à ajouter dans les prochaines versions

- segmentation par appareil et version d’OS ;
- suivi des campagnes d’acquisition ;
- centre de contact et campagnes d’e-mails no-reply ;
- journal d’audit lisible des actions administrateur ;
- permissions par rôle plus fines ;
- détection de comportements anormaux ;
- rapports PDF ou partage sécurisé ;
- comparaison avec des objectifs définis par le propriétaire ;
- notifications lorsqu’un seuil critique est atteint.

---

## Priorités initiales complémentaires à intégrer au cahier des charges

Ces axes complètent les cinq premières améliorations et font partie du périmètre initial PREMIUM du panel. Ils doivent être planifiés dès le départ, même si leur livraison est répartie en plusieurs phases.

### 6. Centre de contact utilisateurs

- Envoyer un e-mail à un utilisateur précis, à un parcours, à un segment ou à tous les utilisateurs.
- Utiliser exclusivement l’expéditeur `no-reply@copiq.fr` pour les envois automatiques.
- Prévoir des modèles d’e-mails réutilisables : mise à jour, information, remerciement, rappel et incident.
- Ajouter un aperçu avant envoi et une confirmation pour les envois groupés.
- Conserver l’historique : auteur, date, destinataires, statut envoyé, échec ou en attente.
- Prévoir une liste d’exclusion et respecter les préférences de communication.
- Ne jamais afficher les adresses e-mail dans les statistiques agrégées.

### 7. Gestion éditoriale des contenus

- Organiser le cycle **Brouillon → Relecture → Aperçu → Publication → Archivage**.
- Programmer une date et une heure de publication.
- Ajouter un aperçu fidèle au rendu mobile avant publication.
- Permettre la dépublication et le retour à une version précédente.
- Afficher les contenus modifiés récemment et ceux qui attendent une relecture.
- Ajouter une checklist de publication : titre, sous-titre, image, catégorie, ordre, contenu et liens.
- Garder séparément les contenus des quatre parcours et le module « Je suis actif » en développement.

### 8. Recherche globale et palette de commandes

- Rechercher depuis un champ unique un utilisateur, cours, question, signalement, version, abonnement ou message.
- Afficher les résultats par catégorie avec accès direct à la page concernée.
- Ajouter des raccourcis clavier pour les actions fréquentes.
- Permettre la navigation au clavier et conserver un focus visible.
- Mémoriser les derniers filtres et les recherches récentes de l’administrateur.

### 9. Journal d’audit avancé

- Afficher qui a réalisé chaque action, quand et depuis quel espace du panel.
- Conserver la valeur avant et après modification lorsque cela est nécessaire pour comprendre l’action.
- Filtrer par administrateur, rôle, parcours, module, période et type d’action.
- Distinguer les actions de consultation, modification, publication, suppression et connexion.
- Rendre le journal non modifiable et exportable pour les contrôles internes.
- Ajouter un lien direct vers la ressource concernée.

### 10. Contrôle automatique de la qualité des contenus

- Repérer les cours sans image ou avec une URL inaccessible.
- Détecter les catégories vides, les titres manquants et les sous-titres incohérents.
- Détecter les questions sans réponse correcte, les choix dupliqués et les énoncés vides.
- Repérer les doublons de cours, de questions et de catégories.
- Afficher un score de qualité par parcours et par module.
- Donner une action corrective directe pour chaque anomalie.
- Recalculer les contrôles après chaque modification importante.

### 11. Suivi des versions iOS et Android

- Comparer l’adoption de chaque version de l’application.
- Suivre les incidents, crashs, blocages et erreurs par version, plateforme et appareil lorsque la donnée existe.
- Afficher une chronologie des publications et des changements importants.
- Relier une hausse d’erreurs à la version concernée sans exposer de données personnelles.
- Ajouter un état de déploiement : préparation, test, déploiement progressif, disponible ou retirée.
- Afficher la fraîcheur de chaque source et signaler un retard d’import.

### 12. Objectifs et indicateurs personnalisés

- Permettre au propriétaire de créer un objectif avec une valeur cible et une échéance.
- Exemples : taux de réussite, nombre de cours publiés, activité quotidienne ou conversion Premium.
- Afficher la progression, la tendance et l’écart restant.
- Associer un objectif à un parcours, une plateforme ou l’ensemble de l’application.
- Signaler automatiquement les objectifs en avance, à risque ou dépassés.
- Conserver l’historique des objectifs terminés.

### 13. Comparaison des parcours

- Comparer Scolarité GPX, Scolarité PA, Concours GPX et Concours PA sur la même période.
- Comparer activité, réponses, réussite, rétention, signalements et abonnements.
- Garder « Je suis actif » dans un bloc indépendant tant que son développement n’est pas terminé.
- Afficher les définitions et les volumes à côté de chaque taux.
- Éviter toute comparaison lorsque les échantillons sont trop faibles.
- Permettre l’export du comparatif filtré.

### 14. Détection des anomalies et alertes techniques

- Détecter une chute brutale de l’activité ou des réponses enregistrées.
- Détecter une hausse inhabituelle des erreurs, signalements ou échecs de synchronisation.
- Détecter un import de données bloqué ou trop ancien.
- Détecter une augmentation des échecs d’envoi d’e-mails.
- Ajouter un niveau de gravité, une date de détection et une action recommandée.
- Éviter les alertes répétitives pour le même incident non résolu.

### 15. Sauvegarde et restauration administrateur

- Sauvegarder les configurations et les contenus avant une opération importante.
- Conserver plusieurs versions avec date, auteur et résumé des changements.
- Permettre de restaurer une configuration ou un contenu précis.
- Tester régulièrement la restauration sur un environnement séparé.
- Ne jamais inclure de clé secrète dans un export téléchargeable.
- Prévoir une procédure de retour arrière documentée.

### 16. Rôles administrateur plus précis

- Séparer les accès propriétaire, contenu, support, modération, statistiques et facturation.
- Permettre des permissions par rubrique et par type d’action.
- Limiter les actions sensibles à l’owner ou à une permission explicite.
- Exiger l’authentification renforcée pour les statistiques, exports, droits et opérations sensibles.
- Afficher clairement les permissions du compte connecté.
- Journaliser toute modification d’un rôle ou d’une permission.

### 17. Vue « Santé globale de COP’IQ »

- Présenter un résumé unique de l’activité, de la pédagogie, des revenus, de la qualité technique, du contenu et de la communauté.
- Calculer un état par domaine : sain, à surveiller ou critique.
- Afficher la cause de chaque état, pas seulement une couleur.
- Donner un accès direct aux actions prioritaires.
- Conserver un historique de l’état global pour mesurer l’évolution de l’application.

### 18. Suivi des campagnes d’acquisition

- Ajouter des liens différenciés pour TikTok, Instagram, YouTube, publicité, recommandation et partenaires.
- Mesurer visites, inscriptions, première activité, quiz et conversion Premium par source.
- Séparer les campagnes iOS et Android lorsque cela est possible.
- Respecter les préférences de consentement et minimiser les données collectées.
- Afficher un échantillon insuffisant lorsque la source comporte trop peu d’utilisateurs.

### 19. Rapports automatiques

- Générer un résumé hebdomadaire et mensuel.
- Inclure les indicateurs clés, les variations, les alertes, les contenus à revoir et les objectifs.
- Envoyer le rapport au propriétaire ou le rendre disponible au téléchargement.
- Ajouter un historique des rapports générés et de leur statut.
- Permettre de choisir la fréquence et les sections incluses.

### 20. Expérience premium du panel

- Ajouter des filtres communs et persistants entre les pages.
- Utiliser une hiérarchie visuelle claire : priorité, chiffre, contexte, action.
- Réserver l’espace des graphiques pour éviter les décalages de mise en page.
- Utiliser des skeletons et des états d’erreur explicites.
- Garder les animations courtes, utiles et compatibles avec le réglage de mouvement réduit.
- Respecter les contrastes, les tailles de zones cliquables et la navigation clavier.
- Prévoir des vues adaptées aux résolutions 375, 768, 1024 et 1440 px.

---

## Nouvelles priorités initiales à ajouter

Les axes suivants sont également prioritaires. Ils complètent les axes 1 à 20 et doivent être considérés dans la conception globale du panel.

### 21. Alertes intelligentes

- Détecter automatiquement une chute anormale de l’activité.
- Détecter une hausse inhabituelle des erreurs, signalements ou échecs de synchronisation.
- Détecter un import bloqué ou des données trop anciennes.
- Afficher l’alerte dans le dashboard et dans un centre de notifications administrateur.
- Attribuer un niveau : information, attention ou critique.
- Afficher la cause, la période, le volume concerné et l’action recommandée.
- Regrouper les alertes identiques pour éviter les doublons.
- Permettre de marquer une alerte comme lue, traitée ou ignorée.

### 22. Analyse détaillée du parcours utilisateur

- Suivre les étapes : inscription, première connexion, premier cours, premier quiz, première série terminée et passage Premium.
- Mesurer le nombre d’utilisateurs qui avancent ou abandonnent à chaque étape.
- Identifier les étapes avec la plus forte perte d’utilisateurs.
- Filtrer par parcours, plateforme, version et période.
- Afficher les volumes avec chaque taux de conversion.
- Ne pas présenter de conclusion lorsque l’échantillon est insuffisant.
- Permettre d’ouvrir le détail du parcours sans exposer l’identité des utilisateurs.

### 23. Impact réel des contenus

- Mesurer l’évolution des résultats après consultation d’un cours.
- Relier un cours, une catégorie ou une fiche aux questions réussies et échouées.
- Identifier les modules associés à une progression positive.
- Identifier les modules consultés mais suivis d’un abandon.
- Comparer les résultats avant et après une modification éditoriale.
- Afficher clairement lorsqu’une corrélation ne permet pas de conclure à une causalité.
- Ajouter une vue des contenus les plus utiles et des contenus à retravailler.

### 24. Analyse par version de l’application

- Comparer l’adoption des versions iOS et Android.
- Mesurer l’activité, les réponses, la réussite et les erreurs par version.
- Identifier les versions qui provoquent une dégradation après publication.
- Afficher la progression du déploiement d’une version.
- Relier les versions aux signalements et aux incidents techniques.
- Ajouter un filtre version dans les vues activité, qualité et rétention.
- Conserver une chronologie des publications et des changements importants.

### 25. Système d’objectifs et de résultats clés

- Créer un objectif avec une valeur cible, une période et une échéance.
- Associer un objectif à un parcours, une plateforme ou toute l’application.
- Suivre le nombre d’utilisateurs actifs, le taux de réussite, les contenus publiés, les abonnements ou tout autre indicateur disponible.
- Afficher la progression, l’écart restant et la tendance.
- Classer les objectifs : en avance, en bonne voie, à risque ou dépassé.
- Conserver l’historique des objectifs atteints.
- Permettre au propriétaire de modifier ou archiver un objectif.

### 26. Centre de notifications administrateur

- Centraliser les nouveaux signalements, messages, alertes, erreurs d’envoi et résultats d’import.
- Afficher un compteur non lu.
- Regrouper les notifications par priorité et par rubrique.
- Ajouter un lien direct vers l’action concernée.
- Permettre de marquer une notification comme lue ou traitée.
- Conserver un historique des notifications importantes.
- Prévoir une préférence de réception pour chaque administrateur.

### 27. Opérations groupées sécurisées

- Publier, archiver ou modifier plusieurs contenus en une seule opération.
- Appliquer une action à une catégorie, un module, un parcours ou une sélection filtrée.
- Envoyer une campagne à un segment d’utilisateurs.
- Présenter un aperçu des éléments concernés avant l’action.
- Afficher le nombre exact de lignes ou de destinataires concernés.
- Proposer un mode simulation avant l’exécution définitive.
- Demander une confirmation renforcée pour les actions irréversibles.
- Journaliser chaque opération groupée avec son résultat détaillé.

### 28. Historique complet et restauration des contenus

- Conserver les versions successives d’un cours, d’une question, d’une catégorie et d’une configuration.
- Afficher l’auteur, la date et le résumé de chaque modification.
- Comparer deux versions avant/après.
- Restaurer une ancienne version après confirmation.
- Créer une sauvegarde avant toute opération groupée.
- Vérifier que la restauration ne modifie pas les réponses ou statistiques historiques.
- Journaliser toute restauration.

### 29. Contrôle de cohérence des données

- Détecter les statistiques incompatibles entre plusieurs sources.
- Repérer les événements manquants ou impossibles.
- Détecter les doublons de sessions, réponses, transactions et campagnes.
- Vérifier que les quatre parcours utilisent les mêmes définitions.
- Signaler les dates futures, valeurs négatives ou relations incohérentes.
- Afficher la date du dernier contrôle et le nombre d’anomalies.
- Permettre de relancer un contrôle après correction.

### 30. Vue de pilotage quotidien

- Présenter en haut de page les trois actions les plus urgentes.
- Afficher les trois contenus à améliorer en priorité.
- Afficher les trois alertes les plus importantes.
- Afficher les objectifs à risque.
- Afficher les changements notables depuis la veille ou la semaine précédente.
- Donner un accès direct à chaque action.
- Permettre au propriétaire de comprendre l’état de COP’IQ en moins de 30 secondes.

### 31. Vues personnalisées du dashboard

- Enregistrer une vue « Scolarité GPX », « Scolarité PA », « Concours GPX » ou « Concours PA ».
- Enregistrer les filtres de période, plateforme, version et module.
- Choisir les indicateurs et cartes affichés.
- Définir une vue par défaut pour chaque administrateur.
- Partager une vue avec les autres administrateurs selon leurs permissions.
- Restaurer les filtres précédents après une reconnexion.
- Permettre de réinitialiser rapidement tous les filtres.

### 32. Prévisualisation propriétaire et environnement de développement

- Permettre au compte owner de voir un contenu avant sa publication utilisateur.
- Tester un module ou une catégorie sans l’exposer aux autres comptes.
- Distinguer clairement brouillon, aperçu owner, test, publication et archivage.
- Préserver la logique existante de visibilité pour les utilisateurs.
- Afficher un bandeau visible lorsqu’un contenu est uniquement accessible au owner.
- Ajouter une action pour rendre le contenu visible aux utilisateurs lorsque la validation est terminée.
- Journaliser les changements de visibilité.

## Nouvelles priorités avancées à intégrer

Les axes 33 à 50 complètent les priorités précédentes. Ils doivent être pris en compte dans l’architecture du panel dès le début, même si leur développement intervient progressivement.

### 33. Dictionnaire des statistiques

- Documenter chaque indicateur avec son nom, sa définition, sa formule, sa source et son unité.
- Afficher la période, le fuseau horaire et la date de dernière actualisation.
- Indiquer les tables, événements ou rapports utilisés pour le calcul.
- Préciser les seuils d’échantillon et les limites d’interprétation.
- Conserver l’historique des changements de définition.
- Rendre la définition accessible depuis chaque carte, graphique ou tableau.

### 34. Traçabilité des données

- Permettre de remonter d’un indicateur vers sa source agrégée.
- Afficher le dernier contrôle de fraîcheur et le statut de l’import.
- Identifier les données manquantes ou incomplètes.
- Distinguer clairement données temps réel, données calculées et données importées.
- Journaliser les corrections et recalculs d’agrégats.
- Ne jamais exposer de lignes personnelles pour expliquer une statistique.

### 35. Centre d’expérimentation

- Tester deux variantes d’un écran, d’un texte, d’un cours ou d’un parcours.
- Définir une audience, une période et un indicateur de réussite avant le test.
- Comparer activité, réussite, rétention et conversion entre les variantes.
- Afficher la taille des groupes et les limites de comparaison.
- Arrêter, prolonger ou valider une expérimentation depuis le panel.
- Conserver les résultats et la décision prise dans le journal d’audit.

### 36. Feature flags administrateurs

- Activer une fonctionnalité pour le compte owner uniquement.
- Activer une fonctionnalité pour un groupe de test ou un parcours précis.
- Prévoir une activation progressive par pourcentage lorsque la mesure est fiable.
- Afficher l’état actuel, l’auteur et la date de chaque changement.
- Permettre un retour arrière immédiat.
- Séparer les flags de développement, de test et de production.
- Ne jamais modifier les règles de visibilité utilisateur sans confirmation explicite.

### 37. Surveillance des performances réelles

- Mesurer le temps de démarrage de l’application lorsqu’il est collecté.
- Mesurer le chargement d’un cours, d’un quiz et d’une image lorsque l’événement existe.
- Suivre la latence et le taux d’échec des appels Supabase.
- Comparer les performances par plateforme, version, appareil et réseau lorsque disponible.
- Identifier les écrans les plus lents.
- Afficher les percentiles utiles plutôt qu’une seule moyenne.
- Masquer les métriques non fiables lorsque l’échantillon est trop faible.

### 38. Centre d’incidents

- Créer un incident avec titre, gravité, date de détection et périmètre affecté.
- Associer les versions, plateformes, parcours et services touchés.
- Suivre les étapes : détecté, en analyse, contourné, corrigé, vérifié et clôturé.
- Ajouter les actions réalisées et les responsables.
- Relier l’incident aux alertes, signalements et journaux concernés.
- Conserver une analyse de cause et une action préventive.
- Afficher un résumé public uniquement si une communication utilisateur est décidée.

### 39. Checklist de mise en production

- Vérifier les titres, sous-titres, catégories, images et liens.
- Vérifier les réponses correctes, explications et niveaux de difficulté.
- Vérifier les permissions, migrations, configurations et sauvegardes.
- Vérifier les quatre parcours et la séparation de « Je suis actif ».
- Vérifier les redirections, favoris, signalements et synchronisations existantes.
- Afficher les contrôles bloquants et les avertissements non bloquants.
- Exiger une confirmation owner pour publier une version sensible.
- Enregistrer le résultat de la checklist dans le journal d’audit.

### 40. Tests automatiques de non-régression

- Tester l’ouverture des quatre parcours et du mode picker.
- Tester la sélection de niveau, les quiz, les réponses sauvegardées et les moyennes.
- Tester l’ajout et la suppression des favoris.
- Tester les signalements, leur traitement et la synchronisation associée.
- Tester les droits owner, administrateur et utilisateur.
- Tester les états hors ligne, erreur, chargement et session expirée.
- Lancer les tests avant publication et afficher un résultat lisible dans le panel.
- Bloquer uniquement les publications touchées par un échec critique.

### 41. Gestion RGPD et confidentialité

- Gérer les demandes d’accès, d’export et de suppression de compte.
- Afficher les catégories de données conservées et leur finalité.
- Suivre les consentements et préférences de communication.
- Définir les durées de conservation par type de donnée.
- Journaliser les accès administrateur aux informations sensibles.
- Agréger ou anonymiser les statistiques lorsque l’identification indirecte est possible.
- Prévoir une procédure de suppression ou d’anonymisation vérifiable.

### 42. Accessibilité mesurée

- Contrôler les contrastes, tailles de texte et états de focus.
- Vérifier les libellés des boutons et icônes.
- Tester la navigation clavier et lecteur d’écran.
- Fournir une alternative tabulaire à chaque graphique important.
- Tester les résolutions 375, 768, 1024 et 1440 px.
- Respecter le réglage de mouvement réduit.
- Afficher les erreurs de formulaire près du champ concerné.

### 43. Centre de feedback utilisateurs

- Regrouper notes, messages, signalements, demandes de support et retours de bêta-test.
- Classer les retours par fréquence, gravité, parcours et thème.
- Détecter les sujets récurrents.
- Relier un retour à un contenu, une version ou un incident.
- Suivre le statut : nouveau, analysé, planifié, en cours, livré ou refusé.
- Ajouter une note interne et une justification de décision.
- Mesurer le délai moyen de traitement et les retours résolus.

### 44. Score de priorité des améliorations

- Calculer un score à partir de la fréquence, du nombre d’utilisateurs touchés, de la gravité et de l’effort estimé.
- Permettre au propriétaire d’ajuster le poids de chaque critère.
- Afficher la justification du score.
- Relier chaque priorité à des signalements, objectifs et incidents.
- Distinguer urgence, impact pédagogique, impact commercial et dette technique.
- Conserver l’historique des décisions et changements de priorité.

### 45. Prévisions et tendances

- Projeter l’activité, les abonnements, la rétention et les réponses uniquement lorsque l’historique est suffisant.
- Afficher une fourchette et non un chiffre présenté comme certain.
- Comparer la prévision aux résultats réellement observés.
- Signaler les ruptures de tendance et les périodes atypiques.
- Permettre de désactiver les prévisions pour les petits volumes.
- Documenter la méthode et la date du dernier recalcul.

### 46. Export professionnel des données

- Exporter les résultats filtrés en CSV et JSON.
- Générer un rapport PDF lisible avec période, définitions et sources.
- Permettre un export planifié pour le propriétaire.
- Inclure les filtres et la date de génération dans chaque fichier.
- Journaliser chaque téléchargement et envoi.
- Protéger les exports contenant des données sensibles.
- Ne jamais inclure de clé secrète ou de donnée non nécessaire.

### 47. Mode démonstration sécurisé

- Afficher le panel avec des données fictives réalistes.
- Indiquer visuellement qu’il s’agit d’un environnement de démonstration.
- Empêcher toute action de production depuis ce mode.
- Permettre une démonstration du dashboard sans exposer les utilisateurs réels.
- Tester le rendu premium avec différents volumes de données.
- Séparer strictement les identifiants de démonstration et de production.

### 48. Gestion multilingue du contenu

- Préparer la traduction des cours, catégories, e-mails et messages système.
- Afficher les traductions manquantes dans un tableau de contrôle.
- Comparer la complétude par parcours et langue.
- Prévoir une validation éditoriale avant publication.
- Ne pas remplacer automatiquement un contenu validé par une traduction non relue.
- Conserver la version et l’auteur de chaque traduction.

### 49. Recommandations éditoriales

- Suggérer les cours à compléter, relire ou mettre à jour.
- Suggérer les questions à revoir selon les erreurs, signalements et incohérences.
- Identifier les catégories manquant d’exercices ou de contenu explicatif.
- Prioriser les recommandations selon leur impact et leur volume de données.
- Afficher la raison exacte de chaque recommandation.
- Permettre de valider, reporter ou ignorer une recommandation.
- Ne jamais appliquer automatiquement une correction éditoriale sans validation.

### 50. Historique de santé de la plateforme

- Construire une chronologie combinant publications, incidents, mises à jour et changements de configuration.
- Relier cette chronologie à l’évolution des utilisateurs, de l’activité et des résultats pédagogiques.
- Identifier les variations apparues après chaque version ou modification importante.
- Afficher les événements techniques, éditoriaux et commerciaux sur une même ligne du temps.
- Permettre de filtrer la chronologie par parcours, plateforme, version et période.
- Exporter la chronologie pour les bilans et rétrospectives.

## Ordre de priorité opérationnel recommandé

Même si les axes 1 à 85 sont des priorités initiales, l’ordre suivant permet d’obtenir rapidement un panel plus utile :

1. **Vue de pilotage quotidien** et **alertes intelligentes**.
2. **Analyse détaillée du parcours utilisateur**.
3. **Impact réel des contenus**.
4. **Analyse par version iOS/Android**.
5. **Centre de notifications administrateur**.
6. **Contrôle de cohérence des données**.
7. **Historique et restauration**.
8. **Opérations groupées sécurisées**.
9. **Objectifs personnalisés**.
10. **Vues personnalisées et prévisualisation owner**.
11. **Dictionnaire et traçabilité des statistiques**.
12. **Centre d’expérimentation et feature flags**.
13. **Surveillance des performances et centre d’incidents**.
14. **Checklist de production et tests de non-régression**.
15. **RGPD, accessibilité et qualité des données**.
16. **Centre de feedback et score de priorité**.
17. **Prévisions, exports et rapports professionnels**.
18. **Mode démonstration et gestion multilingue**.
19. **Recommandations éditoriales**.
20. **Historique de santé de la plateforme**.

---

## Dernières priorités initiales — exploitation avancée

Ces dix axes clôturent le périmètre initial du prompt. Ils complètent les axes 1 à 75 et doivent être prévus dans l’architecture, même si leur livraison est progressive.

### 76. Gestion des tâches administratives

- Attribuer un signalement, une correction, un message ou une anomalie à un administrateur.
- Ajouter une échéance, une priorité, un responsable et un statut.
- Afficher les tâches en retard et les tâches nécessitant une action owner.
- Regrouper les tâches par rubrique, parcours, administrateur et niveau de priorité.
- Permettre de commenter une tâche sans modifier la donnée source.
- Conserver l’historique des changements d’assignation et de statut.

### 77. Aperçu de l’impact avant publication

- Montrer les parcours, catégories, cours, quiz et écrans concernés par une modification.
- Vérifier les redirections, dépendances, images et liens avant validation.
- Afficher un résumé avant/après lisible.
- Signaler les utilisateurs ou versions potentiellement concernés.
- Bloquer ou demander une confirmation renforcée en cas d’impact important.
- Journaliser la validation et le périmètre finalement publié.

### 78. Graphe des dépendances de contenu

- Relier catégories, sous-catégories, cours, quiz, questions, images et articles.
- Afficher les dépendances avant modification ou suppression.
- Identifier les contenus orphelins ou référencés par plusieurs parcours.
- Repérer les images et liens utilisés par plusieurs pages.
- Bloquer les suppressions dangereuses tant qu’une solution n’est pas choisie.
- Permettre d’ouvrir directement chaque élément du graphe.

### 79. Monitoring des imports et synchronisations

- Suivre chaque import Supabase, boutique, e-mail ou outil analytics.
- Afficher le début, la fin, la durée, le volume, le statut et les erreurs.
- Afficher la dernière réussite et le prochain contrôle prévu.
- Permettre de relancer uniquement l’étape échouée.
- Éviter les doublons lors d’une reprise après interruption.
- Journaliser l’administrateur ou le job à l’origine du lancement.

### 80. Suivi des coûts techniques

- Surveiller les coûts de stockage, base de données, e-mails, logs et services externes.
- Afficher une estimation par fonctionnalité lorsque la source est disponible.
- Comparer les coûts à la période précédente.
- Définir des seuils d’alerte mensuels.
- Signaler les ressources inutilisées ou en croissance inhabituelle.
- Ne jamais afficher un montant estimé comme une facture définitive.

### 81. Gestion des avis App Store et Google Play

- Centraliser les notes et commentaires publics.
- Classer les avis par version, plateforme, thème et problème identifié.
- Relier un avis à un signalement ou un incident lorsqu’un rapprochement est possible.
- Suivre l’évolution de la note après une mise à jour.
- Préparer une réponse ou une action interne sans publier automatiquement.
- Respecter les règles et limites d’accès des plateformes.

### 82. Récupération des abonnements

- Détecter les paiements échoués et les abonnements en période de grâce.
- Suivre les annulations, réactivations et expirations.
- Afficher les abonnements à risque sans exposer inutilement les données personnelles.
- Distinguer paiement échoué, annulation volontaire, remboursement et expiration.
- Prévoir les e-mails de rappel autorisés et journalisés.
- Mesurer la récupération après une relance.

### 83. Changelog public et interne

- Préparer une note de version depuis le panel.
- Séparer les changements techniques, pédagogiques, visuels et correctifs.
- Prévisualiser la note avant publication.
- Publier une version publique après validation owner.
- Conserver une version interne plus détaillée pour l’équipe.
- Relier chaque changement à une version iOS, Android ou web.

### 84. Centre de documentation administrateur

- Expliquer chaque action du panel avec une aide contextuelle.
- Documenter les procédures de publication, restauration, signalement et envoi d’e-mail.
- Ajouter des checklists réutilisables.
- Afficher les avertissements liés aux permissions et aux actions irréversibles.
- Permettre au owner de mettre à jour les procédures sans modifier le code.
- Conserver la version et la date de chaque procédure.

### 85. Tests de restauration et plan de continuité

- Vérifier régulièrement qu’une sauvegarde peut réellement être restaurée.
- Tester les restaurations sur un environnement séparé.
- Prévoir un environnement de secours pour le panel et les contenus publics.
- Documenter les actions en cas de panne, corruption ou erreur de publication.
- Définir les délais acceptables de reprise et la perte maximale de données tolérée.
- Journaliser les tests de restauration et leurs résultats.

## Clôture du périmètre initial

Le prompt comprend désormais **85 priorités initiales** couvrant : le dashboard, les statistiques, la pédagogie, les revenus, les utilisateurs, les contenus, le site public, la sécurité, le RGPD, le SEO, la performance, les tests, les opérations administratives et la continuité de service.

---

## Priorités initiales du site public

Ces exigences s’appliquent au site visible par tous les visiteurs. Elles ne doivent pas dégrader le panel administrateur ni les parcours authentifiés. Lorsqu’une brique existe déjà, elle doit être auditée, testée et maintenue plutôt que recréée.

### 51. Page de politique de confidentialité

- Publier une page claire, accessible depuis le pied de page et les formulaires.
- Décrire les données collectées, les finalités, les bases légales, les destinataires et les durées de conservation.
- Expliquer séparément les comptes, quiz, signalements, abonnements, e-mails, cookies et statistiques.
- Décrire les droits d’accès, rectification, suppression, opposition et export.
- Afficher la date de dernière mise à jour et un contact dédié.
- Vérifier que le contenu correspond réellement aux traitements actifs de COP’IQ.

### 52. Page de conditions générales d’utilisation

- Décrire les règles d’accès, les comptes, les abonnements, les contenus et les responsabilités.
- Préciser les règles d’utilisation des quiz, cours, signalements et espaces communautaires.
- Décrire les conditions de résiliation, suspension et modification du service.
- Ajouter une version, une date d’entrée en vigueur et un historique des changements.
- Rendre la page accessible avant la création de compte et depuis le pied de page.

### 53. Sécurité des clés et secrets

- Ne jamais exposer de clé `service_role`, clé privée, secret de paiement ou identifiant de fournisseur dans le navigateur.
- Vérifier l’historique Git, les exports statiques, les journaux et les bundles pour détecter une fuite.
- Utiliser uniquement une clé publique/publishable lorsque le client en a réellement besoin.
- Déplacer les opérations privilégiées vers un serveur ou une fonction sécurisée.
- Révoquer et renouveler immédiatement toute clé qui aurait été exposée.
- Ajouter un contrôle automatisé anti-secret avant chaque publication.

### 54. HTTPS et en-têtes de sécurité

- Rediriger systématiquement HTTP vers HTTPS.
- Activer HSTS après vérification du domaine et des sous-domaines.
- Vérifier les certificats, les ressources mixtes et les redirections canoniques.
- Ajouter une Content-Security-Policy adaptée au site et aux appels Supabase nécessaires.
- Ajouter les en-têtes de protection appropriés : frame ancestors, type MIME, referrer et permissions.
- Tester les en-têtes en production après chaque changement d’hébergement.

### 55. Bandeau de consentement aux cookies

- Distinguer cookies nécessaires, mesure d’audience et éventuels cookies marketing.
- Refuser les cookies non nécessaires par défaut.
- Permettre d’accepter, refuser ou personnaliser avec la même facilité.
- Ne charger aucun outil d’analytics avant le consentement correspondant.
- Permettre de modifier ou retirer son choix depuis le pied de page.
- Versionner le consentement lorsqu’une finalité ou un fournisseur change.
- Conserver uniquement le minimum nécessaire pour mémoriser le choix.

### 56. SEO technique et métadonnées

- Ajouter un `title` unique et descriptif à chaque page publique.
- Ajouter une `meta description` utile et spécifique à chaque page.
- Définir les URL canoniques et les balises Open Graph/Twitter.
- Vérifier les titres H1/H2, la structure sémantique et les liens internes.
- Empêcher l’indexation des pages privées, d’administration et de test.
- Éviter les titres dupliqués, trop longs ou génériques.

### 57. Image de prévisualisation sociale

- Créer une image Open Graph cohérente avec l’identité COP’IQ.
- Définir `og:image`, `og:title`, `og:description` et les dimensions adaptées.
- Prévoir une image de secours si une page n’a pas d’image dédiée.
- Tester l’aperçu sur les principales plateformes sociales.
- Héberger l’image sur une URL HTTPS stable.

### 58. Favicon et identité navigateur

- Conserver un favicon COP’IQ lisible sur fond clair et sombre.
- Ajouter les variantes nécessaires pour les navigateurs et appareils.
- Définir le thème navigateur et l’icône d’ajout à l’écran d’accueil si nécessaire.
- Vérifier que l’icône ne provient pas d’un chemin de développement ou d’une URL expirante.

### 59. Sitemap et robots.txt

- Générer un sitemap à partir des pages publiques réellement indexables.
- Exclure les pages privées, paramètres, résultats personnalisés et routes de test.
- Déclarer l’URL du sitemap dans `robots.txt`.
- Vérifier les codes HTTP, les URL canoniques et l’absence de doublons.
- Régénérer ces fichiers après chaque ajout ou suppression de page publique.

### 60. Textes alternatifs des images

- Ajouter un texte alternatif descriptif aux images informatives.
- Utiliser `alt=""` pour les images purement décoratives.
- Décrire la fonction des images cliquables dans leur alternative.
- Vérifier les logos, captures, images de cours et images Open Graph.
- Ne pas répéter dans l’alternative un texte déjà visible juste à côté.

### 61. Compression et gestion des images

- Convertir les images lourdes en WebP ou AVIF lorsque la compatibilité le permet.
- Générer plusieurs tailles et utiliser `srcset`/`sizes` pour les écrans différents.
- Utiliser le chargement différé pour les images sous la ligne de flottaison.
- Préserver un ratio et une hauteur réservée pour éviter les décalages de mise en page.
- Compresser les images sans dégrader la lisibilité des supports pédagogiques.
- Contrôler la taille maximale avant qu’une image soit publiée dans le panel.

### 62. Vitesse et budgets de performance

- Mesurer le temps d’affichage, le chargement utile, les décalages de mise en page et l’interactivité.
- Tester les pages publiques sur mobile et réseau lent.
- Fixer des budgets de poids JavaScript, CSS, images et polices.
- Éviter les bibliothèques ou scripts tiers non indispensables.
- Charger progressivement les contenus sous la ligne de flottaison.
- Conserver les résultats de mesure dans un historique par version.
- Corriger les régressions avant publication.

### 63. Contraste et lisibilité

- Vérifier un contraste suffisant pour les textes, liens, boutons et états désactivés.
- Ne jamais utiliser la couleur seule pour transmettre une information.
- Ajouter des états `hover`, `focus`, `active`, `error` et `disabled` visibles.
- Vérifier les thèmes clair et sombre.
- Tester les textes sur les images et les dégradés.
- Utiliser une taille et une hauteur de ligne lisibles sur mobile.

### 64. Responsive et qualité multi-écrans

- Adapter le site aux largeurs 375, 768, 1024 et 1440 px.
- Éviter le défilement horizontal et les éléments coupés.
- Vérifier les formulaires, tableaux, cartes, menus et fenêtres modales sur petit écran.
- Garantir des zones cliquables suffisamment grandes.
- Tester orientation portrait et paysage lorsque nécessaire.
- Vérifier Safari iOS, Chrome Android et navigateurs de bureau récents.

### 65. Page 404 personnalisée

- Créer une page 404 cohérente avec COP’IQ.
- Expliquer simplement que la page n’existe pas.
- Proposer un seul bouton principal vers la page d’accueil.
- Ajouter une recherche ou un lien secondaire uniquement si cela reste utile.
- Ne pas afficher d’erreur technique ou de chemin interne.
- Journaliser les routes 404 fréquentes pour corriger les liens concernés.

### 66. Prévention et suivi des liens cassés

- Vérifier les liens internes, externes, images, téléchargements et redirections.
- Ajouter un contrôle automatique avant publication.
- Afficher les liens invalides dans le panel administrateur avec leur page d’origine.
- Prévoir des redirections 301 lors du changement d’URL publique.
- Ne pas bloquer la publication pour un lien externe temporairement indisponible sans avertissement clair.
- Rejouer périodiquement les contrôles des liens externes.

### 67. Validation des formulaires

- Valider les champs côté client pour un retour immédiat.
- Revalider côté serveur ou dans la fonction sécurisée avant toute écriture.
- Afficher des messages d’erreur précis, proches du champ concerné.
- Conserver les valeurs valides après une erreur.
- Vérifier longueur, format, caractères dangereux et limites de taille.
- Empêcher les doubles soumissions pendant le traitement.
- Ajouter des labels, aides et états accessibles.

### 68. Protection anti-spam et anti-abus

- Protéger les formulaires de contact, inscription, signalement et récupération de compte.
- Ajouter une limitation de fréquence côté serveur ou Edge Function.
- Utiliser un honeypot ou une solution de challenge uniquement lorsque nécessaire.
- Journaliser les abus sans conserver plus de données que nécessaire.
- Ajouter une protection contre les doublons et les rafales de requêtes.
- Prévoir un mécanisme de blocage temporaire et de déblocage contrôlé.

### 69. Analytics respectueux de la vie privée

- Mesurer uniquement les événements utiles à l’amélioration du service.
- Définir une liste d’événements documentée : visite, inscription, parcours, cours, quiz, conversion et erreur.
- Ne jamais envoyer le contenu d’une réponse, une adresse e-mail ou un identifiant personnel dans un événement public.
- Respecter le consentement avant de charger l’outil non essentiel.
- Prévoir une solution d’analytics first-party ou avec minimisation des données.
- Afficher dans le panel la source, la période et la qualité des données.
- Permettre la suppression ou l’anonymisation des événements selon la politique applicable.

### 70. Un seul appel à l’action principal

- Définir une action principale par page publique.
- Utiliser un libellé clair et cohérent, par exemple **Commencer ma préparation**.
- Réduire les boutons concurrents dans le premier écran.
- Conserver les liens secondaires nécessaires : connexion, CGU, confidentialité et aide.
- Mesurer le clic sur l’appel à l’action uniquement avec le consentement requis.
- Tester le libellé et le placement avant d’ajouter d’autres actions.

## Améliorations complémentaires recommandées pour le site public

### 71. Parcours d’accueil et orientation

- Expliquer clairement la différence entre Scolarité, Concours et les quatre parcours GPX/PA.
- Conduire le visiteur vers un choix simple sans multiplier les boutons.
- Conserver le dernier choix authentifié et le rendre modifiable facilement.
- Afficher une progression d’accueil courte et compréhensible.

### 72. Prévisualisation et partage des contenus publics

- Prévoir des aperçus propres pour les pages de cours et articles partagés.
- Vérifier qu’aucun contenu réservé ne devient accessible via une URL publique.
- Ajouter des données structurées uniquement lorsqu’elles correspondent au contenu réel.
- Contrôler les images et métadonnées lors de la publication depuis le panel.

### 73. Centre de confiance

- Rassembler confidentialité, CGU, cookies, sécurité, contact et statut du service.
- Afficher la date des dernières mises à jour et les responsables de publication.
- Ajouter un moyen simple de signaler une vulnérabilité ou un problème de confidentialité.

### 74. Observabilité et statut du service

- Afficher un statut public minimal en cas d’incident majeur.
- Distinguer indisponibilité, dégradation, maintenance et retour à la normale.
- Relier les incidents publics aux journaux internes sans exposer de données sensibles.
- Conserver les post-mortems et actions préventives côté administrateur.

### 75. Tests de compatibilité et de régression web

- Tester les routes publiques, métadonnées, formulaires, consentement et redirections à chaque version.
- Tester les liens depuis les quatre parcours et depuis le mode picker.
- Vérifier les pages en mode connecté et déconnecté.
- Tester les erreurs réseau, les sessions expirées et les réponses lentes.
- Conserver une checklist de validation avant publication.

## Statut de contrôle initial du site public

Les éléments suivants sont déjà présents dans le code et doivent être audités plutôt que recréés : pages confidentialité et CGU, bandeau cookies, sitemap, robots.txt, favicon et métadonnées de la page d’accueil. Les autres exigences de cette section doivent être vérifiées sur l’ensemble des pages publiques, puis validées en production.
