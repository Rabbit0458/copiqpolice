# 🎯 COP'IQ — Cas Pratique GPX — Master Plan

> Le module **Cas Pratique** = **95 % de la valeur** de COP'IQ. C'est la raison pour laquelle l'utilisateur télécharge l'app. Ce fichier est la **bible stratégique** : pourquoi, quoi, comment.

---

## 📊 1. CONSTAT MÉTIER

Le concours **Gardien de la Paix** comporte une épreuve de **cas pratique** notée sur **15 points** avec **coefficient élevé**. Dans la vie réelle, un policier examinateur lit la copie et juge la qualité de la réponse, en tenant compte des nuances de formulation.

Sur COP'IQ, **tout doit être automatisé**. Or 10 utilisateurs = 10 formulations différentes pour la même réponse correcte. Le risque : marquer une bonne réponse comme fausse parce qu'elle est écrite différemment de ce qui est attendu.

**Notre mission** : approcher la qualité d'un correcteur humain **sans IA externe**, de manière **déterministe**, **rapide**, **scalable** sur 100+ cas.

---

## 🧠 2. PHILOSOPHIE DU MOTEUR DE CORRECTION

### 2.1. Anti-pattern : LLM en ligne pour chaque correction
- **Coût** : ~ $0.003 par correction × 100k corrections / mois = $300/mois minimum
- **Latence** : 2-8 s par appel = UX cassée
- **Non-déterministe** : 2 corrections du même texte peuvent diverger
- **Dépendance externe** : si l'API tombe, tout le module est mort

### 2.2. Notre approche : Rubric + Synonymes + Fuzzy + Filet de sécurité

**Pour chaque question** on définit une **grille de correction** (rubric). La rubric est composée de **points attendus**. Chaque point est validé si la réponse de l'utilisateur contient les éléments attendus, exprimés en groupes de mots-clés (logique ET entre groupes, OR à l'intérieur).

**Améliorations clés vs le système actuel hardcodé** :

| Élément                        | Système actuel                     | Nouveau système                                            |
|--------------------------------|------------------------------------|------------------------------------------------------------|
| Stockage rubrics               | Hardcodé en Dart                   | Base de données Supabase                                  |
| Synonymes                      | Répétés dans chaque rubric         | **Dictionnaire mutualisé** réutilisable                   |
| Fautes de frappe               | Non gérées                         | **Fuzzy matching** Levenshtein (distance ≤ 2)             |
| Expressions multi-mots         | Non gérées                         | **N-grams** (bigrams/trigrams)                            |
| Pondération                    | Tous égaux                         | `weight` + `is_required` par point                        |
| Négation                       | Non détectée                       | **Negation detector** (fenêtre 5 tokens)                  |
| Lemmatisation                  | Non                                | Lemmatiseur FR léger (suffixes courants)                  |
| Apprentissage                  | Aucun                              | **Système de signalement** : user → admin → auto-keyword  |
| Ajout de cas                   | Créer un fichier Dart              | Panel admin : 5 minutes par cas                           |

### 2.3. Le filet de sécurité : système d'appel

Quand un user pense que sa réponse est correcte mais qu'elle a été marquée "manquée", il clique **"Faire appel"**. Sa demande arrive sur ton panel admin. En 1 clic tu peux :
- **Approuver** → le mot-clé manquant est **automatiquement ajouté** au keyword group → le score user est recalculé → la prochaine fois c'est pris en compte
- **Rejeter** avec motif → le user voit pourquoi sa réponse n'était pas conforme

**Conséquence** : le système **s'améliore en continu** sans toi avoir à coder.

---

## 🏗️ 3. ARCHITECTURE GÉNÉRALE

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  📱 FLUTTER APP (mobile)                                         │
│  ┌────────────────────┐    ┌────────────────────────────────┐   │
│  │ Liste cas (dyn)    │───▶│ Page cas dynamique             │   │
│  │ - Filtres          │    │ - Intro                        │   │
│  │ - Recherche        │    │ - Texte                        │   │
│  │ - Stats user       │    │ - Questions                    │   │
│  └────────────────────┘    │ - Correction                   │   │
│           │                │ - Appel                        │   │
│           │                └────────────────────────────────┘   │
│           │                              │                       │
│           ▼                              ▼                       │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ Cas Pratique Repository (Dart)                          │    │
│  │ + Cache local (Hive)                                    │    │
│  │ + Correction Engine (offline-capable)                   │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                   │
└──────────────────────────────┼───────────────────────────────────┘
                               │
                               ▼ (HTTPS / Supabase SDK)
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  🗄️ SUPABASE (Postgres + Auth + Realtime + Storage)              │
│                                                                  │
│  ┌─ Tables (15) ──────────────────────────────────────────┐     │
│  │ themes, cases, questions, perfect_answers,             │     │
│  │ rubric_points, keyword_groups, keywords,               │     │
│  │ synonyms_dictionary, attempts, answers,                │     │
│  │ corrections, correction_details, appeals,              │     │
│  │ user_progress, admin_audit                             │     │
│  └────────────────────────────────────────────────────────┘     │
│                                                                  │
│  RLS : user voit ses propres données                             │
│  RLS : admin (JWT claim is_admin) full access                    │
│  Triggers : update_user_progress après chaque correction         │
│  Realtime : notif admin sur nouvel appel                         │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
                               ▲
                               │
