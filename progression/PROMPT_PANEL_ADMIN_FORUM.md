# Prompt d’implémentation — Modération du forum COP’IQ dans le panel web

Tu travailles sur le panneau administrateur web de COP’IQ. Le code source est le projet Next.js `copiq-web`; le dossier `fae16dc1` est un export compilé et ne doit jamais être modifié à la main. Après validation, le propriétaire exportera et déposera le build chez son hébergeur.

## Mission

Créer dans `/admin/forum` un centre de gestion et de modération complet pour la communauté globale COP’IQ. Le forum réunit cinq portées Supabase : `global`, `pa_exam`, `gpx_exam`, `pa_school` et `gpx_school`.

Le panel doit administrer les tables `community_*` créées par la migration Flutter/Supabase `global_forum_foundation`. Il doit exclusivement utiliser le client Supabase déjà présent, les composants de `src/components/admin`, `AdminGate`, la MFA existante et des RPC protégées. Ne jamais placer de clé `service_role` ou de secret dans le JavaScript exporté.

## Audit préalable obligatoire

1. Lire `src/app/admin`, `src/components/admin`, `src/lib/admin/api.ts` et le middleware.
2. Lire les migrations forum du projet Flutter, notamment :
   - `20260801033115_global_forum_foundation.sql` ;
   - `20260802034742_community_threaded_comment_replies.sql` ;
   - `20260802035842_community_comment_reply_counts.sql` ;
   - `20260802041500_community_comment_interactions.sql` ;
   - `20260802042500_community_interaction_indexes.sql`.
3. Vérifier dans la base les signatures réelles des RPC `community_admin_dashboard`, `community_moderate_post` et `community_resolve_report`.
4. Vérifier les colonnes et politiques RLS de chaque table `community_*`.
5. Conserver l’architecture, les variables CSS, la navigation, les états de chargement et les conventions du panel existant.

## Navigation attendue

Ajouter sous « Communauté » :

- Vue d’ensemble
- Publications
- Commentaires
- Signalements
- Utilisateurs et sanctions
- Catégories et espaces
- Modérateurs
- Annonces
- Journal d’audit

La navigation doit fonctionner avec l’export statique actuel. Ne pas créer de route serveur incompatible avec l’hébergement.

## Couche d’accès aux données

Étendre `src/lib/admin/api.ts` avec des types stricts et une API `communityAdminApi`. Toutes les mutations sensibles doivent appeler une RPC sécurisée, jamais un `update` direct depuis le navigateur. Si une RPC manque, la créer dans une nouvelle migration Supabase avec :

- contrôle de `auth.uid()` ;
- contrôle du rôle et de la portée dans `community_moderator_scopes` ;
- `SECURITY DEFINER` uniquement si nécessaire ;
- `search_path=''` ;
- révocation de `PUBLIC` et `anon` ;
- paramètres validés ;
- transaction atomique ;
- écriture dans `community_moderation_log`.

## Vue d’ensemble

Afficher des cartes : publications du jour, commentaires du jour, signalements ouverts, sanctions actives. Ajouter une répartition par espace et une période 24 h, 7 jours, 30 jours. Utiliser `community_admin_dashboard` puis créer une RPC agrégée supplémentaire si nécessaire. Ne jamais télécharger toutes les lignes pour compter côté navigateur.

## Publications

Créer une table paginée côté serveur avec filtres : portée, catégorie, statut, auteur, période, épinglé, verrouillé, résolu et signalé. Afficher le badge coloré de l’espace, le titre, l’auteur public, la date, les compteurs et le statut.

Le détail affiche le contenu complet et ses commentaires. Actions : masquer, restaurer, verrouiller, déverrouiller, épingler, désépingler et retirer. Demander un motif obligatoire et une confirmation. Appeler `community_moderate_post`. Mettre à jour la ligne après succès et afficher une notification claire.

