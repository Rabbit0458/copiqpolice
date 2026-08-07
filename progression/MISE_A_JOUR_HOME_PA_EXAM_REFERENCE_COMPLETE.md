# COP’IQ — Référence complète de la Home Concours Policier adjoint

> Document de transmission destiné à une IA ou à un développeur chargé de
> reproduire la Home sur GPX Exam, PA School et GPX School. Il décrit le rendu,
> les données, les interactions et les animations de la page réellement codée.

## 1. Source de vérité

Fichier principal :

- `lib/features/home/home_page_pa_exam.dart`

Services et pages liés :

- `lib/features/home/pa_progression_service.dart`
- `lib/features/home/pa_exam_progress_page.dart`
- `lib/features/home/pa_exam_progress_service.dart`
- `lib/features/home/pa_exam_progress_repository.dart`
- `lib/features/home/pa_exam_progress_models.dart`
- `lib/features/home/pa_exam_progress_calculator.dart`
- `lib/features/home/pa_exam_progress_source_registry.dart`
- `lib/core/services/pa_exam_answer_history_service.dart`
- `lib/features/home/favoris_home.dart`
- `lib/features/home/parametre_home.dart`
- `lib/features/home/profil_page.dart`

Le fichier se nomme PA Exam et le contexte est :

- `UserMode.exam` ;
- `Track.pa` ;
- route `/home-pa-exam`.

## 2. Intentions UX

La Home doit être immédiatement compréhensible, premium et calme. Elle ne doit
pas ressembler à un tableau de bord administratif. La hiérarchie actuelle :

1. salutation personnalisée ;
2. phrase d’engagement ;
3. recherche et réglages ;
4. contexte du concours ;
5. découverte éditoriale ;
6. reprise personnalisée ;
7. navigation principale.

Le premier écran doit conserver de l’espace blanc et ne pas multiplier badges,
statistiques ou appels à l’action concurrents.

## 3. Tokens visuels locaux

La classe privée `_T` centralise :

- encre : `#1C1C1C` ;
- gris 300 : `#E0E0E0` ;
- gris 400 : `#BDBDBD` ;
- gris 500 : `#9E9E9E` ;
- rayons 16, 20 et 24 px ;
- animation rapide 180 ms ;
- animation moyenne 260 ms ;
- ombre : noir à 8 %, flou 16 px, décalage vertical 10 px.

`_muted(context, opacity)` retourne du blanc ou du noir selon la luminosité.
Toutes les surfaces doivent rester compatibles clair/sombre.

## 4. Structure Flutter globale

`HomePagePaExam` est un `StatefulWidget`. Son état utilise désormais
`SingleTickerProviderStateMixin` pour l’animation d’entrée.

État principal :

- `_currentTab` : onglet inférieur courant ;
- `_bucket` : mémorisation du scroll et des états enfants ;
- `_username` et `_isLoadingUsername` ;
- `_mode=exam`, `_track=pa` ;
- `_cats` : catégories PA Exam ;
- `_initialDeckIndex` ;
- `_entryController` ;
- `_entryStarted`.

La page d’accueil est contenue dans un `PageStorage`, puis une `ListView` avec
`BouncingScrollPhysics`. La barre inférieure conserve cinq destinations :

1. accueil ;
2. suivi/progression ;
3. forum ;
4. favoris ;
5. profil.

## 5. Salutation

### Chargement du prénom

`HomePagePaExam.usernameLoader` est injecté au démarrage. Le texte :

- pendant le chargement : `Bonjour 👋` ;
- avec prénom : `Bonjour <prénom>` ;
- en repli : `Bonjour 👋`.

Le titre :

- une ligne maximum ;
- ellipsis ;
- Poppins ;
- taille 22 px ;
- graisse 900.

La phrase secondaire est désormais :

> Prêt à préparer ton concours ?

Elle utilise `bodySmall`, couleur atténuée à 70 % et graisse 600.

À droite, un bouton circulaire avec `school_rounded` ouvre
`ModePickerScreen`. Cette action permet de changer le contexte de formation.

Padding horizontal du header : 20 px. Espace supérieur après la Safe Area :
14 px. Espace sous le header : 12 px.

## 6. Recherche et réglages

La ligne possède un padding horizontal de 20 px.

### Recherche

- hauteur 44 px ;
- surface `theme.cardColor` ;
- rayon 14 px ;
- ombre `_T.shadow` ;
- padding horizontal 12 px ;
- icône recherche 20 px ;
- espace icône/texte 8 px ;
- texte indicatif : `Rechercher un cours, un quiz…` ;
- bordure de champ masquée.

### Réglages

Un espace de 10 px sépare la recherche du bouton `_IconCircle`. Le bouton ouvre
`ParametreHomePage`.

L’intitulé de recherche doit rester identique lors de la réplication. Seul le
contenu recherché varie selon le module.

## 7. Contexte et microcopy

Le grand titre `Concours — Policier Adjoint` et la pastille
`Parcours actif · Policier adjoint` ont été abandonnés. Le rendu actuel est un
texte discret :

> Concours Policier adjoint

