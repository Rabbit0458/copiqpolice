# 🏛️ COP'IQ — ADMIN CAS PRATIQUE — Roadmap ultra-pro

> **Vision** : Panel admin de niveau **Notion / Linear / Stripe Dashboard** dédié à la gestion complète du module Cas Pratique. Tout doit être fluide, rapide, beau, intelligent, collaboratif.
>
> **Style** : enterprise-grade, multi-millions, multi-admin, audit-trail, AI-assisted.

---

## 📊 Statut global

| Total tâches | À faire | Effort solo |
|---|---|---|
| **130** | 130 | ~30-40 jours |

| Phase | Tâches | Description |
|---|---|---|
| **A** Foundation | 12 | Auth, rôles, audit, infra |
| **B** CRUD cases | 18 | Cas pratiques A→Z |
| **C** Éditeur rubric | 22 | Le coeur — éditeur ultra-pro |
| **D** AI-powered | 14 | Génération IA + suggestions |
| **E** Modération appels | 8 | Workflow appel + réponse |
| **F** Stats & analytics | 12 | Mesure de tout |
| **G** Collaboration | 10 | Multi-admin, présence live |
| **H** Import / Export | 8 | Bulk operations |
| **I** Versionning & workflow | 12 | Draft → Review → Published |
| **J** Polish & UX | 14 | Le wow effect |

---

## 🟦 PHASE A — Foundation & Sécurité (12)

### A-01 — Table `admin_cas_pratique_users` + rôles 🔥 P0
**SQL** : `super_admin / content_lead / content_editor / moderator / viewer` (5 rôles)
**RLS** : seul super_admin peut INSERT dans la table
**UI** : page `/admin/team` avec invitation par email + révocation

### A-02 — Edge function `cp_admin_check_role` 🔥 P0
**Action** : retourne `{role, permissions[]}` pour le user courant
**Cache** : 5 min côté client
**Sécurité** : signed JWT obligatoire, audit chaque appel

### A-03 — Système de permissions granulaires
**Matrice** : qui peut quoi sur (cases, themes, questions, rubric, keywords, appeals, memos, promo, flags, users)
**API** : `canEdit('case', caseId)`, `canPublish('case')`, `canModerate('appeal')`

### A-04 — Audit log automatique (tous DML)
**Trigger** : BEFORE/AFTER sur tables sensibles → INSERT dans `cas_pratique_admin_audit`
**Diff** : payload before/after en JSONB pour rollback potentiel
**Retention** : 365 jours minimum

### A-05 — Page `/admin/audit-log` avec filtres avancés
**Filtres** : par admin, par action, par entité, par date
**Export** : CSV/JSON pour conformité RGPD
**Recherche** : full-text sur le payload

### A-06 — MFA TOTP obligatoire pour tous les admins
**Setup** : page d'enrollment QR code (premier login)
**Backup codes** : 10 codes one-shot
**Verrouillage** : 5 échecs MFA → 24h ban + email alert

### A-07 — Session management
- Inactivité 30 min → logout auto
- Vue "Sessions actives" par admin + bouton "Déconnecter partout"
- Notification email à chaque nouveau login (device, IP, géolocalisation)

### A-08 — Rate limiting actions admin
- 200 mutations/heure max par admin
- 50 deletions/jour max
- Edge function `cp_admin_rate_limit_check`

### A-09 — Backup automatique journalier
- pg_dump quotidien chiffré → S3/R2
- Retention 30 jours
- Test de restauration mensuel automatisé

### A-10 — Page Status admin
- Endpoint `cas_pratique_health` (CODE-083)
- Latence API/DB en temps réel
- Liens vers Sentry / PostHog / Supabase

### A-11 — Hooks Slack/Discord pour events critiques
- Nouveau admin créé
- Cas publié
- Appel approuvé/rejeté
- Erreur >P1 dans Sentry

### A-12 — Conformité RGPD
- Page "Mes données" (export JSON de TOUTES les actions admin)
- Délai légal de réponse aux demandes : 30 jours max
- Anonymisation auto des admins supprimés

---

## 🟩 PHASE B — CRUD Cases (18)