Afficher également `is_resolved` et `solution_comment_id`. Depuis le détail,
l’administrateur peut ouvrir directement la solution choisie, voir qui l’a
choisie et quand. La solution appartient fonctionnellement à l’auteur de la
publication : un modérateur ne doit la changer qu’en cas d’abus manifeste, via
une RPC spécifique, un motif obligatoire et une trace d’audit. Ne jamais
modifier directement `solution_comment_id` depuis le navigateur.

## Commentaires et discussions imbriquées

Créer une page `/admin/forum/comments` et intégrer les commentaires au détail
d’une publication sous forme d’arbre paginé. Le modèle réel utilise
`parent_id`, `reply_count`, `reaction_count`, `is_solution`, `edited_at` et
`status`. Une discussion peut contenir plusieurs centaines ou milliers de
réponses : ne jamais charger récursivement tout l’arbre.

Fonctionnement obligatoire :

- pagination serveur des commentaires racines, 20 par page ;
- chargement à la demande des enfants directs, 10 à 20 par page ;
- profondeur visuelle plafonnée à deux niveaux, sans perdre la relation réelle ;
- bouton « Voir le parent » et fil d’Ariane vers la publication ;
- tris `relevant`, `recent` et `oldest` ;
- filtre « solutions uniquement » ;
- recherche par identifiant, auteur ou extrait public ;
- filtres par espace, publication, statut, période, solution et signalement ;
- compteur provenant de la base, jamais recalculé à partir de la page chargée.

Le tri pertinent place d’abord les solutions, puis les réactions et la date.
Utiliser les index créés par `community_comment_interactions` et
`community_interaction_indexes`. Éviter toute requête N+1 pour les identités
publiques : charger les profils par lot ou utiliser une RPC/vue sécurisée.

### États et actions de modération d’un commentaire

Afficher clairement les états :

- `published` : contenu public ;
- `pending_review` : contenu en attente de vérification ;
- `hidden` : masqué temporairement ;
- `removed_by_moderator` : retiré par la modération ;
- `deleted_by_author` : supprimé par son auteur, avec fil conservé.

Un contenu non publié ne doit pas être présenté comme encore public. Dans
l’arbre, conserver un emplacement neutre (« Commentaire retiré par la
modération » ou « supprimé par son auteur ») lorsque des enfants existent, afin
de ne pas casser la conversation.

Actions selon le rôle : ouvrir la publication, ouvrir le parent, masquer,
restaurer, placer en vérification, retirer, verrouiller la branche si cette
fonction est ajoutée, consulter les signalements, avertir l’auteur et préparer
une sanction. La suppression physique est interdite. Chaque action exige un
motif, utilise une RPC contrôlée par portée et ajoute une ligne à
`community_moderation_log` avec état avant/après.

Créer si nécessaire une RPC `community_moderate_comment` recevant au minimum :
`p_comment_id`, `p_action`, `p_reason` et une note interne facultative. Elle doit
valider les transitions de statut, empêcher les actions hors portée et
préserver `parent_id`, les réponses et l’historique.

### Réactions et solutions

Les réactions aux publications et commentaires résident dans
`community_reactions`. Le panel peut afficher le nombre de réactions et la
liste paginée des identités publiques, mais ne doit pas exposer de donnée privée.
Un administrateur ne peut pas créer ou retirer arbitrairement un « J’aime » au
nom d’un membre. En cas d’abus automatisé, prévoir une action de nettoyage
exceptionnelle, limitée au rôle `owner`, motivée et auditée.

La fonction applicative `community_set_solution(post_id, comment_id)` est
réservée à l’auteur de la publication. Le panel doit distinguer une solution
utilisateur d’une correction administrative. Toute correction administrative
doit passer par une RPC différente et conserver l’ancienne valeur dans le
journal.

### Anti-spam et activité temps réel

La base bloque actuellement les doublons identiques rapprochés et les rafales de
commentaires via `community_guard_comment_rate`. Ajouter au tableau de bord des
indicateurs agrégés : tentatives bloquées, auteurs concernés, publications
ciblées et évolution temporelle, uniquement si ces événements sont stockés de
façon sobre dans une table ou un journal serveur dédié. Ne jamais parser les
logs bruts côté navigateur ni stocker le contenu complet du message rejeté.

