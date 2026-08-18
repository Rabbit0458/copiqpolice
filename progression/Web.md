# COP'IQ — Suivi du site web (copiq-web) : système de badges + état réel du forum

> **Fichier de pilotage**, dans l'esprit de `progression/CAS_PRATIQUES_500.md`.
> Créé le 30/07/2026 suite à l'implémentation du système de badges de
> vérification (admin/modérateur/actif/légende) sur l'app Flutter et le
> backend Supabase. À mettre à jour manuellement au fur et à mesure.

| Symbole | Signification |
|---|---|
| ⬜ | à faire |
| 🟡 | en cours |
| ✅ | fait et vérifié |

---

## 1. Constat de départ (30/07/2026)

En analysant `copiq-web` pour y câbler les badges, j'ai découvert que le
forum du site (`src/app/(dashboard)/forum/**`) et une partie de la page
profil fonctionnaient sur des **données 100 % factices** :

- `forum/page.tsx` utilise `MOCK_POSTS`/`MOCK_CATEGORIES` codés en dur, et
  sa tentative de requête réelle interroge une table **`forum_posts`** —
  qui **n'existe pas** dans Supabase (le vrai nom est
  `forum_posts_exam_gpx`, utilisé par l'app Flutter).
- Le formulaire "Nouveau sujet" ne fait aucun `insert()` réel — juste un
  faux message de succès après un `setTimeout`.
- `profil/page.tsx` interrogeait une table **`profiles`** — qui n'existe
  pas non plus (le vrai nom est `user_profiles`). **Corrigé dans cette
  session** (voir § 2).
- `node_modules` du projet est incomplet dans l'environnement où j'ai
  travaillé (pas de `typescript` ni de binaire `next`/`eslint`
  fonctionnel) — impossible d'y lancer `npm run build` pour vérifier la
  compilation. À faire côté utilisateur.

**Conséquence pour les badges** : je n'ai pas branché le composant badge
dans le forum web, puisqu'il n'y a aucune donnée d'auteur réelle à
afficher pour l'instant — ça aurait été du décor sur du mock. Le composant
est prêt (§ 2), il suffira de l'appeler une fois le forum réellement
connecté (§ 3).

---

## 2. Ce qui est fait

- ✅ `src/components/ui/user-verification-badge.tsx` — composant React/SVG
  équivalent à `lib/core/widgets/user_verification_badge.dart` côté
  Flutter. Même pictogramme (sceau 12 pointes + coche), mêmes couleurs
  (admin `#E53935`, modérateur `#FBC02D`, légende `#8B5CF6`, actif
  `#42A5F5`), retourne `null` pour `"none"`. Exporte aussi
  `badgeTypeFromString()` et `badgeTypeFromRoleAndQuizCount()` (calcul de
  secours uniquement — la source de vérité reste `compute_badge_type()`
  en base).
- ✅ `src/app/(dashboard)/profil/page.tsx` — corrigé pour lire la vraie
  table `user_profiles` (au lieu de `profiles`) et affiche le badge à côté
  du nom, calculé via `get_my_entitlement()` (même RPC que Flutter,
  sécurisée côté serveur).
- ⬜ **Vérifier la compilation** (`npm install && npm run build`) —
  non fait faute d'environnement Node complet ici.
- ⬜ **Vérifier visuellement** la page `/profil` en dev (`npm run dev`),
  avec un compte admin (COPIQ) et un compte standard.

---

## 3. Ce qu'il reste à faire — forum web

Le forum web doit être reconnecté aux vraies tables avant que les badges
y aient un sens. Ordre suggéré :

1. ⬜ Remplacer les requêtes `forum_posts`/`profiles` par les vraies
   tables `forum_posts_exam_gpx` / `forum_post_comments_exam_gpx` /
   `user_profiles` (mêmes tables que l'app Flutter, cf.
   `lib/features/forum/forum_espace_exam_gpx.dart` pour la référence des
   colonnes exactes : `id, author_id, username, title, content, image_url,
   created_at, is_deleted`).
2. ⬜ Brancher la création réelle de sujet (`handleCreateSubmit` fait
   actuellement un faux succès, aucun `insert()`).
3. ⬜ Une fois les vraies données affichées, appeler
   `get_public_profile_badges(p_user_ids uuid[])` (RPC déjà créée et
   déployée, migration `20260730000000_user_badges_system.sql`) en un
   seul appel batché par écran avec la liste des `author_id` visibles, et
   afficher `<UserVerificationBadge type={...} />` à droite de chaque
   pseudonyme (liste de sujets, sujet ouvert, commentaires, réponses).
4. ⬜ Idem pour les pages `admin/forum` et toute autre zone du site
   affichant un auteur.

## 4. Hors scope de cette session (rappel, pas oublié)

- Le composant `Badge` générique (`src/components/ui/badge.tsx`, pastille
  de texte "premium"/"success"/etc.) est différent et n'a pas été touché
  — ne pas confondre avec `user-verification-badge.tsx`.
- Carte "XP Total" / "Niveau" sur `/profil` reste sur des données à 0
  (colonne `xp_total` inexistante) — la vraie source XP est
  `cas_pratique_user_progress` / `cas_pratique_xp_ledger` côté Supabase,
  pas branchée ici. Non touché pour rester focalisé sur les badges.

---

## 5. Centre d'information web et administrateur — 16/08/2026

- ✅ Centre public `/informations` avec présentation, état du service et accès rapide.
- ✅ FAQ publique dynamique, recherche et catégories.
- ✅ Formulaire de support réellement enregistré dans Supabase avec référence de suivi.
- ✅ Boîte de réception du support dans `/admin/informations` : statut, priorité et note interne.
- ✅ Mentions légales et confidentialité chargées depuis Supabase et modifiables dans le panneau.
- ✅ Notes de mise à jour publiques et administrables : brouillon, planification, publication et archivage.
- ✅ Sécurité d'écriture : aucune écriture directe depuis le navigateur ; RPC contrôlées, RLS et double authentification administrateur.
- ✅ Navigation publique mise à jour avec Aide, FAQ et notes de mise à jour.
- ✅ Migration distante appliquée sur le projet `nuoonagnkhbeeymtvrcn` sans suppression de table existante.
- ✅ ESLint ciblé sans erreur et compilation Next.js de production réussie (86 pages).
- ✅ Export `fae16dc1` régénéré et vérifié : 835 fichiers, 9,3 Mo.
- ⚠️ Les champs d'identification juridique marqués `[à compléter avant la mise en production]` doivent être renseignés par le propriétaire avant publication officielle.

### Correctif mobile Flutter — 16/08/2026

- ✅ Page Facturation mobile entièrement modernisée : carte Premium, état réel, échéance, jours restants, factures et total payé.
- ✅ Gestion de l'abonnement, de la carte et des factures reliée au portail Stripe sécurisé.
- ✅ Téléchargement et envoi des factures activés lorsqu'un lien Stripe existe.
- ✅ Suppression de la création automatique erronée d'un faux abonnement « Pro Mensuel actif ».
- ✅ Abonnement mobile désormais lu depuis la source Stripe unifiée `cp_my_subscription`.
- ✅ Page Informations mobile modernisée : état du service, version, appareil, FAQ, nouveautés, mentions légales et confidentialité.
- ✅ Présentation, statut et compteur FAQ chargés depuis le CMS Supabase administrable.
- ✅ Notes mobiles reliées à `list_public_patch_notes` ; elles ne dépendent plus d'une lecture directe réservée aux administrateurs.
- ✅ Analyse Flutter complète : aucune erreur.