### B-01 — Page `/admin/cases` — liste premium
**Vue** : table + cards toggle, virtualisation pour >1000 cas
**Colonnes** : Titre, Thème (badge couleur), Année, Difficulté, Tier, Statut workflow, Stats rapides (attempts, success%, last modified)

### B-02 — Filtres combinés en pills
- Année, thème, difficulté, statut workflow, tier (free/premium)
- Sauvegarde des filtres "favoris" par admin
- URL avec query params (partageable)

### B-03 — Tri multi-colonnes
**Critères** : created_at, popularité (attempts), success_rate, last_modified, alphabétique
**Sort secondaire** : maintien d'un ordre stable

### B-04 — Recherche full-text instantanée
**Backend** : RPC `cp_admin_search_cases` avec `pg_trgm` (fuzzy)
**Frontend** : debounce 250ms, surlignage des termes

### B-05 — Bulk select + actions de masse
- Publier / Dépublier
- Supprimer (avec confirmation typée)
- Changer thème en masse
- Changer difficulté en masse
- Exporter sélection (JSON/CSV)
- Dupliquer en masse

### B-06 — Création d'un nouveau cas — Wizard 4 étapes
1. **Informations** : titre, slug auto, année, thème, difficulté
2. **Mise en situation** : éditeur markdown WYSIWYG avec preview live
3. **Questions** : ajout 3-5 questions avec assistant IA
4. **Rubric** : éditeur complet (cf. Phase C)

### B-07 — Édition d'un cas — Vue split-pane
**Gauche** : navigation des sections (Infos / Texte / Questions / Rubric / Stats / History / Comments)
**Droite** : contenu de la section + preview live à droite

### B-08 — Auto-save toutes les 2 secondes
**Indicateur** : "Saved 3s ago" en haut à droite
**Conflit** : détection optimistic concurrency, modal "X vient de modifier ce cas"

### B-09 — Suppression intelligente
- Modal de confirmation avec impact (X tentatives liées, Y appels)
- Soft delete par défaut (déplaçable dans corbeille pendant 30j)
- Hard delete réservé super_admin

### B-10 — Duplication d'un cas
- Clone titre + situation + toutes les questions + rubric + keywords
- Suffix `(copie)` automatique
- Statut `draft` forcé

### B-11 — Versioning de cas (snapshots)
- Snapshot à chaque publication
- Page "History" qui liste les versions avec diff
- Bouton "Restaurer cette version"

### B-12 — Aperçu mobile en sandbox
- Mode preview qui simule l'app mobile dans un iframe
- Switch dark/light
- Testeur intégré : "Faire le cas comme un user"

### B-13 — Upload d'images dans la mise en situation
- Drag-drop direct dans le textarea markdown
- Compression auto (<200 KB) côté serveur
- Upload vers Storage bucket `cas-pratique-assets`
- CDN URL injectée auto

### B-14 — Calendrier de publication
- Date `scheduled_publish_at`
- Cron toutes les 5 min qui flip `is_published = true`
- Vue calendrier mensuel des publications

### B-15 — Templates de cas (5+ modèles)
- "Contrôle d'identité standard", "Légitime défense", "Détention provisoire", "Outrage à agent", "Saisie drogue"
- Bouton "Démarrer depuis un template"

### B-16 — Tags personnalisés
- Tags libres par cas (ex: "concours 2024", "à corriger", "prioritaire")
- Filtrage par tags

### B-17 — Notifications push lors d'événements
- Nouveau cas créé (équipe content)
- Cas en attente de review depuis >24h
- Pic d'appels sur un cas (>5)

### B-18 — Import d'un PDF existant → cas pratique
- Upload PDF → OCR si scanné → parse markdown
- Extraction auto questions + correction si format reconnu

---

## 🟨 PHASE C — Éditeur Rubric ULTRA pro (22)

> **C'est LE coeur du panel**. L'éditeur de rubric doit être au niveau de Linear pour la gestion d'issues.

### C-01 — Layout 3 colonnes
- Gauche : navigation Questions (1, 2, 3…)
- Centre : éditeur du rubric point sélectionné
- Droite : preview live de la correction qui sera affichée au user