Le Realtime Flutter sert à signaler une nouvelle réponse sans déplacer le fil.
Le panel peut rafraîchir ses compteurs en temps réel, mais doit afficher un
bouton « N nouveaux éléments — actualiser » plutôt que réordonner une file que
le modérateur est en train d’examiner.

## Signalements

Créer une file triée par statut et ancienneté, filtrable par portée et motif. Afficher le contexte minimal nécessaire, le déclarant, la cible, la date, l’assignation et les signalements similaires. Actions : prendre en charge, classer sans suite, résoudre, ouvrir le contenu, masquer le contenu et préparer une sanction. La décision doit être motivée et appeler `community_resolve_report`.

Ne jamais permettre à un administrateur de parcourir librement les messages privés. Un message privé n’est visible que s’il est signalé, avec un contexte limité et chaque consultation journalisée.

### Architecture obligatoire pour les messages privés

La migration `20260802030000_community_private_message_safety.sql` constitue le contrat de sécurité à respecter :

- `community_report_message` crée le dossier sans donner accès à la conversation ;
- `community_message_report_evidence` contient un instantané immuable de sept messages au maximum : le message visé, trois avant et trois après ;
- cette table n’a aucun droit direct pour `anon` ou `authenticated` et ne doit jamais être requêtée depuis le navigateur ;
- `community_open_message_report` est le seul point d’accès du panel ; il contrôle la portée du modérateur, exige un motif de consultation d’au moins dix caractères et crée une ligne `view_report_evidence` dans `community_moderation_log` ;
- `priority` vaut `urgent` pour menace ou contenu sexuel, `high` pour harcèlement, haine ou données personnelles, sinon `normal` ;
- le panel ne propose aucune recherche plein texte sur les messages privés, aucune liste des conversations et aucun bouton « ouvrir la conversation » ;
- l’identité du déclarant doit être protégée de la personne signalée ;
- les preuves ne doivent jamais apparaître dans les notifications, journaux techniques, analytics, URLs ou exports standards.

Dans le détail d’un signalement de message, afficher d’abord les métadonnées non sensibles : priorité, motif, espace, date, statut, délai de traitement, déclarant, personne visée et nombre de signalements antérieurs. L’ouverture du contenu est une action séparée nommée « Consulter l’extrait signalé ». Elle exige une justification, affiche un avertissement de confidentialité et journalise immédiatement l’accès. Mettre visuellement en évidence le message visé au milieu du contexte, sans permettre de naviguer avant ou après les sept éléments figés.

Pour une urgence crédible — menace de mort, danger immédiat, exploitation sexuelle d’un mineur — afficher un parcours d’escalade prioritaire, sans automatiser une accusation ni envoyer spontanément des données à un tiers. Prévoir : prise en charge urgente, conservation contrôlée des preuves, coordonnées du référent habilité, checklist juridique, décision motivée et trace d’audit. Toute transmission aux autorités doit être réalisée par une personne habilitée selon la procédure juridique validée, jamais par une action automatique du client Flutter.

### File unifiée des contenus publics

Les publications et commentaires utilisent la même file de signalements, mais restent clairement séparés des messages privés. Prévoir les onglets :

- Tous ;
- Urgents ;
- Messages privés signalés ;
- Publications ;
- Commentaires ;
- Profils et pièces jointes ;
- En recours ;
- Traités.

Pour une publication ou un commentaire, montrer le contenu signalé, son contexte public, l’auteur public, l’espace, la catégorie, les compteurs et l’historique de modération. Actions possibles selon le rôle : conserver, masquer temporairement, restaurer, verrouiller, retirer, épingler, désépingler, marquer comme résolu, avertir l’auteur ou préparer une sanction. Aucune suppression physique depuis le panel : utiliser les statuts existants afin de préserver l’audit et les recours.

### Cycle de traitement

