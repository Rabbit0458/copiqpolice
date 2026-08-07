# COP’IQ — Référence complète du forum Flutter et Supabase

> Document de transmission destiné à une IA ou à un développeur chargé de
> reproduire, maintenir ou harmoniser le forum sur les quatre niveaux COP’IQ.
> Il décrit l’état réellement implémenté au 2 août 2026. Il ne remplace pas la
> lecture du code : les fichiers cités restent la source de vérité.

## 1. Objectif et règle fondamentale

COP’IQ possède un forum communautaire unique, partagé entre quatre parcours :

| Parcours | Identifiant Supabase | Libellé utilisateur |
|---|---|---|
| Concours Policier adjoint | `pa_exam` | Concours Policier adjoint |
| Concours Gardien de la paix | `gpx_exam` | Concours Gardien de la paix |
| École Policier adjoint | `pa_school` | École Policier adjoint |
| École Gardien de la paix | `gpx_school` | École Gardien de la paix |

Un cinquième espace logique, `global`, représente « Tout le monde ».

Le forum n’est pas dupliqué quatre fois. Une seule architecture Flutter et une
seule base Supabase sont utilisées. Le contexte d’entrée fournit une
`CommunityScope`. L’utilisateur peut consulter tous les espaces, mais il ne peut
publier, répondre ou réagir que dans son module actif, déterminé par
`user_profiles.user_mode` et `user_profiles.user_track`.

Cette séparation doit être conservée côté PostgreSQL. Masquer un bouton dans
Flutter ne constitue jamais une autorisation suffisante.

## 2. Sources de vérité à lire avant toute modification

### Flutter

- `lib/features/forum/community_models.dart`
- `lib/features/forum/community_repository.dart`
- `lib/features/forum/community_page.dart`
- `lib/features/forum/community_discovery_pages.dart`
- `lib/features/forum/community_messaging_page.dart`
- `lib/features/forum/community_feedback.dart`
- `lib/features/forum/community_notification_service.dart`
- `lib/routes/app_router.dart`
- `lib/features/home/parametre_home.dart`

### Tests

- `test/features/forum/community_models_test.dart`

### Supabase

Lire les migrations dans l’ordre chronologique, notamment :

1. `20260801033115_global_forum_foundation.sql`
2. `20260801201909_global_forum_grants_hardening.sql`
3. `20260801203226_global_forum_runtime_logic.sql`
4. `20260801203609_global_forum_realtime.sql`
5. `20260801204201_fix_community_notification_triggers.sql`
6. `20260801204720_community_profiles_search_shares.sql`
7. `20260801233000_community_human_friendly_space_labels.sql`
8. `20260802010000_community_public_identity.sql`
9. `20260802014500_community_owner_profile_visibility.sql`
10. `20260802021500_community_publish_current_module_only.sql`
11. `20260802030000_community_private_message_safety.sql`
12. `20260802030601_fix_public_community_profile_counts.sql`
13. `20260802031637_community_messaging_identity_notifications.sql`
14. `20260802033948_community_notification_user_delete.sql`
15. `20260802034742_community_threaded_comment_replies.sql`
16. `20260802035030_fix_threaded_comment_parent_validation.sql`
17. `20260802035842_community_comment_reply_counts.sql`
18. `20260802041500_community_comment_interactions.sql`
19. `20260802042500_community_interaction_indexes.sql`

Ne jamais modifier une migration déjà appliquée pour corriger la production.
Créer une migration additive et idempotente.

## 3. Modèle Flutter

### `CommunityScope`

L’énumération contient `global`, `paExam`, `gpxExam`, `paSchool` et
`gpxSchool`. Chaque portée expose :

- l’identifiant PostgreSQL ;
- le libellé complet ;
- un libellé court ;
- une couleur ;
- une icône Material.

Tous les écrans doivent dériver leur accent visuel de la portée. Ne pas coder
une couleur PA en dur dans une page GPX.