### C-02 — Drag & drop réordonnement
- Questions : drag pour changer la position
- Rubric points : drag dans la liste
- Keywords : drag entre groupes (move) ou copy
- Animation fluide, sauvegarde optimistic

### C-03 — Création rapide d'un rubric point
- Inline (pas de modal) : `+ Ajouter un point` puis tab
- Champs : label, poids (0.5/1/2/3), required toggle, kind (core/bonus/penalty)
- Raccourci clavier `Cmd+J`

### C-04 — Éditeur de groupes de keywords (OR logic)
- Chaque groupe = au moins 1 keyword doit matcher
- Bouton `+ Nouveau groupe` (OR)
- Bouton `+ Keyword` dans un groupe (AND si groupe required, OR si optional)
- Toggle `is_optional` par groupe

### C-05 — Édition d'un keyword
**Champs** :
- value (text)
- is_phrase (toggle — match exact si true)
- is_negation (toggle — pénalise si présent)
- fuzzy_max_dist (0/1/2 — distance Levenshtein)
- syn_dict_id (link vers dictionnaire de synonymes)

### C-06 — Dictionnaire de synonymes
- Page dédiée `/admin/synonyms`
- Création de dicts réutilisables (ex: "synonyms_force")
- Réutilisation dans plusieurs keywords (factorisation)

### C-07 — Auto-complete de keywords
- Suggestion en frappe des keywords déjà utilisés dans le cas
- Évite les doublons
- Suggère des synonymes courants

### C-08 — Test runner en sidebar 🌟
- Zone "Tape une réponse de test ici"
- Bouton "Tester"
- Affiche en temps réel : points matched, score, feedback
- Permet d'ajuster les keywords sans publier
- **Le killer feature**

### C-09 — Coverage rubric
- Indicateur visuel : "12 keywords couvrent 87% des réponses-types"
- Suggère keywords manquants basés sur les attempts précédents (si dispo)

### C-10 — Heatmap des keywords matched / missed
- Vue stats par rubric point sur les 100 derniers attempts
- Couleur rouge si miss >70% (= keyword trop strict)
- Couleur verte si match >90% (= keyword trop large)

### C-11 — Editor markdown pour `explanation_md`
- Affiché côté user dans le détail de correction
- Preview live
- Liens vers articles légaux (auto-detect `Article XXX`)

### C-12 — Bibliothèque de keywords pré-établis
- Catégories : droit pénal, procédure, déontologie, organisation
- Drag-drop depuis la bibliothèque vers le rubric point
- Sync avec les seeds de production

### C-13 — Validation côté admin avant publication
- Bouton "Valider la rubric" : check les rules (au moins 1 keyword par point required, etc.)
- Erreurs visibles
- Blocage publication si erreurs critiques

### C-14 — Comparaison rubric A/B (CODE-046 prévoit)
- Côte à côte 2 versions de rubric
- Diff visuel sur les keywords
- Bouton "Promouvoir B en production"

### C-15 — Suggestion IA de keywords (cf. Phase D)
- Bouton "Suggérer des keywords pour ce point" → Claude API
- Affiche 10 suggestions, l'admin coche celles à garder

### C-16 — Suggestion IA de pondération
- Bouton "Suggérer le poids" → analyse de la difficulté du keyword
- Recommandation : 1 si standard, 2 si très spécifique, 0.5 si trivial

### C-17 — Importer un rubric depuis Excel/CSV
- Template Excel téléchargeable
- Drop sur la page
- Mapping colonnes → champs
- Validation avant import

### C-18 — Export rubric en PDF "fiche correcteur"
- Format imprimable A4
- Pour les correcteurs humains pendant les concours blancs

### C-19 — Soft preview "comme si j'étais user"
- Toggle "Vue user" qui désactive l'édition
- Voit exactement ce qu'il verra dans l'app
- Bouton "Faire le cas pour tester"

### C-20 — Commentaires sur un point de rubric
- Conversation thread par point (mention @admin)
- "À revoir" / "Validé" / "À discuter"
- Notif email aux mentionnés

### C-21 — Historique des modifications par champ
- Hover sur un keyword → tooltip "Modifié par X il y a 3j"
- Click → diff complet

