# Chantier continu — Site web COP’IQ, panel admin et quatre parcours

Dernière mise à jour : 2 août 2026

## 1. Règle de travail fondamentale

- Le projet source du site est `copiq-web/`.
- Le dossier `fae16dc1/` est la version statique générée pour l’hébergement. Il ne doit jamais être modifié à la main.
- Toute modification est d’abord développée et testée dans `copiq-web/`, puis exportée dans `fae16dc1/` après validation.
- L’application Flutter reste la référence fonctionnelle pour les quatre parcours, les droits d’écriture communautaires, les profils, les quiz, la progression et les contenus.
- Le site web doit réutiliser les mêmes données Supabase et les mêmes règles métier, sans dupliquer une seconde vérité.

## 2. Objectif produit

Construire un site COP’IQ complet et responsive permettant à un utilisateur de choisir l’un des quatre parcours, puis de retrouver sur le web une expérience cohérente avec l’application :

1. Concours Policier adjoint — PA Examen.
2. Concours Gardien de la paix — GPX Examen.
3. Scolarité Policier adjoint — PA École.
4. Scolarité Gardien de la paix — GPX École.

Le premier chantier est `copiq.fr/admin`, car ce panel doit permettre de piloter et modérer tout ce qui sera ensuite visible dans l’application et sur le site.

## 3. Socle admin déjà présent et à conserver

- Connexion par compte Supabase.
- Vérification que le compte appartient bien aux administrateurs COP’IQ.
- Double authentification TOTP obligatoire avec niveau AAL2.
- Code staff personnel supplémentaire.
- Permissions par rôle : owner, superadmin, admin et moderator.
- Appels via RPC PostgreSQL protégées ; aucune clé `service_role` dans le navigateur.
- RLS et contrôles serveur comme autorité finale. Masquer un bouton dans l’interface ne constitue jamais une sécurité.
- Pages existantes : tableau de bord, cas pratiques, appels, quiz, cours, santé du contenu, signalements, forum, utilisateurs, abonnements, patch notes, administrateurs et journal d’audit.

## 3 bis. Socle technologique obligatoire

- HTML sémantique pour la structure, l’accessibilité et le référencement.
- CSS moderne et Tailwind CSS pour les tokens, les thèmes et le responsive.
- TypeScript en priorité ; JavaScript uniquement pour les fichiers de configuration ou les scripts qui le nécessitent.
- React 19 pour les interfaces et les états interactifs.
- Next.js 16 avec App Router et export statique compatible avec l’hébergeur.
- Supabase pour Auth, PostgreSQL, RLS, RPC, Storage, Realtime et Edge Functions.
- Radix UI pour les composants complexes accessibles.
- Lucide React comme famille unique d’icônes ; aucun emoji utilisé comme icône d’interface.
- Framer Motion uniquement pour les animations utiles, courtes et compatibles avec `prefers-reduced-motion`.
- Zod pourra être ajouté lors de la consolidation des formulaires et des contrats de données.
- Les bibliothèques supplémentaires ne sont ajoutées que si elles résolvent un besoin réel sans dupliquer une capacité déjà présente.

## 4. Lot 1 — Fondation visuelle et centre de pilotage

État : en cours de validation.

- [x] Regrouper la navigation en quatre domaines : Pilotage, Contenus, Communauté, Système.
- [x] Remplacer les caractères décoratifs par des icônes Lucide cohérentes.
- [x] Créer un menu responsive mobile et une barre latérale réductible sur ordinateur.
- [x] Conserver l’affichage conditionnel selon les permissions réelles de l’administrateur.
- [x] Afficher clairement l’état AAL2 et le rôle actif.
- [x] Ajouter un changement clair/sombre accessible.
- [x] Ajouter les états de focus clavier, hover et transitions courtes.
- [x] Créer un centre de pilotage présentant les quatre parcours.
- [x] Conserver les statistiques réelles des cas pratiques et leur diagnostic de santé.
- [x] Relier les indicateurs globaux utilisateurs, forum, signalements et abonnements à la RPC transversale.
- [x] Ajouter un état de repli lisible lorsqu’une RPC n’est pas encore déployée.
- [x] Afficher la date de fraîcheur de la vue statistique matérialisée.
- [x] Ajouter une actualisation globale avec état de chargement accessible.
- [x] Retirer l'exécution anonyme des RPC critiques réellement utilisées par le panel.
- [ ] Valider les écrans 375, 768, 1024 et 1440 px.

