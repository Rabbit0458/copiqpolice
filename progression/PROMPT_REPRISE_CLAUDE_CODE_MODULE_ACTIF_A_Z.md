# PROMPT DE REPRISE A–Z — MODULE « JE SUIS ACTIF » COP’IQ

> Document opérationnel à donner intégralement à Claude Code / Claude Cowork.
> Dernière mise à jour : 4 septembre 2026.

## PROMPT À EXÉCUTER

Tu reprends le développement de l’application COP’IQ. Travaille directement dans le projet existant, sans recréer une application, sans écraser les modifications en cours et sans inventer une nouvelle architecture lorsque les composants nécessaires existent déjà.

Ton objectif est de terminer, tester et documenter de bout en bout le module professionnel **« Je suis actif »**, son administration web, sa sécurité Supabase et son intégration dans l’application Flutter iOS/Android.

Ne considère jamais une tâche comme terminée sans preuve : code inspecté, commande de contrôle réussie, test fonctionnel ou vérification visuelle. Mets à jour la checklist de ce fichier au fur et à mesure. Si un élément ne peut pas être vérifié, laisse-le décoché et explique précisément pourquoi.

---

## 1. Emplacements du projet

- Racine Flutter et Supabase : `/Users/kaiso/Desktop/copiqpolice`
- Panel administrateur Next.js : `/Users/kaiso/Desktop/copiqpolice/copiq-web`
- Export web statique destiné à l’hébergement : `/Users/kaiso/Desktop/copiqpolice/fae16dc1`
- Règles permanentes : `/Users/kaiso/Desktop/copiqpolice/AGENTS.md`
- Cartographie globale : `/Users/kaiso/Desktop/copiqpolice/progression/CARTOGRAPHIE_COMPLETE_SCOLARITE_GPX_PA.md`
- Pyramide visuelle : `/Users/kaiso/Desktop/copiqpolice/progression/CARTOGRAPHIE_PYRAMIDALE_SCOLARITE_GPX_PA.png`
- Inventaire des sources : `/Users/kaiso/Desktop/copiqpolice/progression/migration_data/sources.jsonl`
- Projet Supabase déjà utilisé : `nuoonagnkhbeeymtvrcn`

Commence obligatoirement par lire `AGENTS.md`, ce document en entier, la cartographie et les fichiers cités dans les sections suivantes.

---

## 2. Règles de travail non négociables

1. Le dépôt contient de nombreuses modifications utilisateur non liées. Ne fais aucun reset, checkout destructif, nettoyage global ou réécriture massive.
2. Inspecte `git status` avant toute modification et limite chaque changement au périmètre du module actif.
3. Préserve les modifications existantes, y compris les fichiers non suivis.
4. Utilise les composants, styles et parcours COP’IQ déjà présents comme références. Le rendu du module actif doit reprendre le langage visuel de la page d’accueil Scolarité GPX.
5. Le module actif doit rester fonctionnellement séparé des parcours concours, scolarité GPX, scolarité PA et examens.
6. Toute modification d’un composant partagé doit être contrôlée sur les quatre périmètres imposés par `AGENTS.md` : scolarité GPX, scolarité PA, Exam GPX et Exam PA.
7. N’expose aucun secret Supabase, clé de service ou jeton dans Flutter, Next.js, les logs ou ce fichier.
8. Toutes les décisions d’accès sensibles doivent être appliquées côté serveur/RLS, jamais seulement masquées dans l’interface.
9. Ne déploie pas une version mobile ou web en production sans contrôles finaux et accord explicite du propriétaire.
10. Avant d’appliquer une migration, contrôle l’historique distant : ne rejoue pas une migration déjà appliquée.

---

## 3. Besoin produit complet

### 3.1 Entrée « Je suis actif »

- Le choix initial de l’application propose : « Je prépare le concours », « Je suis en scolarité » et, uniquement si le réglage distant l’autorise, « Je suis actif ».
- L’affichage du troisième choix est piloté en direct depuis le panel administrateur et Supabase, sans nouvelle soumission App Store/Google Play.
- Si le module est désactivé pendant qu’un utilisateur s’y trouve, afficher un message indiquant qu’une mise à jour du module doit être appliquée, avec un compte à rebours de 30 secondes.
- L’utilisateur peut quitter lui-même le module pendant ce délai.
- À zéro, il est automatiquement redirigé vers le `mode_picker`.
- Une réactivation devient visible après actualisation/réouverture.