### C-22 — Raccourcis clavier dédiés éditeur
- `J/K` navigation questions
- `Cmd+S` save (auto-save déjà actif mais raccourci forcé)
- `Cmd+D` dupliquer point/keyword
- `Cmd+Backspace` supprimer avec confirmation
- `Cmd+T` ouvrir le test runner
- `Cmd+/` documentation contextuelle

---

## 🟪 PHASE D — AI-Powered (14)

### D-01 — Génération complète d'un cas pratique par IA
**Form** : "Génère un cas sur [thème] [difficulté] [contexte/sujet]"
**Output** : titre + mise en situation + 3-5 questions + rubric complet pré-rempli
**Provider** : Claude API
**Cache** : pas de regen identique

### D-02 — Génération de la mise en situation seule
**Input** : titre + 2-3 mots-clés
**Output** : 3 variantes de mise en situation, l'admin choisit

### D-03 — Génération de questions à partir d'une mise en situation
**Input** : mise en situation existante
**Output** : 5 questions suggérées avec poids et type

### D-04 — Suggestion de keywords pour un rubric point
**Input** : label du point + contexte cas
**Output** : 10 keywords + 5 synonymes potentiels
**UI** : checkboxes pour sélectionner

### D-05 — Suggestion de explanation_md
**Input** : label + keywords
**Output** : explication pédagogique 100-200 mots avec références légales

### D-06 — Détection de doublons IA
**Action** : "Ce cas ressemble à 73% au cas X-2023" — évite la redondance dans le catalogue

### D-07 — Analyse de qualité d'un cas
- Score qualité 0-100 basé sur : longueur mise en situation, nombre questions, couverture rubric, références légales, etc.
- Suggestions d'amélioration ciblées

### D-08 — Vérification cohérence juridique
**Action** : envoie le cas à Claude avec prompt "Y a-t-il des erreurs juridiques dans ce cas ?"
**Output** : liste d'alertes à valider manuellement

### D-09 — Génération de variantes
**Input** : un cas existant
**Output** : 3 variantes avec contextes différents (même structure juridique, scénarios variés)
**Use case** : éviter que les users mémorisent un cas en particulier

### D-10 — Reformulation de questions
- Si une question a un taux de réussite anormal (très haut ou très bas) → suggérer reformulation

### D-11 — Auto-translation FR → EN
- Bouton "Traduire en EN" sur un cas
- Output : version EN dans une autre case (lien parent/child)
- Pour app internationale

### D-12 — Détection de PII dans les cas
**Action** : scan IA pour détecter des vrais noms/adresses/numéros
**Output** : remplace par variables anonymisées avant publication

### D-13 — Calibration automatique des poids
**Action** : analyse 100 attempts, ajuste les `weight` pour répartir mieux les scores
**ML** : régression linéaire simple

### D-14 — Chat assistant admin
- Bot Claude intégré bottom-right
- "Aide-moi à créer un cas sur la légitime défense"
- "Comment fonctionne le rubric ?"
- Lien direct vers la doc

---

## 🟧 PHASE E — Modération Appels (8)

### E-01 — Page `/admin/appeals` — file d'attente
- Cards par appel avec : user (anonymisé), cas, point contesté, argument, date
- Statut : pending (orange), approved (vert), rejected (rouge)
- Filtres : par cas, par statut, par admin assigné, par âge

### E-02 — Vue détail appel
- Argument user en grand
- **Contexte** : la réponse complète du user + le point qui a été missed
- Keywords actuels du rubric (le user dit "j'ai dit X qui est synonyme")
- Boutons : Approuver / Rejeter / Demander précision

### E-03 — Workflow d'approbation
**Approuver** :
1. Choisir : ajouter le keyword au rubric / accorder le point sans ajouter / créer un synonyme
2. Saisir message à l'user
3. Confirmation
4. UPDATE cas_pratique_appeals + UPDATE correction_details + INSERT keyword/synonym

**Rejeter** :
1. Saisir motif détaillé
2. Suggestions de cas similaires
3. UPDATE status