┌──────────────────────────────┴───────────────────────────────────┐
│                                                                  │
│  🛠️ PANEL ADMIN (Flutter web ou page admin dans l'app)            │
│  ┌────────────────────────────────────────────────────────┐     │
│  │ Dashboard KPIs                                         │     │
│  │ CRUD Cas / Questions / Rubrics / Keywords / Synonymes  │     │
│  │ Liste appels à traiter                                 │     │
│  │ Audit log                                              │     │
│  └────────────────────────────────────────────────────────┘     │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 🔄 4. FLOW UTILISATEUR

```
[Liste des cas]
  │
  ├─ Filtres : Année / Thème / Difficulté
  ├─ Recherche
  └─ Card par cas : titre, année, thème, ETA, badge "Nouveau", score précédent
       │
       ▼ (tap)
[Cas n°N — Intro]
  │  Hero : titre cinéma + badge thème + ETA + difficulté
  │  3 puces : "Lecture scénario / Structure / Correction expliquée"
  │  CTA "Lire le scénario"
       │
       ▼
[Texte du cas — lecture immersive]
  │  Mise en situation pleine page
  │  Reading mode (line-height 1.6, max-width)
  │  Bouton "Je commence" en sticky bottom
       │
       ▼
[Question 1 / N]   ◄─────────────────────────┐
  │  Énoncé en haut                          │
  │  Textarea premium                         │
  │  Compteur caractères + recommandation     │
  │  Auto-save indicator (cloud icon pulse)  │
  │  Bouton "Valider"                         │
       │                                      │
       ▼ (Valider)                            │
[Sauvegarde Supabase — answers]              │
       │                                      │
       ▼                                      │
[Question 2 / N] ──► [Question N] ────────────┘
       │
       ▼
[Lancement correction — engine local]
       │
       ▼
[Page Correction]
  │  Animation : score révélé (CircularProgress + nombre qui scrolle)
  │  Confettis si ≥ 80%
  │  Score total /15 + pourcentage
  │  Accordion par question :
  │    ✅ Points couverts (vert)
  │    ❌ Points manqués (rouge) avec "Faire appel"
  │    🟡 Points partiels (orange)
  │  Réponse parfaite révélée en bas
  │  Bouton "Retour à la liste"
       │
       ▼
[Stats user mises à jour : avg_score, last_attempt, etc.]
```

---

## 🎨 5. PRINCIPES DESIGN

- **Palette COP'IQ** : `#1147D9` (blue-light), `#000B36` (dark-navy)
- **Typo** : Montserrat (cohérence avec le reste de l'app)
- **Dark mode** : background `#000B36` → `#000A33` → `#00082D` (gradient), cards `#0B102A`
- **Light mode** : background `#1147D9` → `#1A55E6` → `#0E2F9E` (gradient), cards blancs
- **Couleurs sémantiques** : vert `#22C55E` (couvert), rouge `#EF4444` (manqué), orange `#F59E0B` (partiel)
- **Animations** : spring physics, durée 280-320 ms, courbe `easeOutCubic`
- **Haptic feedback** : à chaque validation, à chaque révélation de score
- **Reduce motion** : toujours respecté (accessibility)

---

## 📦 6. PLAN D'EXÉCUTION (110 tâches)

Voir `02_TASKS.md` pour la checklist détaillée.

**Ordre recommandé** :
1. **Phase 1** (DB) — fondations, indispensable
2. **Phase 3** (moteur) — peut être fait en parallèle
3. **Phase 2** (migration) — alimente la DB avec les 6 cas legacy
4. **Phase 4** (page dynamique) — remplace les 6 fichiers Dart
5. **Phase 5** (liste dynamique)
6. **Phase 8** (design premium) — en parallèle de 4-5
7. **Phase 7** (admin) — pour scaler vers 100+ cas
8. **Phase 6** (signalement)
9. **Phase 9** (perf/UX) — finitions

---

## ✅ 7. CRITÈRES DE SUCCÈS

- [ ] Un cas peut être ajouté en **< 5 min** depuis le panel admin (vs ~2h actuellement)
- [ ] Une réponse formulée différemment mais correcte est acceptée dans **≥ 90 % des cas** (vs ~60 % actuel)
- [ ] La correction d'un cas se fait en **< 100 ms** sur mobile entry-level
- [ ] Le système d'appel produit un **gain de précision automatique** (≥ 1 keyword ajouté / semaine en moyenne)
- [ ] **Dark/Light** parfaitement supportés sur toutes les pages
- [ ] Aucun cas hardcodé restant après T060