Chaque dossier suit strictement : `new` → `triaged` → `in_progress` → `resolved` ou `rejected`, puis éventuellement `appealed`. La prise en charge renseigne `assigned_to` et `acknowledged_at`. Une décision requiert : règle enfreinte, faits retenus, action, portée, durée éventuelle, texte visible par l’utilisateur et note interne distincte. Empêcher qu’une même personne valide son propre recours lorsque l’équipe permet une séparation des rôles.

Créer des objectifs de traitement configurables, sans promesse contractuelle automatique : urgent en tête de file, puis ancienneté. Afficher les dossiers non pris en charge et les échéances dépassées. Dédupliquer visuellement les signalements visant la même cible, mais conserver chaque déclaration individuelle.

## Utilisateurs et sanctions

Rechercher un membre par pseudonyme ou identifiant. Afficher son profil public, ses espaces, ses contributions, signalements reçus, sanctions et recours. Ne pas afficher inutilement email, téléphone ou données privées.

Créer les RPC manquantes pour : avertissement, restriction de publication, restriction de commentaire, restriction de messagerie, suspension, bannissement, révocation. Une sanction peut être globale ou limitée à un espace. Réserver les sanctions aux rôles `admin` et `owner`. Exiger motif, durée, portée et confirmation. Journaliser l’état avant/après.

Ajouter le blocage utilisateur sans intervention d’un administrateur : l’app appelle `community_block_room_member`, ferme la conversation pour le bloqueur et empêche les nouveaux messages entre les deux membres. Le panel peut constater qu’un blocage existe uniquement lorsque cela est nécessaire au traitement d’un signalement ; il ne doit pas exposer la liste sociale complète d’un utilisateur.

Prévoir un recours clair pour les sanctions : notification dans l’app, motif compréhensible, règle concernée, portée, durée, date de fin, identifiant du dossier et formulaire de contestation limité à 2 000 caractères. Le recours ne restaure pas automatiquement un contenu dangereux. L’examen du recours doit créer une nouvelle trace d’audit et aboutir à maintien, réduction, révocation ou correction de la sanction.

Une sanction de messagerie est appliquée dans PostgreSQL via `community_can_publish(..., 'message')`, jamais uniquement en masquant le champ de saisie Flutter. Une suspension ou un bannissement doit bloquer les opérations concernées côté base. Toujours tester les tentatives directes via l’API.

## Catégories et espaces

Afficher `community_spaces` et `community_categories`. Permettre aux administrateurs autorisés de créer, modifier, réordonner, archiver et réactiver une catégorie. Gérer `posting_role`. Les identifiants système des cinq espaces ne doivent pas être supprimables. Toute mutation passe par une RPC et le journal d’audit.

## Modérateurs

Gérer `community_moderator_scopes`. Un modérateur peut être limité à un espace. Rôles : `helper`, `moderator`, `admin`, `owner`. Seuls `owner`, ou les rôles déjà autorisés par la politique centrale du panel, peuvent attribuer des droits élevés. Afficher l’auteur et la date d’attribution, l’expiration et la portée. Empêcher la suppression du dernier propriétaire.

## Annonces

Créer une annonce globale ou spécialisée, avec prévisualisation mobile. Les catégories dont `posting_role` vaut `admin` sont réservées au personnel autorisé. Prévoir titre, contenu, portée, épinglage et date d’expiration facultative. Ne pas envoyer de push tant que le système de notification n’est pas explicitement connecté.

## Notifications du forum

Le système utilise `community_notifications` et les types actuels :
`post_reply`, `comment_reply`, `followed_post_reply`, `reaction`,
`comment_reaction` et `message`. Le champ `payload` peut contenir
`comment_id`, `parent_id` ou `kind`. Le panel doit permettre de diagnostiquer
une notification sans en modifier le destinataire ni fabriquer une activité au
nom d’un utilisateur.

Prévoir une vue technique réservée aux administrateurs : type, cible, espace,
acteur public, destinataire pseudonymisé si possible, date, état lu et résultat
de livraison. Pour une notification de commentaire, le lien doit ouvrir la
publication puis révéler le commentaire exact indiqué par `payload.comment_id`.
Un commentaire retiré doit produire une page neutre et non une fuite de son
ancien contenu.

