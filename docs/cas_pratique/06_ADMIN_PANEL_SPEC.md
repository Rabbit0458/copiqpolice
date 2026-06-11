# 🛠️ COP'IQ — Cas Pratique — Spec du Panel Admin

> Le panel admin est **la clé du scaling** vers 100+ cas. Sans lui, chaque cas demande de toucher au code Dart. Avec lui, un cas s'ajoute en **< 5 minutes**.

---

## 1. Cible du panel admin

| Aspect              | Détail                                                              |
|---------------------|---------------------------------------------------------------------|
| Public              | Toi (Kaïs) seul, éventuellement 1-2 collaborateurs admin            |
| Plateforme          | Flutter Web (même codebase) ou page dédiée dans l'app mobile        |
| Authentification    | JWT Supabase avec custom claim `is_admin = true`                    |
| Permissions         | Full CRUD via RLS admin (T020)                                      |
| Public-facing       | NON — URL secrète, pas indexable                                    |

---

## 2. Choix techno : Flutter Web vs page admin in-app

**Recommandation : Flutter Web** (même codebase, déployé sur Netlify ou Vercel).

| Critère                     | Flutter Web              | Page in-app              |
|-----------------------------|--------------------------|--------------------------|
| Effort dev                  | +20 % (responsive)       | +0 %                     |
| UX d'édition longue         | ⭐⭐⭐⭐ (clavier)        | ⭐⭐ (clavier mobile)    |
| Sécurité                    | Domain isolé             | Mélangé app prod         |
| Markdown éditeur            | ⭐⭐⭐⭐                  | ⭐⭐                      |
| Tableurs/grands tableaux    | ⭐⭐⭐⭐⭐                | ⭐                        |
| Notifications real-time     | ⭐⭐⭐⭐                  | ⭐⭐⭐⭐⭐                |

→ **Flutter Web** pour le panel admin, pas dans l'app mobile.

---

## 3. Routes admin

```
/admin/login              → Connexion (avec MFA optionnel)
/admin                    → Dashboard (KPIs, raccourcis)
/admin/cases              → Liste des cas
/admin/cases/new          → Création
/admin/cases/{id}         → Édition (onglets : Infos / Questions / Rubrics / Preview)
/admin/cases/{id}/preview → Mode preview (vue user)
/admin/synonyms           → Dictionnaire de synonymes
/admin/synonyms/{id}      → Édition d'une entrée
/admin/appeals            → Liste des appels à traiter
/admin/appeals/{id}       → Détail + actions
/admin/themes             → Gestion des thèmes
/admin/audit              → Journal d'audit
/admin/users              → Liste users (lecture seule)
/admin/users/{id}         → Stats user (cas faits, scores)
/admin/settings           → Settings admin (engine version, seuils, ...)
```

---

## 4. Pages détaillées

### 4.1. Dashboard

Cards KPIs en grille :
- **Cas publiés** : 8 / 30 (en draft)
- **Tentatives 7 j** : 1 245
- **Score moyen** : 9.4 / 15 (62 %)
- **Appels pending** : 7 (badge urgent rouge si > 5)
- **Users actifs 7 j** : 312
- **Taux de complétion** : 78 %

Graphique :
- Line chart "Tentatives par jour" sur 30 jours
- Top 5 cas les plus échoués (avec lien vers détail)

Quick actions :
- "Nouveau cas"
- "Voir les appels"
- "Audit log récent"

### 4.2. Liste des cas

Table virtualisée (ag-Grid like) :

| Statut    | Titre                          | Année | Thème          | Tentatives | Score moy | Actions    |
|-----------|--------------------------------|-------|----------------|------------|-----------|------------|
| 🟢 Pub    | Cambriolage Xville              | 2024  | Sécurité       | 142        | 11.2      | ✏ ⋮      |
| 🟡 Review | Contrôle identité gare           | 2025  | Cadre légal     | 0          | -         | ✏ 🗑 ⋮  |
| ⚪ Draft  | Refus contrôle alcoolémie        | 2025  | Routier        | 0          | -         | ✏ 🗑 ⋮  |

**Filtres** : statut, thème, année, recherche full-text (utilise T017).
**Tri** : titre, année, tentatives, score moyen.
**Bulk actions** : publier, archiver, dupliquer.

### 4.3. Édition d'un cas

#### Onglet "Infos"