### `CommunityPost`

Le modèle conserve notamment : identifiant, auteur, portée, catégorie, titre,
contenu, date, compteurs, épinglage, résolution, réaction de l’utilisateur et
favori de l’utilisateur. L’identité publique enrichie comprend :

- nom affiché ;
- `@username` ;
- index d’avatar ;
- type de badge vérifié.

Email, téléphone, ville, anniversaire ou métadonnée Auth privée ne doivent
jamais entrer dans ce modèle.

### `CommunityComment`

Champs fonctionnels actuels :

- `id` ;
- `authorId` ;
- `content` ;
- `createdAt` ;
- `parentId` ;
- `replyCount` ;
- `reactionCount` ;
- `liked` ;
- `isSolution` ;
- `status` ;
- `editedAt` ;
- identité publique enrichie.

`replyCount` représente les enfants directs, pas toute la descendance.

### Notifications

`CommunityNotification` conserve la cible, le type, la portée, l’acteur public,
la lecture et `commentId` extrait de `payload.comment_id`. Ce dernier permet de
révéler précisément une réponse dans un fil paginé.

## 4. Architecture du dépôt de données

`CommunityRepository` est la seule couche Flutter autorisée à parler aux tables
et RPC du forum. Une page ne doit pas construire une requête Supabase complexe
directement.

Responsabilités principales :

- résoudre le module actif ;
- charger et enrichir publications/commentaires/profils ;
- rechercher publications et membres ;
- publier et répondre ;
- gérer réactions et favoris ;
- gérer abonnements de discussions ;
- créer et charger conversations privées ;
- signaler, bloquer et quitter ;
- charger et supprimer les notifications personnelles ;
- gérer les préférences de notification ;
- ouvrir les flux Realtime ;
- appeler les RPC atomiques.

Les identités publiques sont chargées par lot via
`community_public_identities`. Ne jamais provoquer une requête de profil par
carte dans une liste.

## 5. Fil communautaire principal

### En-tête

L’AppBar contient :

- titre « Communauté » ;
- recherche ;
- notifications avec badge non lu ;
- messages ;
- profil communautaire ;
- publications enregistrées.

Toutes les icônes seules possèdent un `tooltip`. La cible tactile minimale est
44 × 44 px.

### Sélecteur d’espace

Le module actif est sélectionné automatiquement. Un bouton compact ouvre une
feuille de choix listant les cinq espaces. Chaque ligne contient icône, libellé
et état :

- « Module actif · participation autorisée » ;
- « Consultation uniquement ».

Dans un autre module, le fil est lisible mais la création, la réponse et les
réactions sont désactivées. Une information explicite invite à basculer le
module réel plutôt qu’à contourner la règle.

### Cartes de publication

La carte utilise :

- rayon de 20 px ;
- bordure `outlineVariant` ;
- élévation nulle ;
- padding interne de 16 px ;
- avatar public de 38 px ;
- nom, badge, username et date ;
- badge de portée et catégorie ;
- titre puis extrait ;
- actions réaction, commentaire et favori ;
- bouton `more_horiz` pour gérer.

Le nom et la photo ouvrent le profil communautaire. L’image d’avatar remplit le
cercle : ne pas réintroduire de large anneau blanc.

### Création d’une publication

Le module de publication est verrouillé sur le module actif. L’utilisateur ne
choisit que le sujet. La page utilise :

- champs arrondis de 16 à 18 px ;
- titre limité à 120 caractères, minimum 10 ;
- contenu limité à 10 000 caractères, minimum 20 ;
- sauvegarde de brouillon locale ;
- bouton principal de 54 px de haut ;
- état de chargement empêchant le double envoi ;
- message de sécurité sur les données personnelles.

Le succès utilise une notification flottante premium : fond vert très sombre,
icône de validation, destination, bouton « Voir », durée cinq secondes et
fermeture horizontale.

## 6. Page détaillée d’une publication

### En-tête de la publication