Style : `titleMedium`, `onSurfaceVariant`, graisse 700. Padding horizontal
20 px. Espace supérieur depuis la recherche : 22 px. Espace inférieur : 8 px.

Le titre éditorial est :

> À découvrir

Style : `titleMedium`, graisse 800. L’ancien texte « Sélection de contenu » ne
doit pas être réintroduit.

Autres microcopies actuelles :

- `Tout voir` → `Voir mon parcours` ;
- badge `Vue d’ensemble` → `Bien démarrer` ;
- la section personnalisée reste `Continue ta préparation`.

## 8. Carrousel héro

Le widget `_HeroDeck` reçoit :

- clé `PageStorageKey('pa-hero-deck')` ;
- hauteur 330 px ;
- items issus de `categoriesConfigPA[exam][pa]` ;
- index de départ calculé ;
- padding de page horizontal 20 px.

Chaque `_DeckItem` contient :

- label ;
- badge ;
- chemin image ;
- note actuelle 4,9 ;
- nombre de notes 120 ;
- route ;
- sous-catégories.

La première carte configurée représente les épreuves du concours :

- label `Les épreuves du concours PA` ;
- badge `Bien démarrer` ;
- image `assets/images/concours_pa_epreuves.jpeg` ;
- route `/pa_exam/concours/epreuves`.

Le carrousel comprend favoris, contenu en surimpression, CTA et navigation vers
route ou détail. Le bouton principal et le cœur doivent garder une cible
tactile d’au moins 44 px.

L’état du deck est mémorisé par `PageStorage`. Revenir sur l’onglet ne doit pas
ramener arbitrairement l’utilisateur à la première carte.

## 9. Reprise personnalisée

La section `_ContinuePreparationSection` se trouve 26 px sous le carrousel,
avec padding horizontal 20 px.

En-tête :

- `Continue ta préparation` ;
- `titleMedium` forcé à 16 px ;
- graisse 800 ;
- action `Voir mon parcours`, graisse 700, couleur atténuée 70 % ;
- espace inférieur 12 px.

Elle charge un `PaProgressSnapshot` via `PaProgressionService` :

- chargement → `_ResumeSkeleton` ;
- activité existante → `_ResumeCard` ;
- aucun historique → `_StartCard`.

La reprise résout la catégorie la plus pertinente par mots-clés :

- photolangage ;
- psychotechnique/logique/aptitude/raisonnement ;
- culture générale/institutions/histoire/sciences/droit/police/sport ;
- épreuves/médical/tableau.

En l’absence de correspondance, la première catégorie est utilisée.

Les cartes de statistiques sous la reprise affichent notamment série et
objectif du jour. Elles ne doivent pas apparaître pendant le chargement.

## 10. Animation d’entrée complète

### Contrôleur

`_entryController` :

- `AnimationController` ;
- `vsync: this` ;
- durée totale 760 ms ;
- créé dans `initState` ;
- libéré dans `dispose`.

Le lancement est effectué une fois dans `didChangeDependencies`, après le
premier frame. `_entryStarted` empêche les relances lors d’un changement de
dépendance ou d’un rebuild.

### Réduction des mouvements

Avant toute animation, vérifier :

```dart
MediaQuery.disableAnimationsOf(context)
```

Si vrai, régler immédiatement le contrôleur à 1. `_entrance` retourne aussi
directement l’enfant. Ne jamais contourner cette protection.

### Primitive `_entrance`

Chaque groupe utilise :

- `CurvedAnimation` ;
- `Interval(begin, end, curve: Curves.easeOutCubic)` ;
- `FadeTransition` ;
- `SlideTransition` ;
- position initiale `Offset(0, 0.045)` ;
- position finale `Offset.zero`.

Seules opacité et transformation sont animées. Ne pas animer hauteur, largeur,
padding ou top afin d’éviter les recalculs de layout et les sauts.

### Chronologie exacte

| Groupe | Début normalisé | Fin normalisée | Temps approximatif |
|---|---:|---:|---:|
| Salutation | 0,00 | 0,34 | 0–258 ms |
| Recherche/réglages | 0,08 | 0,44 | 61–334 ms |
| Contexte concours | 0,18 | 0,54 | 137–410 ms |
| « À découvrir » | 0,24 | 0,60 | 182–456 ms |
| Carrousel | 0,32 | 0,78 | 243–593 ms |
| Reprise | 0,48 | 1,00 | 365–760 ms |

L’effet recherché est une arrivée calme par vagues, pas une cascade lente. Les
éléments deviennent interactifs immédiatement. Aucune animation infinie,
rebondissante ou sonore.

### Règles de réplication

- conserver une durée totale comprise entre 700 et 800 ms ;
- conserver le déplacement vertical sous 5 % de la hauteur de l’élément ;
- utiliser `easeOutCubic` pour l’entrée ;
- ne pas rejouer l’animation à chaque changement d’onglet ;
- ne pas animer la barre de navigation ;
- ne pas animer les skeletons avec le même contrôleur ;
- tester « Réduire les animations » sur iOS et Android ;
- ne pas démarrer avant le premier frame.

## 11. Navigation et haptique