### 3.2 Contrôle d’accès

- Le module est réservé aux personnes réellement gardiens de la paix.
- Le parcours attendu est `user_mode = active` et `user_track = gpx`.
- L’accès doit être accordé par un propriétaire autorisé, avec authentification AAL2/2FA et journalisation.
- Les opérations d’attribution, restauration et révocation doivent rester protégées côté serveur.
- La suppression de contenu nécessite une double confirmation et doit privilégier l’archivage.

### 3.3 Contenu piloté à distance

- Toutes les catégories, sous-catégories, cours, chapitres, textes, images, icônes, ordres, états brouillon/publié/archivé et relations parent-enfant sont administrables depuis le panel web.
- Aucun nouveau cours ne doit nécessiter la création d’une page Flutter ni une mise à jour des stores.
- Le propriétaire peut créer et corriger progressivement les contenus.
- Le panel offre une prévisualisation téléphone en direct aussi fidèle que possible au rendu Flutter.
- Les URL d’images doivent être prévisualisées, validées et gérées proprement en cas d’échec.
- Une bibliothèque d’icônes est disponible dans le formulaire.

### 3.4 Expérience mobile attendue

Le module actif doit reprendre la structure visuelle de la home Scolarité GPX :

- salutation personnalisée « Bonjour [prénom] » ;
- libellé d’espace professionnel ;
- bouton de changement de mode ;
- recherche ;
- accès aux paramètres ;
- titre « Espace professionnel — Gardien de la Paix » ;
- carrousel/cartes visuelles de sélection de contenu ;
- bloc « Ta prochaine étape » ;
- barre de navigation inférieure arrondie avec cinq onglets : accueil, suivi, communauté, favoris, profil.

Les cartes et contenus sont issus de Supabase. Le design ne doit pas casser les pages existantes.

### 3.5 Fonctionnalités de l’espace actif

- **Accueil** : catégories publiées, recherche et reprise du prochain contenu.
- **Suivi** : progression calculée à partir des événements d’apprentissage du module actif.
- **Communauté** : forum exclusivement réservé aux policiers actifs validés.
- **Favoris** : ajout/retrait et liste des contenus favoris du module actif.
- **Profil** : réutilisation cohérente du profil existant.
- **Paramètres** : logique existante de l’application, sans contourner les règles du module.
- **Cours** : lecture dynamique, chapitres distants et bouton de validation « Cours terminé ».

### 3.6 Forum séparé

- Le forum « Policiers actifs » ne doit pas être visible ni interrogeable par les utilisateurs concours/scolarité/non validés.
- Les actifs accèdent directement à leur espace verrouillé, sans pouvoir changer de portée depuis cet écran.
- Conserver les fonctions communautaires existantes compatibles : publications, commentaires/réponses, réactions, favoris, abonnements, signalements et modération.
- Toute notification communautaire doit rester limitée aux utilisateurs autorisés de cet espace.

### 3.7 Notifications

- Lorsqu’un nouveau cours est publié, une notification peut être envoyée uniquement aux utilisateurs du mode actif autorisé.
- Les utilisateurs concours et scolarité ne doivent rien recevoir pour ces publications.
- La disponibilité d’un nouveau module ou contenu suit la même règle de ciblage.

---

## 4. État déjà implémenté

### Flutter

- `lib/features/home/home_page_policier_actif.dart`
  - nouvelle coque proche de la home GPX ;
  - carrousel remplacé par un paquet de cartes superposées reprenant la gestuelle, les profondeurs et les aperçus latéraux de la home GPX ;
  - prénom chargé depuis le profil Supabase lorsque les métadonnées Auth sont incomplètes ;
  - accueil dynamique, recherche, paramètres, cartes, prochaine étape ;
  - navigation Accueil/Suivi/Forum/Favoris/Profil ;
  - forum ouvert avec `CommunityScope.active` verrouillé ;
  - suivi et favoris fondés sur les événements du module actif.
- `lib/features/active/active_access_service.dart`
  - récupération des événements d’apprentissage ;
  - calcul des identifiants favoris à partir du dernier événement.