Ne jamais inclure le texte intégral d’un message privé dans une notification,
un push, une URL, un log ou un outil analytics. Les préférences utilisateur
`enabled`, `messages_enabled` et `forum_enabled` restent prioritaires. Ajouter
un bouton de renvoi uniquement pour les annonces administratives explicitement
prévues, jamais pour les notifications sociales ordinaires afin d’éviter les
doublons.

## Journal d’audit

Afficher `community_moderation_log` en lecture seule avec filtres par acteur, action, cible, espace et période. Prévoir une vue avant/après lisible. Aucun bouton de modification ou suppression. Les exports doivent être limités aux rôles autorisés et ne pas exposer de données privées superflues.

## Sécurité et confidentialité

- Toutes les pages restent derrière `AdminGate` et la MFA existante.
- Les permissions sont vérifiées dans PostgreSQL, pas avec un bouton masqué.
- Ne jamais utiliser `user_metadata` pour autoriser un rôle.
- Ne jamais exposer `service_role` dans le site statique.
- Ne jamais faire confiance à une portée, un auteur ou un statut envoyé par le navigateur.
- Respecter RLS et les grants explicites.
- Une vue exposée doit être `security_invoker=true` ou rester inaccessible aux clients.
- Afficher une erreur explicite pour les réponses PostgreSQL `42501`.
- Ne jamais introduire une possibilité de suppression physique massive.
- Appliquer le principe de moindre privilège : un modérateur ne voit que les espaces qui lui sont attribués et un helper ne prononce aucune sanction lourde.
- Séparer le texte destiné à l’utilisateur des notes internes de modération.
- Ne jamais réutiliser les messages privés pour l’entraînement, la publicité, le profilage ou les statistiques produit.
- Les détecteurs automatiques ne rendent jamais une décision finale. S’ils sont activés ultérieurement, ils fonctionnent derrière un feature flag, avec analyse d’impact, fournisseur contractuellement validé, métriques de faux positifs et revue humaine.
- Pour préserver la confidentialité, le socle actuel classe automatiquement la priorité d’un message uniquement après son signalement ; il ne scanne pas silencieusement toutes les conversations.
- Définir une politique de conservation documentée pour contenus, signalements, preuves et audit. La durée ne doit pas être codée arbitrairement : elle est validée avec le conseil juridique/DPO puis implémentée par une migration et une tâche serveur contrôlée.
- Toute consultation de preuve, décision, changement de rôle, sanction, recours et export est journalisé avec acteur, date, cible, motif et états avant/après.
- Les journaux sont immuables depuis le client, protégés contre l’accès non autorisé et ne recopient jamais le contenu intégral d’un message.
- Prévoir l’exercice des droits d’accès, rectification, effacement, limitation et opposition, tout en gérant séparément les obligations légales de conservation applicables.
- Afficher dans l’app les règles de communauté, la politique de confidentialité, la procédure de signalement, la procédure de recours et un contact dédié.

## Conformité et validation juridique avant production

Le code fournit des protections techniques, mais ne constitue pas une garantie universelle de conformité. Avant ouverture publique, faire valider au minimum par un professionnel compétent/DPO : rôles responsable de traitement et sous-traitants, base légale de la messagerie et de la modération, information des utilisateurs, analyse d’impact si nécessaire, politique de conservation, traitement des mineurs, transferts hors EEE, procédure de réquisition, gestion des contenus manifestement illicites, notification des violations et contrats des prestataires.

Le panel doit aider l’opérateur sans prétendre décider du droit. Ne jamais afficher « conforme RGPD » comme un état calculé. Afficher plutôt des contrôles vérifiables : politique publiée, version acceptée, DPA du fournisseur, localisation, échéance de revue, registre de traitement et dernier exercice de droits traité.

## UX et accessibilité

Réutiliser `AdminShell`, `PageHeader`, `Card`, `Badge`, `Button`, `Loading`, `Empty` et `ErrorBox`. Conserver les variables de couleurs existantes. Interface dense mais lisible, responsive à 768, 1024 et 1440 px, navigation clavier, focus visible, labels accessibles, contraste 4,5:1 et réduction des animations. Aucun emoji comme icône fonctionnelle ; utiliser Lucide.