Form avec :
- Titre (required, max 100 chars)
- Slug (auto-généré, éditable)
- Année (number, required)
- Mois (select : Janvier, Février, …)
- Thème (select avec couleur du thème en preview)
- Difficulté (radio : Facile / Moyen / Difficile)
- Durée estimée (number, default 15)
- Total points (number, default 15)
- Statut (radio : Draft / Review / Published / Archived)
- Notes admin (textarea, non visible users)

Sticky bottom : `[Sauvegarder brouillon] [Publier]`

#### Onglet "Mise en situation"

Markdown éditeur double pane (édition / preview) avec :
- Toolbar : H1, H2, bold, italic, ul, ol, quote, link
- Caractère min : 200, recommandé : 800-1500
- Preview live à droite

Stockage :
- `situation_md` (markdown source)
- `situation_text` (rendu plain text pour search trigram)

#### Onglet "Questions"

Liste verticale avec drag-and-drop :

```
[1] Énoncé de la question 1                    [✏] [🗑]
    └─ 4 points dans la rubric
[2] Énoncé de la question 2                    [✏] [🗑]
    └─ 5 points dans la rubric
[3] Énoncé de la question 3                    [✏] [🗑]
    └─ 3 points dans la rubric

[+ Ajouter une question]
```

Tap sur une question → pleine page **Édition Question** :

**Bloc 1 — Énoncé** :
- Label (textarea, required)
- Hint optionnel
- Max points (number, default 5)
- Char min recommandé (number, default 50)
- Char recommandé (number, default 400)

**Bloc 2 — Réponse parfaite** :
- Markdown éditeur
- Section "Références légales" : ajout d'articles cités (ex: 322-1, 78-2…)

**Bloc 3 — Rubric points** :
Liste avec drag-and-drop. Pour chaque point :
- Label (required) — "Qualifier l'infraction"
- Weight (slider 0.5-2.0, step 0.25)
- `is_required` (toggle)
- Kind (radio : core / bonus)
- Explanation (textarea, optionnel — affichée en correction)

Tap sur un point → expand inline avec **les groupes de keywords**.

#### Onglet "Keyword groups & keywords"

Pour chaque point, vue arborescente :

```
🔹 Point 1 : Qualifier l'infraction
  ├─ Groupe 1 : "Vocabulaire dégradation" (description)
  │    ✱ degradation
  │    ✱ degrader (fuzzy 1)
  │    ✱ vandalisme
  │    🔗 @SYN/degrader  (référence dictionnaire)
  ├─ Groupe 2 : "Vocabulaire bien d'autrui"
  │    ✱ autrui
  │    ✱ propriete
  └─ [+ Groupe]

🔹 Point 2 : Préciser les démarches
  ...
```

**Édition d'un keyword** (modal) :
- Type : Littéral / Phrase multi-mots / Référence dictionnaire
- Si Littéral : value (text)
- Si Phrase : value (text), `is_phrase = true`
- Si Référence dict : select dans `synonyms_dictionary` (autocomplete par slug)
- Fuzzy max dist (slider 0-2)
- `is_negation` (toggle, rare)

**Preview match LIVE** :
- Champ "Tester avec une réponse fictive"
- À droite : highlight en vert/rouge par token, score live calculé
- Permet de valider que la rubric matche bien

#### Onglet "Preview"

Affiche le cas comme un user le verrait. Permet de tester le flow avant publication. Aucune persistence dans `attempts`.

### 4.4. Dictionnaire de synonymes

Page liste avec recherche :

| Slug         | Label                       | Termes (count) | Tags                | Used in N keywords |
|--------------|-----------------------------|---------------:|---------------------|-------------------:|
| calmer       | Synonymes de "calmer"        | 12             | deontologie, accueil| 14                 |
| degrader     | Synonymes de "dégrader"      | 18             | atteinte_biens      | 9                  |
| cambriolage  | Synonymes de "cambriolage"   | 7              | atteinte_biens      | 5                  |

Édition d'une entrée :
- Slug (kebab-case, unique)
- Label (libre)
- Termes (chips avec ajout/suppression)
- Tags (chips multi-select)

### 4.5. Liste des appels

Page avec filtres `status` et tri par date :

```
┌─────────────────────────────────────────────────┐
│ 🤔  Appel #142    pending     il y a 2 h        │
│                                                 │
│ User : alice@example.com                        │
│ Cas : "Cambriolage Xville" Q1 P3                │
│                                                 │
│ Point attendu :                                 │
│ "Conseiller la pré-plainte en ligne"            │
│                                                 │
│ Réponse user :                                  │
│ "...je lui propose de remplir le formulaire     │
│  internet pour gagner du temps..."              │
│                                                 │
│ Message user :                                  │
│ "J'ai parlé du formulaire internet, c'est bien  │
│  la pré-plainte en ligne non ?"                 │
│                                                 │
│ [✅ Approuver] [❌ Rejeter] [💬 Demander précis] │
└─────────────────────────────────────────────────┘
```