### Livraison statique automatisée

- [x] Ajouter `PUBLIER_SITE.command` à la racine du dépôt.
- [x] Compiler automatiquement `copiq-web` en export statique.
- [x] Bloquer la publication si une route critique est absente.
- [x] Remplacer `fae16dc1` de façon atomique avec restauration en cas d'échec.
- [x] Conserver ou récupérer automatiquement la configuration publique Supabase de l'application Flutter.
- [x] Installer le `.htaccess` Apache avec routage, cache et en-têtes de sécurité.
- [x] Générer `deployment-manifest.json` dans le dossier final.
- [x] Valider un export réel comprenant 80 routes Next.js et `/admin/`.
- [ ] Migrer les routes API Stripe et suppression de compte vers Supabase Edge Functions : elles ne peuvent pas tourner dans un hébergement statique.

## 5. Lot 2 — Modération communautaire complète

Référence détaillée complémentaire : `progression/PROMPT_PANEL_ADMIN_FORUM.md`.

- [x] File unifiée des signalements : publication, réponse, message privé et profil.
- [x] Filtres serveur par urgence, type de contenu, espace communautaire et statut, avec pagination.
- [x] Recherche serveur par utilisateur, identifiant, titre, motif et extrait de contenu public.
- [x] Vue de contexte public avant décision : auteur, signalant, espace, contenu, statut et contestation.
- [ ] Actions graduées : classer, masquer, restaurer, avertir, limiter, suspendre, bannir temporairement, bannir définitivement.
- [x] Confirmation renforcée pour chaque action destructive déjà disponible.
- [x] Motif obligatoire et trace d’audit pour chaque décision de modération déjà disponible.
- [x] Affichage des recours et conservation des contenus retirés côté base.
- [ ] Détection assistée des contenus menaçants, sexuels, pédocriminels, haineux ou révélant des données personnelles.
- [x] Aucune lecture généralisée des conversations privées : accès exceptionnel uniquement à un message signalé et à trois messages avant/après au maximum.
- [x] Journaliser chaque accès exceptionnel, l’identité du modérateur et son motif obligatoire d’au moins dix caractères.
- [x] Interdire l’exécution anonyme de la file et limiter chaque résultat au scope réel du modérateur.
- [ ] Séparer clairement détection automatique, alerte, décision humaine et éventuel signalement aux autorités.

## 6. Lot 3 — Utilisateurs, rôles et sanctions

- [x] Fiche utilisateur globale : identité publique, parcours actif, abonnement, activité communautaire et sanctions.
- [x] Recherche et filtres serveur par parcours, mode, abonnement et présence d'une sanction, avec pagination.
- [x] Historique chronologique des avertissements, restrictions, suspensions et bannissements.
- [x] Possibilité de suspendre seulement une fonction : publication, commentaire, messagerie ou accès communautaire total.
- [x] Date de fin obligatoire pour chaque restriction ou suspension temporaire ; bannissement temporaire ou permanent explicite.
- [x] Réactivation et annulation tracées dans le journal d’audit immuable.
- [x] Empêcher l’auto-sanction et toute action sur un rôle de niveau égal ou supérieur.
- [x] Masquer les identifiants Stripe et ne jamais exposer le contenu des messages privés dans la fiche.
- [x] Tester réellement ajout et levée d’une sanction dans une transaction annulée, sans laisser de donnée de test.
- [x] Gestion des modérateurs par espace : global, PA/GPX et concours/école, avec rôle et expiration propres à chaque mission.
- [x] Attribution atomique des scopes, motif obligatoire et conservation de l’ancien/nouvel état dans le journal d’audit.
- [x] Interdiction de modifier ses propres scopes ou d’attribuer un rôle communautaire supérieur au rôle du panel.
- [x] Scope global du propriétaire créé et maintenu automatiquement ; les autres rôles restent explicitement limités.

## 7. Lot 4 — Gestion pédagogique des quatre parcours