- `lib/features/active/active_dynamic_course_page.dart`
  - bouton de fin de cours ;
  - enregistrement de l’événement `completed`.
- `lib/features/forum/community_models.dart`
  - ajout de `CommunityScope.active`.
- `lib/features/forum/community_repository.dart`
  - résolution de l’espace actif vers `CommunityScope.active`.
- `lib/features/forum/community_page.dart`
  - paramètres `initialScope` et `lockedToInitialScope` ;
  - espace actif verrouillé ;
  - espace actif exclu du sélecteur affiché aux autres modes.
  - noms complets autorisés sur deux lignes dans les cartes, détails et réponses afin d'éviter la troncature par la date et le menu.
- `test/features/forum/community_models_test.dart`
  - couverture des six portées communautaires.

### Panel administrateur

- Dossier principal : `copiq-web/src/app/admin/actif/`
- Gestionnaire : `copiq-web/src/app/admin/actif/active-content-manager.tsx`
- Fonctions déjà amorcées : publication/masquage du module, arborescence distante, création/édition de contenu, choix d’icône, aperçu téléphone et prévisualisation d’image.
- L’export statique se trouve dans `fae16dc1/admin/actif/` après génération.

### Supabase

- `supabase/migrations/20260829110000_active_mode_secure_access.sql`
- `supabase/migrations/20260903143000_active_mode_remote_content.sql`
- `supabase/migrations/20260903235500_active_admin_audit_severity_fix.sql`
- `supabase/migrations/20260904003000_active_community_space.sql`
- `supabase/migrations/20260904050000_sync_admin_staff_mobile_badges.sql`

La migration `active_community_space` a déjà été appliquée au projet distant `nuoonagnkhbeeymtvrcn`. Elle :

- crée la portée communautaire `active` ;
- crée les catégories actualités de service, pratiques professionnelles, entraide, formation continue et mobilité/carrière ;
- ajoute `active_community_access()` ;
- applique les politiques RLS aux espaces, catégories, membres, publications, commentaires, réactions, favoris et abonnements ;
- réserve les données actives aux utilisateurs authentifiés `active + gpx + granted`, avec maintien des droits de modération prévus.

La migration `sync_admin_staff_mobile_badges` a également été appliquée. Elle relie automatiquement les futurs comptes staff à leur compte Auth lorsque l'adresse correspond, et fait du rôle actif du panel la source prioritaire du badge mobile/public. La fiche Nolwenn Lafond a été reliée au compte mobile correspondant après correction de l'adresse `.com`/`.fr`; les RPC renvoient désormais `display_name = Nolwenn Lafond` et `badge_type = moderator`.

Ne rejoue pas cette migration à l’aveugle. Vérifie d’abord l’historique distant.

---

## 5. Contrôles déjà réussis

- [x] Formatage Dart des fichiers Flutter touchés.
- [x] Analyse ciblée Flutter sans erreur sur la home active, les services actifs et le forum.
- [x] Tests unitaires du modèle communautaire : 7 tests réussis.
- [x] Test RLS : un utilisateur PA/scolarité non actif obtient zéro ligne pour l’espace `active`.
- [x] Test RLS transactionnel : un propriétaire simulé `active + gpx + granted` voit l’espace actif.
- [x] La simulation de droits a été annulée dans la transaction, sans mutation de test persistante.
- [x] Le choix « Policiers actifs » est exclu du sélecteur communautaire normal.
- [x] L’écran communautaire du module actif est verrouillé sur sa portée.
- [x] Le badge jaune d'un modérateur du panel est renvoyé par les RPC de profil et d'entitlement.
- [x] Le nom public complet de Nolwenn Lafond est renvoyé sans troncature par la couche de données.
- [x] Le panel propose désormais le périmètre communautaire « Policiers actifs ».
- [x] Le lint ciblé de la page Administrateurs, le build Next.js et l'export `fae16dc1` réussissent.
- [x] Build iOS Release sans signature réussi : `build/ios/iphoneos/Runner.app`.

Commandes ciblées ayant réussi :