**Action Approuver** :
- Modal "Quel mot-clé / phrase ajouter ?"
- Pré-rempli intelligemment : extrait de la réponse user qui pourrait matcher
- Sélection du `keyword_group` cible
- Insert keyword avec `auto_added = true`, `appeal_id = ...`
- Update appeal `status = approved`, `created_keyword_id`
- **Recalcul score user** (lance `engine.correctAttempt()` à nouveau)
- Notification user "Bonne nouvelle, ton score est passé à X/15"

**Action Rejeter** :
- Modal avec textarea : motif (template proposé : "Ta réponse ne mentionne pas explicitement…")
- Update appeal `status = rejected`, `admin_response`
- Notification user

**Action Demander précis** :
- Pas un statut nouveau, juste un message au user
- Le user peut éditer son appel et resoumettre

### 4.6. Audit log

Timeline avec filtres :
- Admin
- Action (`create / update / delete / publish / archive / approve_appeal / reject_appeal / add_keyword / add_synonym`)
- Entity (`case / question / rubric_point / keyword / appeal / ...`)
- Plage de dates

Pour chaque entrée :
- Timestamp
- Admin (nom + email)
- Action + entity
- Lien vers l'entité
- Diff JSON (collapsable)

### 4.7. Stats par cas (T091)

Détail d'un cas :
- KPIs : tentatives, complétion, score moyen, médian, distribution
- **Drop-off chart** : combien d'users s'arrêtent à Q1, Q2, Q3
- **Points les plus ratés** : top 5 des `rubric_points` avec status `missing` le plus souvent → signal qu'il faut améliorer la rubric ou clarifier l'énoncé
- **Histogramme score** : combien d'users ont 0-3, 3-6, 6-9, 9-12, 12-15
- **Temps moyen par question**
- **Taux d'appel** : pourcentage de tentatives ayant donné lieu à un appel

---

## 5. Workflow type "ajouter un nouveau cas"

```
1. /admin/cases → "Nouveau cas"
2. Onglet Infos → titre, année, thème, difficulté → Sauvegarder draft
3. Onglet Mise en situation → coller le texte de l'annale (PDF) → preview → sauver
4. Onglet Questions → Ajouter Q1
   ├─ Énoncé Q1 + max_points = 5
   ├─ Réponse parfaite (markdown)
   └─ Rubric : 3-4 points
        ├─ Point 1 : "Qualifier l'infraction"
        │    ├─ Group 1 : keywords littéraux + ref dict
        │    └─ Group 2 : keywords littéraux
        ├─ Point 2 : "..."
        └─ ...
5. Répéter pour Q2, Q3
6. Onglet Preview → tester comme user
7. Bouton Publier → status = published, published_at = now
8. Le cas apparaît automatiquement dans la liste mobile
```

**Cible : 5 minutes par cas** (avec annale PDF déjà préparée).

---

## 6. Sécurité admin

- **JWT custom claim** `is_admin = true` (set via fonction Postgres exécutée manuellement par toi sur ton uid)
- Re-auth pour actions sensibles (suppression cas, publication) : MFA optionnel
- Rate-limiting sur les écritures (Cloudflare ou middleware Edge Function)
- Logs IP + User-Agent dans `cas_pratique_admin_audit`
- Domaine séparé : `admin.copiq.fr` ≠ `app.copiq.fr`
- CSP strict, pas d'iframe, pas d'inline scripts

---

## 7. UX rules

- Sauvegarde **automatique** des drafts (toutes les 30 s + on tab change)
- **Confirmation modale** pour publier / supprimer / archiver
- **Undo toast** sur action destructive (10 s)
- **Keyboard shortcuts** : `Cmd+S` save, `Cmd+P` preview, `Cmd+Shift+P` publish
- **Search palette** (`Cmd+K`) pour naviguer rapidement
- **Dark / light** comme l'app mobile

---

## 8. Roadmap après MVP admin (post-T093)

| Feature                              | Phase    |
|--------------------------------------|----------|
| Importer cas depuis PDF (OCR + IA)   | v2       |
| Suggérer keywords automatiquement    | v2       |
| A/B test entre 2 versions de rubric  | v2       |
| Stats croisées (cas × thème × user)  | v3       |
| Permissions granulaires (rédacteur, validateur) | v3 |
| API publique (autres apps tierces)   | v3       |