La page présente :

- retour ;
- titre d’espace tronqué proprement ;
- abonnement à la discussion ;
- partage ;
- menu de gestion ;
- auteur public cliquable ;
- badges portée/catégorie ;
- titre et contenu ;
- réactions avec avatars des personnes ;
- favori et partage.

### Composer une réponse

Le composer reste fixé en bas, dans une surface avec élévation douce :

- champ arrondi ;
- bouton circulaire d’envoi ;
- état « Réponse à @username » avec fermeture ;
- brouillon automatique par publication dans `SharedPreferences` ;
- insertion automatique de `@username` lorsqu’on répond ;
- cooldown local de quatre secondes ;
- protections PostgreSQL supplémentaires.

En lecture seule, le composer est remplacé par une barre expliquant le module à
activer.

## 7. Commentaires imbriqués à grande échelle

### Pagination

- 20 commentaires racines au premier chargement ;
- 10 enfants directs par chargement ;
- bouton « Voir N réponses supplémentaires » ;
- bouton « Masquer les réponses » ;
- pas de chargement récursif complet ;
- conservation de la position pendant les ajouts de page.

La profondeur de données est réelle et illimitée par le modèle, mais le décalage
visuel est plafonné à deux niveaux pour préserver la largeur mobile.

### Tri

Le menu propose :

- plus pertinents : solution, réactions, récence ;
- plus récents ;
- plus anciens ;
- solutions uniquement.

Le tri et la pagination se font côté PostgreSQL.

### Réponse ciblée

Chaque commentaire publié possède un bouton « Répondre ». La nouvelle ligne
reçoit `parent_id`. Le déclencheur valide que le parent appartient à la même
publication et met à jour le compteur direct.

Le menu propose « Voir le commentaire parent ». Le code utilise les
`GlobalKey` des commentaires visibles et `Scrollable.ensureVisible` avec une
durée de 350 ms et `easeOutCubic`.

### Nouvelle activité Realtime

La page souscrit aux insertions de `community_comments` filtrées par `post_id`.
Elle ne réordonne jamais brutalement le contenu. Elle affiche un bouton :

> N nouvelles réponses

L’utilisateur décide quand actualiser.

### Navigation ciblée depuis une notification

La route `/forum/<postId>` accepte `settings.arguments.commentId`. La page :

1. charge le commentaire cible ;
2. remonte les parents, au maximum douze éléments de sécurité ;
3. injecte la chaîne manquante dans les pages visibles ;
4. déplie les branches ;
5. fait défiler doucement vers le commentaire.

Un contenu retiré ne doit pas révéler son ancien texte.

## 8. Design exact des commentaires

### Carte

- avatar racine : 40 px ;
- avatar imbriqué : 34 px ;
- espace avatar/carte : 10 px ;
- indentation : 22 px par niveau, plafonnée à deux ;
- padding carte : gauche/droite 14 px, haut 11 px, bas 12 px ;
- rayon supérieur gauche 5 px ;
- autres rayons 19 px ;
- bordure `outlineVariant` ;
- contenu avec hauteur de ligne 1,45 ;
- huit lignes maximum avant « Lire la suite » ;
- réduction proposée au-delà de 280 caractères.

Une solution reçoit une teinte verte à 8 %, une bordure verte à 60 % et le
badge « Solution choisie » avec icône.

Les mentions `@username` sont colorées avec l’accent de portée, en graisse 800.
Toucher un commentaire contenant une mention ouvre le profil exact après
recherche publique.

### Ligne d’actions

- « J’aime » avec cœur plein ou contour ;
- compteur réel ;
- « Répondre » avec icône reply ;
- actions désactivées en lecture seule.

### Menu d’actions premium

Le `PopupMenuButton` système a été retiré. Le bouton `more_horiz` de 44 × 44 px
ouvre une feuille modale :