### E-04 — Assignment d'appels
- Auto-assign rond-robin entre modérateurs
- Manual reassign
- Indicateur "X appels en attente sur toi"

### E-05 — Templates de réponses
- Réponses-types fréquentes ("Ton argument est juste, le point est validé")
- Variables dynamiques (`{user_first_name}`, `{case_title}`)
- Personnalisation rapide

### E-06 — SLA par appel
- Cible : réponse en <48h
- Alerte rouge si >48h
- Stats SLA par modérateur

### E-07 — Bulk actions
- Approuver/Rejeter en masse les appels similaires
- "Cet argument revient 12 fois sur ce cas → réponse de masse"

### E-08 — Apprentissage auto
- Si X appels approuvés sur le même keyword manquant → suggestion d'ajout au rubric direct
- Notification : "On devrait ajouter 'force proportionnée' au rubric du cas Y"

---

## 🟫 PHASE F — Stats & Analytics (12)

### F-01 — Dashboard cas pratique
KPIs : total cas, publiés, drafts, tentatives totales, success rate global, MRR du module

### F-02 — Stats par cas
- Tentatives totales / dernière semaine / mois
- Success rate avg
- Time spent avg
- Drop-off par question (où les users abandonnent)
- Top keywords missed
- Appels reçus
- Conversion gratuit → premium si premium-only

### F-03 — Graphiques temporels
- Création de cas par mois
- Tentatives par jour
- Success rate trend
- Appels par semaine

### F-04 — Cohortes d'utilisateurs
- "Les users qui ont commencé en janvier ont fait combien de cas ?"
- Retention par cohorte

### F-05 — Funnel de complétion
- Vue cas → start attempt → 50% questions → complete → re-attempt
- Identification des points de friction

### F-06 — Stats par thème
- Quel thème génère le plus d'engagement ?
- Quel a le plus haut success rate ?

### F-07 — Stats par difficulté
- "Le 'difficile' est-il calibré ?"
- Si success rate >70% sur difficile → recalibrer

### F-08 — Comparateur de cas
- Sélectionner 2-5 cas → tableau comparatif
- Aide à identifier les patterns

### F-09 — Stats par admin
- Cas créés par admin
- Vitesse de modération appels par modérateur
- NPS interne

### F-10 — Export reports
- PDF/Excel automatique
- Schedule envoyé par email (hebdo/mensuel)

### F-11 — Intégration PostHog
- Embed dashboards PostHog directement dans `/admin/analytics`

### F-12 — Alertes intelligentes
- "Le success rate du cas X a chuté de 20% cette semaine"
- "5 appels reçus sur le cas Y aujourd'hui"
- Slack/Discord notifications

---

## 🟦 PHASE G — Collaboration (10)

### G-01 — Présence live (qui édite quoi maintenant)
- Avatars en haut à droite des admins en ligne
- Indicateur "X est en train d'éditer ce cas"
- Cursor live (style Figma) — optionnel

### G-02 — Locking optimistic
- Verrou doux : "Y a 2 min Karim a édité ceci, recharger ?"
- Pas de hard lock pour éviter les blocages

### G-03 — Comments threadés
- Sur un cas, sur une question, sur un point de rubric
- Mentions @admin avec notification email/push
- Reactions emoji

### G-04 — Inbox notifications admin
- Page `/admin/inbox` regroupe : mentions, appels assignés, reviews requested
- Mark as read, archive

### G-05 — Review workflow
- Bouton "Demander review" → notification à admin choisi
- Reviewer voit le diff entre dernière publication et version actuelle
- Approuve / Refuse avec commentaires

### G-06 — Live editing same case (style Google Docs)
- Multi-curseurs, synchronisation temps réel via Supabase Realtime
- Conflit gérés via CRDT (yjs ou similaire)

### G-07 — Activity feed par cas
- "Karim a édité Question 2 il y a 5 min"
- "Sophie a ajouté un commentaire"
- "Maxime a publié la v3"

### G-08 — Channels Slack/Discord
- `#cp-edits` : toutes les modifications
- `#cp-appeals` : nouveaux appels
- `#cp-publications` : nouvelles publications

### G-09 — Calendrier d'équipe
- Vue partagée des deadlines de publication
- Assignment des cas à créer
- Targets hebdomadaires