```bash
cd /Users/kaiso/Desktop/copiqpolice
dart format \
  lib/features/home/home_page_policier_actif.dart \
  lib/features/active/active_access_service.dart \
  lib/features/active/active_dynamic_course_page.dart \
  lib/features/forum/community_models.dart \
  lib/features/forum/community_repository.dart \
  lib/features/forum/community_page.dart \
  test/features/forum/community_models_test.dart

flutter analyze \
  lib/features/home/home_page_policier_actif.dart \
  lib/features/active/active_access_service.dart \
  lib/features/active/active_dynamic_course_page.dart \
  lib/features/forum/community_models.dart \
  lib/features/forum/community_repository.dart \
  lib/features/forum/community_page.dart

flutter test test/features/forum/community_models_test.dart

flutter build ios --no-codesign
```

Les audits Supabase globaux signalent aussi des problèmes historiques hors de ce module (tables anciennes, politiques multiples, extensions publiques, etc.). Ne les corrige pas en bloc dans cette mission et ne prétends pas que l’audit global est propre.

---

## 6. Checklist restante à exécuter

### A. Audit initial et protection du travail

- [ ] Lire intégralement `AGENTS.md` et les fichiers de cartographie.
- [ ] Examiner `git status --short` sans modifier ni supprimer les changements existants.
- [ ] Lire tous les fichiers listés dans les sections Flutter, web et Supabase.
- [ ] Comparer l’historique des migrations locales avec celui du projet Supabase distant.
- [ ] Rechercher les TODO, erreurs silencieuses et chemins de navigation du module actif.

### B. Vérification fonctionnelle du contrôle d’accès

- [ ] Tester le profil sans validation : carte active absente ou accès refusé.
- [ ] Tester le profil `active + gpx` avec validation accordée : accès autorisé.
- [ ] Tester un profil actif non GPX : accès refusé.
- [ ] Tester révocation, restauration et expiration éventuelle.
- [ ] Tester que seul le rôle owner autorisé et en AAL2 peut administrer les validations.
- [ ] Vérifier la présence des traces d’audit pour chaque action sensible.
- [ ] Vérifier qu’aucune réponse attendue ou donnée d’autorisation sensible n’est envoyée au navigateur.

### C. Activation distante et éviction à 30 secondes

- [ ] Afficher le module depuis le panel, relancer/actualiser Flutter et confirmer l’apparition de la troisième carte.
- [ ] Masquer le module depuis le panel et confirmer sa disparition après actualisation/réouverture.
- [ ] Désactiver le module pendant que l’utilisateur se trouve sur chacun des cinq onglets.
- [ ] Vérifier le message de maintenance et le décompte exact de 30 secondes.
- [ ] Vérifier qu’un départ volontaire annule proprement le minuteur.
- [ ] Vérifier la redirection automatique vers `mode_picker` à zéro.
- [ ] Vérifier l’absence de boucle de navigation ou d’écran accessible après désactivation.

### D. Administration des contenus

- [ ] Créer une catégorie racine avec titre, sous-titre, icône, image et ordre.
- [ ] Créer une sous-catégorie rattachée à cette catégorie.
- [ ] Créer un cours et plusieurs chapitres rattachés à la sous-catégorie.
- [ ] Vérifier les états brouillon, publié et archivé à tous les niveaux.
- [ ] Vérifier les changements d’ordre et de parent.
- [ ] Vérifier la double confirmation avant archivage/suppression.
- [ ] Vérifier qu’une URL d’image valide apparaît dans l’aperçu web et sur Flutter.
- [ ] Vérifier le rendu de secours d’une URL vide, invalide, lente ou indisponible.
- [ ] Vérifier la liste d’icônes, la sélection active et le rendu identique côté mobile.
- [ ] Vérifier l’éditeur de contenu riche et sa prévisualisation téléphone.
- [ ] Vérifier articles, encadrés, listes, couleurs, circulaires et retours à la ligne.
- [ ] Vérifier que le contenu de test `TEst`/`test` est archivé ou remplacé par le propriétaire avant production.

### E. Accueil et navigation mobile

- [ ] Comparer visuellement la home active à `home_page_gpx_school.dart` sur un iPhone réel ou simulateur.
- [ ] Contrôler le rendu sur petite et grande hauteur d’écran, avec encoches et zones sûres.
- [ ] Contrôler mode clair et mode sombre si l’application les supporte.
- [ ] Tester la recherche avec aucun, un et plusieurs résultats.
- [ ] Tester les cartes avec titres longs, sous-titres longs et images de ratios différents.
- [ ] Tester la carte « Ta prochaine étape » et sa destination.
- [ ] Tester le changement de mode.
- [ ] Tester l’accès aux paramètres et le retour vers l’espace actif.
- [ ] Tester la conservation d’état lors des changements d’onglet.
- [ ] Vérifier les cinq onglets : Accueil, Suivi, Forum, Favoris, Profil.
- [ ] Vérifier VoiceOver/TalkBack, contrastes et cibles tactiles d’au moins 44 × 44.