- fond transparent autour de la feuille ;
- marge sûre 10 px sur les côtés et en bas ;
- surface arrondie de 28 px ;
- bordure `outlineVariant` ;
- poignée 36 × 4 px ;
- padding extérieur 16 px ;
- en-tête avec avatar 38 px, titre, username et bouton fermer ;
- groupe d’actions dans `surfaceContainerHighest` à 46 % ;
- groupe arrondi de 20 px ;
- ligne de 54 px minimum ;
- conteneur d’icône 36 × 36 px, rayon 12 px ;
- séparateur indenté de 58 px ;
- chevron de 19 px ;
- libellés en graisse 700 ;
- actions destructrices en couleur `error` et `errorContainer` ;
- solution en vert `#169B62` ;
- `Semantics(button: true)` et libellé accessible.

Actions conditionnelles : parent, liste des J’aime, copier, modifier, supprimer,
choisir comme solution, signaler et bloquer.

## 9. Gestion fonctionnelle des commentaires

### Réactions

`toggleCommentLike` insère ou supprime une ligne `community_reactions` avec
`comment_id` et `kind='like'`. Le compteur est synchronisé par trigger. La liste
des personnes est limitée et enrichie avec les identités publiques.

### Modification

Seul l’auteur peut modifier. `edited_at` est renseigné et « Modifié » apparaît.
Le dialogue limite le contenu à 3 000 caractères.

### Suppression logique

La suppression remplace le contenu et passe le statut à
`deleted_by_author`. Les réponses restent attachées afin de préserver le fil.
La carte affiche un texte neutre. Ne jamais supprimer physiquement.

### Modération

États rendus :

- `published` ;
- `pending_review` ;
- `hidden` ;
- `removed_by_moderator` ;
- `deleted_by_author`.

Les états non publiés affichent une icône de bouclier et un message neutre.

### Solution

Seul l’auteur de la publication peut appeler `community_set_solution`. La RPC :

- vérifie `auth.uid()` ;
- vérifie la propriété du post ;
- vérifie que le commentaire publié appartient au post ;
- garantit une seule solution ;
- met à jour `solution_comment_id` et `is_resolved` atomiquement.

### Signalement et blocage

Un commentaire tiers peut être signalé via `community_reports`. Le blocage est
enregistré dans `community_blocks` et le contenu concerné disparaît selon les
politiques établies.

## 10. Anti-spam et performance

Le trigger `community_guard_comment_rate` bloque :

- un texte identique du même auteur sur la même publication dans les 60 s ;
- cinq commentaires ou plus du même auteur dans une fenêtre de 60 s.

Flutter ajoute un cooldown de confort, mais PostgreSQL reste l’autorité.

Index dédiés :

- pertinence des commentaires par post et parent ;
- `parent_id` ;
- utilisateurs bloqués ;
- favoris par publication.

Le forum ne doit jamais charger 1 000 réponses dans un seul appel.

## 11. Profils communautaires

Le profil public utilise exclusivement les RPC publiques sécurisées. Il affiche :

- avatar complet ;
- nom/prénom selon la préférence ;
- username ;
- badge ;
- espace ;
- bio/rôle public ;
- nombre de publications, réponses et solutions ;
- date d’arrivée si autorisée ;
- bouton message pour un autre membre ;
- bouton modifier pour soi.

Les compteurs doivent être calculés pour l’utilisateur consulté, jamais pour
l’utilisateur connecté.

## 12. Recherche

La page utilise un champ premium et un sélecteur d’espace compact. Recherche :

- publications plein texte en français ;
- membres ;
- minimum deux caractères ;
- requêtes temporisées ;
- résultats paginés ;
- aucune donnée privée.

## 13. Messagerie privée et sécurité

La liste des conversations affiche l’identité publique du correspondant : nom,
username et avatar, aperçu du dernier message, heure et non-lus.

Les administrateurs ne disposent d’aucune porte dérobée vers les conversations.
Seul un message signalé génère un instantané de sept messages maximum. L’accès
administratif passe par une RPC, requiert une justification et est audité.