`_goToTab` appelle `HapticFeedback.selectionClick()` puis change
`_currentTab`. Les routes de contenu utilisent `_openRouteOrDetails` :

1. application d’un alias éventuel dans `redirectConfigPA` ;
2. ouverture directe si la route appartient à `directOpenRoutesPA` ;
3. ouverture d’une page de sous-catégories si nécessaire ;
4. sinon `pushNamed`.

Les hubs ouverts directement actuellement :

- tests psychotechniques ;
- connaissances générales ;
- photolangage.

## 12. Progression PA Exam

La Home ne doit pas agréger elle-même les résultats. Les services dédiés
interrogent les sources déclarées dans le registre puis produisent des modèles
normalisés.

Points essentiels :

- utiliser l’utilisateur authentifié ;
- ne pas confondre PA/GPX ou Exam/School ;
- dédupliquer les tentatives ;
- conserver dates, scores, précision, activité et module ;
- gérer les tables historiques existantes ;
- afficher des états vides honnêtes ;
- ne pas inventer de score lorsqu’une source est absente.

La page de progression complète est accessible depuis le deuxième onglet et
depuis `Voir mon parcours`.

## 13. Favoris, forum et profil

- quatrième onglet : favoris ;
- troisième onglet : `CommunityPage(initialScope: CommunityScope.paExam)` ;
- cinquième onglet : profil.

Lors de la réplication :

- GPX Exam → `CommunityScope.gpxExam` ;
- PA School → `CommunityScope.paSchool` ;
- GPX School → `CommunityScope.gpxSchool`.

## 14. Adaptation aux autres Home

Ne copier que les intentions et composants manquants. Ne remplacer aucune
logique métier spécifique.

### GPX Exam

- `UserMode.exam`, `Track.gpx` ;
- intitulé `Concours Gardien de la paix` ;
- catégories GPX Exam ;
- progression GPX Exam ;
- forum `gpxExam`.

### PA School

- `UserMode.school`, `Track.pa` ;
- intitulé `École Policier adjoint` ;
- contenus de scolarité ;
- progression scolaire PA ;
- forum `paSchool`.

### GPX School

- `UserMode.school`, `Track.gpx` ;
- intitulé `École Gardien de la paix` ;
- contenus de scolarité ;
- progression scolaire GPX ;
- forum `gpxSchool`.

Pour chaque version, conserver : salutation, recherche 44 px, padding horizontal
20 px, hiérarchie typographique, carrousel 330 px si le contenu le permet,
reprise personnalisée, barre cinq onglets et animation échelonnée accessible.

## 15. Responsive et accessibilité

- utiliser `SafeArea` au niveau approprié ;
- ne pas coder une largeur d’écran fixe ;
- padding principal 20 px ;
- cibles tactiles 44 × 44 px minimum ;
- ellipsis sur nom et titres longs ;
- contraste texte normal 4,5:1 ;
- `Semantics` et tooltips pour icônes seules ;
- support texte agrandi ;
- thème clair/sombre ;
- support réduction des mouvements ;
- aucune animation continue décorative ;
- aucun emoji utilisé comme icône d’action. L’emoji de salutation est un texte
  décoratif et possède un repli.

## 16. Performance

- conserver `PageStorageBucket` ;
- ne pas reconstruire des listes de données coûteuses dans une animation ;
- ne pas lancer une requête par carte ;
- réserver la hauteur du carrousel pour éviter un saut ;
- charger les données de progression de manière asynchrone avec skeleton ;
- utiliser opacité/transform pour le mouvement ;
- libérer tous les contrôleurs ;
- ne pas rejouer l’entrée après chaque `setState` du username.

## 17. Tests obligatoires avant harmonisation

1. prénom long et prénom absent ;
2. thème clair et sombre ;
3. écran compact et iPhone Pro Max ;
4. facteur de texte augmenté ;
5. réduction des animations activée ;
6. animation jouée une seule fois ;
7. changement d’onglet et retour sans perte de scroll ;
8. carrousel conservant son index ;
9. compte sans activité ;
10. compte avec activité ;
11. reprise ouvrant la bonne catégorie ;
12. favoris ;
13. forum dans la bonne portée ;
14. recherche et réglages ;
15. `flutter analyze` sans erreur ;
16. absence d’overflow à 320/375/430 px.

## 18. Interdictions

- ne pas réintroduire `Parcours actif` ;
- ne pas réintroduire une grosse pastille de contexte ;
- ne pas remplacer `À découvrir` par `Sélection de contenu` ;
- ne pas forcer l’animation lorsque le système la réduit ;
- ne pas animer chaque carte interne séparément ;
- ne pas utiliser des durées supérieures à une seconde ;
- ne pas perdre l’état du carrousel au rebuild ;
- ne pas mélanger les données des quatre parcours ;
- ne pas masquer une erreur de progression par une valeur inventée.

## 19. Définition de « terminé »

Une Home harmonisée est terminée lorsqu’elle conserve sa logique métier propre,
reprend la hiérarchie et les microcopies adaptées, utilise les mêmes espacements
et mouvements, respecte le réglage système de mouvement, garde son état pendant
la navigation et passe l’analyse Flutter sans erreur ni overflow.