### F. Cours, suivi et favoris

- [ ] Ouvrir catégorie → sous-catégorie → cours → chapitre.
- [ ] Marquer un cours terminé et contrôler l’écriture dans `active_learning_events`.
- [ ] Vérifier que le suivi se met à jour sans doublon de progression.
- [ ] Ajouter puis retirer un favori et contrôler les événements correspondants.
- [ ] Vérifier que l’onglet Favoris reflète immédiatement le changement ou se rafraîchit explicitement.
- [ ] Tester un favori dont le contenu a ensuite été archivé.
- [ ] Tester reprise et prochaine étape après fermeture/réouverture.
- [ ] Vérifier les états vide, chargement, erreur réseau et nouvelle tentative.

### G. Forum réservé aux actifs

- [ ] Avec un actif validé, créer une publication dans chaque catégorie autorisée.
- [ ] Tester commentaires, réponses imbriquées, réactions, favoris et abonnements.
- [ ] Tester signalement et traitement dans le panel admin existant.
- [ ] Tester notifications et navigation vers la publication concernée.
- [ ] Vérifier que le forum actif n’offre aucun sélecteur vers les autres portées.
- [ ] Vérifier qu’un utilisateur concours/scolarité ne voit pas « Policiers actifs » dans son sélecteur.
- [ ] Vérifier par requêtes directes qu’un utilisateur non actif ne peut lire, créer, modifier ou supprimer aucune donnée active.
- [ ] Vérifier que les fonctions RPC/Realtime ne contournent pas la RLS.
- [ ] Vérifier que les modérateurs conservent uniquement les droits explicitement attendus.
- [ ] Vérifier que l’espace actif reste séparé dans les listes et filtres du panel admin.

### H. Notifications de contenu

- [ ] Localiser le mécanisme de notifications existant et réutiliser son architecture.
- [ ] Envoyer une notification uniquement lors d’une vraie publication, pas à chaque sauvegarde de brouillon.
- [ ] Cibler exclusivement les utilisateurs actifs GPX autorisés.
- [ ] Tester qu’un utilisateur concours ou scolarité ne reçoit rien.
- [ ] Tester refus de notification, token invalide, doublon et nouvelle tentative.
- [ ] Ajouter une trace d’audit exploitable dans le panel.

### I. Panel web et export `fae16dc1`

- [ ] Exécuter les tests/lint/build du projet `copiq-web` selon ses scripts `package.json`.
- [ ] Tester le panel sur largeur ordinateur et tablette.
- [ ] Tester authentification, expiration de session et AAL2.
- [ ] Vérifier tous les messages d’erreur et états de chargement.
- [ ] Vérifier que les erreurs Supabase ne révèlent aucune donnée sensible.
- [ ] Si le web a changé, exécuter le script de publication/export prévu par le projet, notamment `npm run release:hosting` s’il reste le script officiel.
- [ ] Contrôler que `fae16dc1/admin/actif/` contient bien la nouvelle version.
- [ ] Ne pas modifier manuellement les fichiers générés de `fae16dc1`.
- [ ] Obtenir l’accord du propriétaire avant déploiement sur `copiq.fr`.

### J. Base de données et sécurité

- [ ] Vérifier chaque table/RPC du module actif avec les rôles anon, authenticated non actif, actif validé, modérateur et owner.
- [ ] Confirmer les `GRANT/REVOKE` des fonctions sensibles.
- [ ] Vérifier que les fonctions `SECURITY DEFINER` fixent un `search_path` sûr.
- [ ] Vérifier indexes et plans des requêtes réellement utilisées par la home, le suivi et le forum.
- [ ] Tester Realtime avec la même isolation que les lectures classiques.
- [ ] Ajouter des tests SQL reproductibles dans `supabase/tests/` pour les règles essentielles.
- [ ] Préparer un rollback documenté pour toute nouvelle migration.
- [ ] Relancer les advisors Supabase et distinguer clairement nouvelles alertes et dette historique.