- [x] Formaliser la centralisation des contenus, des routes et de la navigation dans un prompt autonome fondé sur l’état réel du projet.
- Prompt d’exécution : [PROMPT_CENTRALISATION_4_PARCOURS_WEB.md](./PROMPT_CENTRALISATION_4_PARCOURS_WEB.md)
- [x] Taxonomie centrale typée track/mode : PA/GPX et Concours/École, avec capacités, routes, couleurs et libellés uniques dans `copiq-web/src/config/pathways.ts`.
- [x] Tableau de bord par parcours avec volumes, brouillons, contenus publiés et anomalies.
  - Route source : `copiq-web/src/app/admin/contenus/page.tsx`.
  - La vue réutilise la taxonomie centrale de `src/config/pathways.ts` et les RPC administratives existantes des cours et quiz.
  - Les contenus anciens qui portent seulement PA/GPX sans mode concours/école ne sont pas répartis arbitrairement : ils apparaissent explicitement comme « à classifier ».
  - Accès ajouté au groupe « Contenus » de la navigation du panel, avec états de chargement, erreur, actualisation et affichage responsive.
- [ ] Gestion des cours, fiches, chapitres, quiz, réponses, explications et médias.
- [x] Prévisualisation web/mobile avant publication.
  - Composant partagé : `copiq-web/src/components/admin/content-preview.tsx`.
  - Les fiches affichent en direct leur en-tête, Markdown structuré, tableaux, citations, listes, points clés et références légales.
  - Les quiz peuvent être testés dans le panel : sélection d’une réponse, état correct/incorrect, explication et référence légale.
  - Deux formats sont proposés avec le même contenu : téléphone et web. Le rendu est isolé de l’enregistrement et ne publie jamais automatiquement.
  - Les contrôles sont accessibles au clavier, exposent leur état sélectionné et respectent la réduction des animations.
- [ ] Brouillon, planification, publication, archivage et restauration.
- [ ] Validation des données avant publication : aucun quiz incomplet, réponse correcte absente ou média cassé.
  - [x] Les fiches publiées sont bloquées si le titre, le contenu ou la couleur sont invalides ; les brouillons restent enregistrables.
  - [x] Les questions actives sont bloquées si la question est trop courte, les propositions sont insuffisantes ou dupliquées, la bonne réponse est absente ou la correction manque.
  - [x] Les recommandations non bloquantes distinguent clairement les améliorations facultatives des erreurs de publication.
  - [x] La file de contrôle du pilotage ouvre les fiches en brouillon et les modules dont les corrections manquent.
  - [x] Contrôle automatisé de l’existence, du format et de l’accessibilité des médias référencés.
    - Les images intégrées au Markdown sont extraites sans exécuter de HTML arbitraire.
    - Une description alternative est obligatoire ; seules les adresses HTTPS et les ressources locales `/…` sont acceptées.
    - Formats reconnus : AVIF, GIF, JPEG, PNG, SVG et WebP. Le navigateur confirme ensuite que chaque image peut réellement être chargée et décodée.
    - Une fiche publiée ne peut pas être enregistrée pendant le contrôle ni lorsqu’un média est invalide ou inaccessible. Un brouillon reste conservable pour permettre la correction.
    - La file `/admin/cours/?quality=media` donne accès à l’audit des fiches sans inventer un compteur indisponible dans les RPC de liste.
- [ ] Duplication contrôlée entre parcours, avec confirmation des différences métier.
- [ ] Historique des versions et auteur de chaque modification.
- [ ] Vérification des liens entre contenus et statistiques de progression.

## 8. Lot 5 — Portage du site utilisateur

- [x] Écran responsive de choix des quatre parcours après connexion ou création de compte.
- [x] Lecture et mise à jour vérifiée du parcours actif dans `public.user_profiles`, comme Flutter.
- [x] Premier branchement de l’accueil et de la navigation sur le parcours actif ; poursuivre avec les contenus réels et les routes canoniques.
- [ ] Catalogue de cours et exercices.
- [ ] Lecteur de cours responsive et accessible.
- [ ] Moteur de quiz avec sauvegarde, reprise, correction et explications.
- [ ] Progression synchronisée entre web et application.
- [ ] Forum global consultable et espace du parcours actif sélectionné par défaut.
- [ ] Écriture uniquement dans le parcours actif ; lecture seule dans les autres parcours.
- [ ] Profils communautaires, publications enregistrées, notifications et messagerie.
- [ ] Abonnements, facturation et contrôle des droits premium.
- [ ] Paramètres, confidentialité, export et suppression de compte.

## 9. Sécurité Supabase obligatoire