### G-10 — Onboarding nouveau admin
- Tour interactif de toutes les pages
- Checklist : "Ton premier cas créé ✅"
- Doc intégrée contextuelle

---

## 🟫 PHASE H — Import / Export (8)

### H-01 — Export JSON complet d'un cas
- Inclut : cas + questions + rubric + keywords + synonymes
- Format auto-réimportable

### H-02 — Export bulk JSON/CSV
- Sélection multiple + export
- Filtrage par filtres actifs

### H-03 — Import JSON
- Drop d'un fichier
- Validation schéma
- Preview avant import
- Confirmation

### H-04 — Import depuis Word/PDF
- Upload doc, parsing intelligent
- L'admin valide la structure extraite avant import

### H-05 — Sync avec Notion/Airtable
- Webhook bidirectionnel
- Permet à des content writers non-tech d'écrire dans Notion
- Sync auto vers Supabase

### H-06 — Templates Excel pour rubric
- Template avec colonnes prédéfinies (point_label, weight, keywords, synonyms, …)
- Permet à un correcteur expert de fournir une rubric clé en main

### H-07 — Backup auto cloud
- Export tout le module quotidien vers S3
- Restore en 1 click

### H-08 — Migration tools
- "Renommer en masse" (find/replace dans tous les cas)
- "Réorganiser les thèmes" (merge, split)
- "Bumper la difficulté de tous les 2022"

---

## 🟪 PHASE I — Versionning & Workflow (12)

### I-01 — États workflow par cas
- `draft` (édition libre)
- `in_review` (lecture seule pendant review)
- `approved` (prêt à publier)
- `published` (visible app)
- `archived` (retiré du catalogue mais consultable)

### I-02 — Transitions explicites
- Boutons : "Soumettre pour review" / "Approuver" / "Publier" / "Archiver"
- Reasons / commentaires obligatoires sur certaines transitions

### I-03 — Snapshots versionnés
- Chaque publication = snapshot complet en JSONB
- Numérotation v1.0, v1.1, v2.0 (semver)
- Possibilité de rollback en 1 click

### I-04 — Diff visuel entre versions
- Side-by-side ou unified
- Highlight les champs modifiés

### I-05 — Hotfix sur un cas publié
- Possibilité de patcher un cas live sans passer par review
- Audit obligatoire avec justification

### I-06 — Schedule de publication
- Date/heure de publication future
- Cron qui flip automatiquement
- Vue calendrier mensuel

### I-07 — Dépublication temporaire
- Bouton "Mettre hors-ligne 24h"
- Pour gérer un bug urgent sans supprimer

### I-08 — Workflow review obligatoire
- Param : "tous les cas premium doivent passer par 2 reviewers"
- Blocage publication si pas review

### I-09 — Approval pipeline avec assignement
- L'auteur choisit le reviewer
- Reviewer accepte / refuse
- Notif à chaque étape

### I-10 — Statistiques workflow
- Temps moyen draft → published
- Goulets d'étranglement (qui bloque ?)
- Cas en retard (>X jours sans avancée)

### I-11 — Branches expérimentales
- Possibilité de cloner un cas en "branche test"
- A/B test : 50% des users voient v1, 50% v2

### I-12 — Tags de release
- `release-2026-Q3` etc.
- Group de cas publiés ensemble
- Newsletter auto aux users

---

## 🟨 PHASE J — Polish & UX wow effect (14)

### J-01 — Command palette Cmd+K
**Inspiration** : Linear, Notion
- Recherche globale (cas, users, thèmes, code promo, paramètres)
- Actions rapides ("Créer un cas", "Voir mes appels", "Inviter un admin")
- Navigation au clavier

### J-02 — Raccourcis clavier partout
- `?` ouvre la cheatsheet
- `g d` go dashboard
- `g c` go cases
- `n` nouveau cas
- `/` recherche
- `Esc` fermer modal

### J-03 — Dark mode auto + manuel
- Détecte `prefers-color-scheme`
- Override dans settings
- Toutes les charts adaptées

### J-04 — Animations 60fps
- Transitions de page 200ms ease-out
- Skeleton loaders contextuels
- Spinners élégants