L’utilisateur peut : signaler un message, bloquer, quitter, couper les
notifications de messagerie et couper toutes les notifications.

## 14. Centre de notifications

Fonctions :

- affichage identité publique complète ;
- types publication, réponse, réaction, commentaire, message ;
- état lu/non lu ;
- marquer tout comme lu ;
- appui long pour entrer en sélection multiple ;
- suppression d’une ou plusieurs lignes ;
- navigation vers publication/commentaire/conversation ;
- réception Realtime ;
- préférences globales, forum et messages.

Types actuels : `post_reply`, `comment_reply`, `followed_post_reply`,
`reaction`, `comment_reaction`, `message`.

## 15. Publications enregistrées

Le favori est un basculement réel : toucher le marque-page depuis la page des
enregistrements appelle une suppression serveur puis retire la carte localement.
En cas d’échec, la liste est rechargée. Ne pas créer un bouton visuellement actif
qui ne désenregistre pas.

## 16. Accessibilité et mouvement

- cibles tactiles de 44 px minimum ;
- tooltips sur icônes seules ;
- `Semantics` pour actions importantes ;
- contraste minimum 4,5:1 ;
- tailles issues du thème lorsque possible ;
- pas d’emoji comme icône fonctionnelle ;
- animations de 150 à 420 ms avec courbes non linéaires ;
- aucun scroll-jacking ;
- états chargement, vide et erreur explicites ;
- thème clair et sombre.

## 17. Procédure de réplication aux quatre niveaux

Ne copier aucun fichier de page. Pour chaque Home :

1. importer `CommunityScope` et `CommunityPage` ;
2. ouvrir `CommunityPage(initialScope: portéeDuParcours)` ;
3. vérifier le mapping `activeScope()` :
   - exam + pa → `paExam` ;
   - exam + gpx → `gpxExam` ;
   - school + pa → `paSchool` ;
   - school + gpx → `gpxSchool` ;
4. vérifier les catégories actives de la portée ;
5. conserver les mêmes composants, espacements et actions ;
6. ne varier que couleur, libellés, icône et catégories ;
7. tester lecture croisée et écriture interdite hors module ;
8. tester profil, recherche, message, notification et deep link dans chaque
   portée.

## 18. Tests de non-régression obligatoires

- parsing des cinq portées ;
- parent et compteur direct ;
- réaction et état aimé ;
- solution et date de modification ;
- payload de navigation d’une notification ;
- publication interdite hors module ;
- parent appartenant à une autre publication refusé ;
- anti-spam doublon et rafale ;
- compteurs de profil tiers ;
- désenregistrement d’un favori ;
- suppression multiple de notifications ;
- RLS anonyme ;
- messages privés non signalés inaccessibles ;
- `flutter analyze` sans erreur ;
- tests Flutter ciblés ;
- tests transactionnels Supabase avec rollback.

## 19. Interdictions absolues

- ne jamais utiliser `service_role` dans Flutter ou un build web statique ;
- ne jamais autoriser uniquement via l’interface ;
- ne jamais afficher une conversation privée non signalée à un administrateur ;
- ne jamais supprimer physiquement un commentaire avec des enfants ;
- ne jamais exposer email/téléphone dans un profil communautaire ;
- ne jamais charger tous les descendants d’un fil ;
- ne jamais dupliquer le forum par niveau ;
- ne jamais envoyer silencieusement au serveur le contenu complet d’un message
  rejeté par l’anti-spam ;
- ne jamais modifier une migration de production déjà appliquée.

## 20. Critères de finition

La réplication est terminée lorsque les quatre parcours utilisent la même base
de composants, que les différences visuelles viennent uniquement de
`CommunityScope`, que toutes les mutations sont protégées en base, que les fils
restent utilisables avec 1 000 réponses, que les notifications ouvrent la bonne
cible et que Flutter/Supabase passent leurs validations sans erreur.