- RLS activée sur toute table exposée.
- Politiques explicitement limitées à `authenticated` quand l’accès public n’est pas nécessaire.
- Vérification explicite de `auth.uid()` dans les politiques utilisateur.
- Autorisation issue d’une table admin protégée ou de métadonnées d’application non modifiables par l’utilisateur ; jamais de `user_metadata` comme preuve de rôle.
- Fonctions `SECURITY DEFINER` avec `search_path` fixé, garde administrateur interne et droits d’exécution révoqués à `public` puis accordés au seul rôle nécessaire.
- Niveau `aal2` contrôlé côté base pour toute opération administrative sensible.
- Index sur les colonnes de politiques, filtres, tris et clés étrangères.
- Pagination obligatoire pour les listes volumineuses.
- Aucune clé secrète, clé de service ou donnée sensible intégrée au bundle statique.
- Journal d’audit append-only pour toutes les actions sensibles.

## 10. Qualité et définition de terminé

Une tâche n’est terminée que si :

1. le comportement est implémenté dans le projet source ;
2. les états chargement, vide, erreur, succès et permission refusée existent ;
3. le clavier, les lecteurs d’écran et le contraste sont pris en compte ;
4. l’affichage est contrôlé sur mobile, tablette et ordinateur ;
5. le lint et TypeScript passent ;
6. le build statique Next.js réussit ;
7. les routes principales et les règles de permission sont testées ;
8. les migrations éventuelles sont idempotentes, documentées et vérifiées ;
9. la version `fae16dc1/` est régénérée uniquement après validation ;
10. cette feuille de route et le journal des modifications sont actualisés.

## 11. Ordre d’exécution continu

1. Valider le lot 1 et connecter les statistiques globales.
2. Terminer la modération unifiée et son audit.
3. Terminer les fiches utilisateurs, sanctions et permissions.
4. Unifier l’administration des quatre parcours et de leurs contenus.
5. Créer le sélecteur de parcours web et les quatre accueils.
6. Porter cours, exercices, quiz et progression.
7. Porter forum, profils, notifications et messagerie.
8. Finaliser abonnement, compte, conformité, performances et accessibilité.
9. Tester la parité Flutter/web et préparer la mise en production.

## 13. Journal d’exécution web

### 4 août 2026 — Cycle éditorial complet des cours et quiz