### J-05 — Empty states soignés
- Illustrations custom (pas d'emoji bas de gamme)
- Call-to-action utile ("Crée ton premier cas →")

### J-06 — Confirmation patterns
- Destructif : taper le nom + click
- Non-destructif : single click + undo toast 5s

### J-07 — Notifications system
- Toast système avec stack
- Slide-in droite, fade-out
- Action button (undo, voir, etc.)

### J-08 — Help inline
- `?` icon à côté de chaque champ technique
- Tooltip avec exemple
- Lien vers doc complète

### J-09 — Page Help & Docs intégrée
- `/admin/docs` avec FAQ, guides, vidéos
- Search dans la doc
- Feedback "Cette page t'a aidé ?"

### J-10 — Easter eggs subtils
- Konami code → confetti
- Vendredi 17h → "Bon week-end !" en bas
- 100ème cas créé par un admin → trophée perso

### J-11 — Mobile responsive (basique)
- Pas une priorité (l'admin est PC) mais doit fonctionner pour consultation
- Sidebar collapsible
- Touch-friendly

### J-12 — Accessibility WCAG AA
- Contrastes 4.5:1 minimum
- Navigation clavier complète
- Screen reader friendly
- aria-label partout

### J-13 — Sounds (optionnel, toggle)
- Notification "ding"
- Action validée "click satisfaisant"
- Toggle ON/OFF dans settings

### J-14 — Branding cohérent
- Logo COP'IQ partout
- Palette unifiée
- Polices : Montserrat (titres) + Inter (corps)
- Microcopy avec personnalité (pas robotique)

---

## 🎯 TOP 15 prioritaire (à attaquer dans l'ordre)

| Rang | Tâche | Pourquoi |
|---|---|---|
| 1 | A-01/02 — Rôles + auth admin | Bloquant pour tout |
| 2 | A-04 — Audit log auto | Sécurité non négociable |
| 3 | B-01/02 — Page liste cas + filtres | Hub principal |
| 4 | B-06/07 — Création + édition wizard | Coeur du job |
| 5 | C-01/02/03 — Éditeur rubric layout + DnD + add point | LE feature signature |
| 6 | C-08 — Test runner rubric | Game changer qualité |
| 7 | D-01 — Génération IA cas complet | Accélère création 10x |
| 8 | D-04 — Suggestion IA keywords | Précis et utile |
| 9 | E-01/02/03 — Workflow appels complet | Modération critique |
| 10 | F-01/02 — Dashboard + stats par cas | Mesure |
| 11 | I-01/02/03 — Workflow + snapshots | Pro essentiel |
| 12 | J-01 — Cmd+K palette | Productivité massive |
| 13 | B-15 — Templates de cas | Onboarding contenu |
| 14 | G-03/05 — Comments + review workflow | Collaboration |
| 15 | A-06 — MFA obligatoire | Sécurité avant prod |

**Effort TOP 15** : ~15-20 jours solo.

---

## 📐 Métriques de succès

| KPI | Cible 6 mois |
|---|---|
| Temps moyen création d'un cas | < 20 min (vs 2h actuel) |
| Cas créés par mois | 30+ |
| Taux d'erreurs publication | < 1% |
| Temps réponse appel | < 24h (cible 12h) |
| Adoption par les admins | NPS > 50 |
| Uptime panel admin | > 99.9% |
| Time-to-first-case d'un nouveau admin | < 1h |

---

## 🔗 Documents référence

- `docs/cas_pratique/PROGRESSION_CODE.md` — Cas pratique app mobile ✅ 100/100
- `docs/cas_pratique/06_ADMIN_PANEL_SPEC.md` — Spec initiale admin
- `docs/cas_pratique/05_DESIGN_SYSTEM.md` — Design tokens
- `admin/docs/PROGRESSION.md` — Roadmap panel admin global (66 tâches)
- `docs/PROGRESSION_GLOBAL.md` — Roadmap projet complet

---

*Document maintenu en synchronisation. Coche `[x]` chaque tâche au fur et à mesure.*
*Dernière mise à jour : 2026-06-09*