### K. Régressions globales imposées par le projet

- [ ] Scolarité GPX : home, communauté, profil et paramètres inchangés fonctionnellement.
- [ ] Scolarité PA : home, communauté, profil et paramètres inchangés fonctionnellement.
- [ ] Exam GPX : navigation et composants partagés toujours fonctionnels.
- [ ] Exam PA : navigation et composants partagés toujours fonctionnels.
- [ ] Aucun utilisateur non actif ne voit la portée active.
- [ ] Aucun changement du module actif ne modifie les banques de quiz existantes.

### L. Qualité et builds finaux

- [ ] `dart format --output=none --set-exit-if-changed` sur les fichiers touchés.
- [ ] `flutter analyze` ciblé sans erreur.
- [ ] `flutter test test/features/forum/community_models_test.dart` réussi.
- [ ] Ajouter des widget tests pour la barre de navigation, l’état vide, les favoris et le décompte d’éviction.
- [ ] Ajouter des tests du service d’accès et des événements d’apprentissage.
- [ ] Exécuter les autres tests directement affectés par les composants partagés.
- [ ] Exécuter la suite Flutter complète et documenter séparément toute panne préexistante.
- [ ] Construire et lancer iOS sur simulateur puis appareil réel.
- [ ] Construire et lancer Android sur émulateur puis appareil réel.
- [ ] Vérifier l’absence de crash, overflow, boucle de navigation et erreur réseau non gérée.
- [ ] Contrôler `git diff --check`.
- [ ] Relire le diff limité aux fichiers de la mission.

### M. Préparation de la livraison

- [ ] Supprimer/archiver les contenus de test après validation du propriétaire.
- [ ] Établir la liste exacte des migrations appliquées.
- [ ] Établir la liste exacte des fichiers modifiés.
- [ ] Préparer les notes de version iOS/Android.
- [ ] Mettre à jour version/build uniquement au moment convenu avec le propriétaire.
- [ ] Confirmer que la politique de confidentialité couvre l’espace communautaire actif et ses notifications.
- [ ] Demander l’autorisation avant déploiement web, publication stores ou envoi massif de notifications.
- [ ] Après livraison, mettre à jour ce document avec les preuves et les éventuelles réserves.

---

## 7. Critères d’acceptation finaux

Le module est terminé uniquement si :

1. son affichage est contrôlable en direct depuis le panel ;
2. la désactivation expulse correctement tous les utilisateurs actifs après 30 secondes ;
3. seuls les gardiens de la paix validés peuvent entrer et lire les données ;
4. les catégories, sous-catégories, cours et chapitres sont entièrement distants ;
5. la home reprend fidèlement l’expérience GPX demandée avec cinq onglets fonctionnels ;
6. progression, favoris et fin de cours sont persistants et fiables ;
7. le forum actif est réellement séparé côté interface, base de données et notifications ;
8. le panel offre une édition sûre, une prévisualisation utile et une journalisation complète ;
9. les parcours GPX/PA scolarité et examen ne régressent pas ;
10. les builds iOS et Android et les tests concernés réussissent ;
11. aucune clé ni donnée sensible n’est exposée ;
12. chaque case cochée possède une preuve vérifiable.

---

## 8. Format obligatoire du compte rendu de Claude

À chaque fin de session, fournis :

1. **Résultat obtenu** : ce qui fonctionne réellement.
2. **Fichiers modifiés** : chemins absolus et rôle de chaque fichier.
3. **Base de données** : migrations créées/appliquées, projet ciblé et résultat.
4. **Contrôles réussis** : commandes/tests avec leur résultat exact.
5. **Contrôles non réussis** : erreur exacte et cause probable, sans masquer l’échec.
6. **Périmètre de régression contrôlé** : GPX scolarité, PA scolarité, Exam GPX, Exam PA.
7. **Checklist mise à jour** : conserver cochées uniquement les tâches prouvées.
8. **Reste à faire** : liste courte, ordonnée par risque et dépendance.
9. **Action nécessitant le propriétaire** : déploiement, choix produit, identifiants ou validation sur appareil.

Ne réponds jamais seulement « c’est bon ». Donne des preuves et laisse les tâches non vérifiées décochées.