- Ajout des états `draft`, `scheduled`, `published` et `archived` aux fiches de cours et questions de quiz, tout en conservant `is_published` et `is_active` pour la compatibilité Flutter.
- Les nouveaux contenus commencent désormais en brouillon afin d’éviter toute diffusion accidentelle ; les 14 cours et 228 questions existants ont conservé leur visibilité publiée.
- Ajout d’une restauration explicite. Un contenu planifié puis archivé revient en brouillon, car son ancienne date n’est volontairement pas réutilisée.
- Ajout d’un sélecteur éditorial compact et accessible dans `/admin/cours/` et `/admin/quiz/`, avec date/heure locale lorsque l’état « Planifiée » est choisi.
- Les contrôles éditoriaux et médias bloquent aussi bien la publication immédiate que la planification d’un contenu incomplet.
- Déploiement de la RPC `content_admin_set_lifecycle`, protégée par la garde administrateur et le niveau AAL2 déjà en place. Exécution refusée à `public` et `anon`, accordée uniquement à `authenticated` et `service_role`.
- Publication automatique chaque minute par `pg_cron` via une fonction interne du schéma `private`, non exposée au Data API.
- Journalisation des changements d’état et des publications automatiques dans `admin_audit_logs`, sans copier le corps complet ni les réponses des quiz.
- Migration : `supabase/migrations/20260804121500_admin_content_lifecycle.sql`, appliquée au projet `nuoonagnkhbeeymtvrcn`.
- Vérifications réelles : colonnes et valeurs par défaut présentes, tâche Cron active, droits des fonctions contrôlés, lint ciblé réussi, 10 tests automatisés réussis.
- Build Next.js de production réussi : TypeScript validé et 82 pages générées.
- `fae16dc1/` régénéré depuis la source ; six routes critiques, dont `/admin/`, contrôlées.
- L’audit Supabase signale encore des alertes anciennes hors de ce lot (droits GraphQL hérités sur plusieurs tables d’archive, extensions dans `public`, politiques RLS redondantes). Elles doivent être traitées dans un chantier de sécurité séparé après cartographie de leurs consommateurs, sans suppression globale aveugle. Référence : [Database Linter Supabase](https://supabase.com/docs/guides/database/database-linter).

### 4 août 2026 — Validation automatisée des médias

- Ajout de l’extraction et du rendu sécurisé des images Markdown dans l’aperçu web/mobile des fiches.
- Contrôles locaux avant toute requête : texte alternatif, protocole sécurisé et extension prise en charge.
- Contrôle réel de disponibilité et de décodage dans le navigateur, avec délai maximal, annulation lors d’une nouvelle saisie et blocage de la publication en cas d’échec.
- Ajout d’un diagnostic compact et accessible dans l’éditeur, plus une entrée dédiée dans la file de contrôle éditorial.
- Aucun changement du schéma ni des RPC Supabase : les médias sont actuellement référencés dans le corps Markdown des fiches.
- Lint ciblé réussi et six tests de validation réussis.
- Build Next.js de production réussi : TypeScript validé et 82 pages générées.
- Dossier statique `fae16dc1/` régénéré ; six routes critiques, dont `/admin/`, ont été contrôlées.

### 4 août 2026 — Contrôles avant publication

- Ajout d’un moteur de validation partagé pour les fiches et les questions de quiz, indépendant de l’interface et couvert par quatre tests automatisés.
- Un brouillon incomplet peut toujours être conservé ; le passage à l’état publié ou actif est refusé tant qu’une erreur bloquante subsiste.
- Contrôles des fiches : titre, densité minimale du contenu et couleur hexadécimale ; sous-titre, points clés et sources restent des recommandations.
- Contrôles des quiz : formulation, nombre et unicité des propositions, présence exacte de la bonne réponse et explication obligatoire ; catégorie et référence restent recommandées.
- Ajout d’un diagnostic accessible dans les deux éditeurs et d’une file de contrôle actionnable dans `/admin/contenus`.
- Ajout des filtres `/admin/cours/?status=draft` et `/admin/quiz/?quality=missing-explanation` sans modifier les RPC ni le schéma Supabase.
- Lint ciblé réussi et quatre tests de règles réussis lors de ce premier lot.

### 4 août 2026 — Prévisualisation pédagogique web et mobile

- Remplacement de l’ancien aperçu Markdown brut des fiches par un rendu pédagogique fidèle et sécurisé, composé uniquement de nœuds React.
- Ajout d’un simulateur partagé téléphone/web, responsive, lisible en thème clair et sombre, sans effet sur les données enregistrées.
- Ajout d’un aperçu interactif aux formulaires de quiz avec vérification visuelle de la bonne réponse et de la correction.
- Aucun changement des RPC, des règles Supabase ou des états de publication : l’activation reste une décision explicite de l’administrateur.
- Lint ciblé des deux éditeurs et du composant partagé : réussi.
- Build Next.js de production réussi : TypeScript validé et 82 pages générées.
- Dossier statique `fae16dc1/` régénéré ; six routes critiques, dont `/admin/`, ont été contrôlées par le script de publication.

### 4 août 2026 — Centre de pilotage pédagogique

- Ajout de `/admin/contenus` pour centraliser les quatre parcours dans une vue opérationnelle unique.
- Indicateurs disponibles : fiches totales et publiées, modules et questions de quiz, contenus actifs, brouillons, explications manquantes et contenus à classifier.
- Cartes distinctes PA Concours, GPX Concours, PA École et GPX École, alimentées par la configuration typée centrale.
- Aucun changement de schéma Supabase : les RPC administratives protégées existantes sont réutilisées.
- Lint ciblé des fichiers modifiés : réussi.
- Build Next.js de production : réussi, TypeScript validé et 82 pages générées, dont `/admin/contenus`.
- Le lint global reste en échec sur une dette antérieure de pages utilisateur (`any`, hooks et imports inutilisés) ; aucune erreur ciblée n’est issue de ce lot.

## 12. Décisions de conception

- Interface premium mais sobre : densité utile, grands espaces réservés uniquement aux informations importantes.
- Palette COP’IQ existante conservée ; le bleu reste la couleur d’action, tandis que rouge, orange et vert restent sémantiques.
- Aucune donnée factice présentée comme réelle dans le panel.
- Pas de graphique décoratif sans décision concrète associée.
- Animations courtes de 150 à 250 ms et respect de `prefers-reduced-motion`.
- Icônes issues d’une seule famille, libellés toujours présents quand le sens n’est pas universel.
- Les quatre parcours utilisent une structure commune et des accents visuels distincts, sans créer quatre applications séparées.