Pour les actions d’une publication ou d’un commentaire, ne pas utiliser un menu
HTML brut difficile à lire. Prévoir un menu compact cohérent avec l’interface :
icône Lucide, libellé explicite, cible rappelée dans l’en-tête, zones tactiles
d’au moins 44 px, actions destructrices séparées et colorées sans dépendre de la
couleur seule. Sur mobile, utiliser une feuille d’actions arrondie ; sur bureau,
un popover ancré accessible. Les confirmations destructrices doivent rappeler
la conséquence exacte et proposer Annuler par défaut.

## Tests obligatoires

Tester utilisateur non-admin, modérateur spécialisé, modérateur global, administrateur et propriétaire. Vérifier qu’un modérateur PA Exam ne peut pas agir sur GPX School, qu’une décision sans motif échoue, que chaque action produit une ligne d’audit, que les messages non signalés sont inaccessibles et qu’aucun secret n’apparaît dans le build statique.

Ajouter les scénarios de sécurité suivants :

1. un membre extérieur à la conversation ne peut pas signaler un identifiant de message deviné ;
2. le signalement contient au plus sept instantanés et ne donne accès à aucun message supplémentaire ;
3. l’utilisateur signalé ne voit ni l’identité du déclarant ni ses détails internes ;
4. un modérateur sans portée reçoit `42501` à l’ouverture de la preuve ;
5. une ouverture sans justification suffisante échoue et ne renvoie aucun contenu ;
6. chaque ouverture valide produit exactement une trace `view_report_evidence` ;
7. menace et contenu sexuel créent une priorité `urgent` ;
8. harcèlement, haine et donnée personnelle créent une priorité `high` ;
9. bloquer un membre ferme la conversation du bloqueur et empêche tout nouveau message ;
10. quitter une conversation retire immédiatement l’accès futur sans effacer les preuves déjà légalement conservées ;
11. une restriction de messagerie contourne impossible via un appel REST direct ;
12. aucune table de preuves n’est lisible directement avec un JWT `authenticated` ;
13. aucune notification ou erreur ne contient le texte d’un message privé ;
14. une sanction peut être contestée, examinée et révoquée avec audit complet ;
15. publications, commentaires, profils et messages utilisent des décisions motivées et réversibles lorsqu’approprié.
16. un arbre de 1 000 commentaires reste paginé et aucune requête ne charge tous les descendants ;
17. masquer un commentaire parent conserve un emplacement neutre et ses réponses accessibles selon les règles ;
18. `deleted_by_author` ne peut pas être restauré par un modérateur comme si l’auteur n’avait jamais supprimé son texte ;
19. une solution appartient à la même publication que le commentaire et une tentative croisée échoue ;
20. un modérateur ne peut pas changer une solution utilisateur sans RPC administrative, motif et audit ;
21. le compteur `reply_count` correspond aux enfants directs après insertion et retrait logique ;
22. le compteur `reaction_count` reste cohérent après ajout et retrait d’une réaction ;
23. les doublons rapprochés et la rafale de plus de cinq commentaires par minute sont rejetés côté PostgreSQL ;
24. une notification `comment_reply` ou `comment_reaction` conserve `payload.comment_id` et ouvre la bonne réponse ;
25. aucune notification sociale n’est renvoyée manuellement ou dupliquée par le panel ;
26. les tris pertinent, récent et ancien sont paginés côté serveur et utilisent des index adaptés ;
27. les identités liées aux commentaires sont chargées par lot et aucune donnée privée n’est exposée ;
28. toutes les actions sur un commentaire produisent exactement une entrée de journal avec état avant/après.

Exécuter lint, TypeScript et build exportable. Ne modifier `fae16dc1` qu’en régénérant officiellement l’export après validation. Fournir la liste des fichiers, RPC et migrations ajoutés, les tests exécutés et la procédure exacte de génération du dossier destiné à l’hébergeur.
