# 🎨 COP'IQ — Cas Pratique — Design System

> Charte UI / UX du module Cas Pratique. Cohérent avec le reste de l'app (palette, typo, animations) mais avec des affinements spécifiques pour cette épreuve qui représente 95 % de la valeur.

---

## 1. Palette

### 1.1. Couleurs primaires (existantes COP'IQ)

| Token            | Hex        | Usage                                     |
|------------------|-----------:|-------------------------------------------|
| `kBlueLight`     | `#1147D9`  | Background light, accents primaires       |
| `kDarkNavy`      | `#000B36`  | Background dark, accents primaires        |
| `kBlueMidLight`  | `#1A55E6`  | Gradient light intermediate                |
| `kBlueDeepLight` | `#0E2F9E`  | Gradient light bottom                     |
| `kDarkNavyMid`   | `#000A33`  | Gradient dark intermediate                |
| `kDarkNavyDeep`  | `#00082D`  | Gradient dark bottom                      |

### 1.2. Couleurs sémantiques (nouvelles, dédiées correction)

| Token            | Light       | Dark        | Usage                          |
|------------------|------------:|------------:|--------------------------------|
| `cSuccess`       | `#22C55E`   | `#34D399`   | Point couvert (vert)           |
| `cSuccessSoft`   | `#DCFCE7`   | `#022C22`   | Background success card        |
| `cWarning`       | `#F59E0B`   | `#FBBF24`   | Point partiel (orange)         |
| `cWarningSoft`   | `#FEF3C7`   | `#451A03`   | Background warning card        |
| `cDanger`        | `#EF4444`   | `#F87171`   | Point manqué (rouge)           |
| `cDangerSoft`    | `#FEE2E2`   | `#450A0A`   | Background danger card         |
| `cInfo`          | `#0EA5E9`   | `#38BDF8`   | Hint, info pédagogique         |
| `cInfoSoft`      | `#E0F2FE`   | `#082F49`   | Background info card           |

### 1.3. Surfaces

| Token              | Light          | Dark           | Usage                            |
|--------------------|---------------:|---------------:|----------------------------------|
| `surface`          | `#FFFFFF`      | `#0B102A`      | Cards, sheets                    |
| `surfaceContainer` | `#F4F6FB`      | `#0F1438`      | Variants élévées                 |
| `surfaceContainerHi` | `#EAEEF7`    | `#13193F`      | Inputs background                |
| `outline`          | `#D5DBE8`      | `#1F2A52`      | Borders                          |
| `outlineVariant`   | `#E7EBF3`      | `#1A2050`      | Borders subtiles                 |
| `onSurface`        | `#0F172A`      | `#F8FAFC`      | Texte primaire                   |
| `onSurfaceMuted`   | `#475569`      | `#94A3B8`      | Texte secondaire                 |
| `onSurfaceFaint`   | `#94A3B8`      | `#64748B`      | Texte tertiaire / placeholder    |

### 1.4. Couleurs par thème (cards de cas)

Chaque thème a sa **couleur principale** + **couleur soft** pour les badges. Référence : seeds dans `03_SCHEMA.sql`.

| Thème             | Couleur principale | Couleur soft (light) | Couleur soft (dark) |
|-------------------|-------------------:|---------------------:|---------------------:|
| Accueil           | `#1147D9`          | `#DBEAFE`            | `#172554`            |
| Déontologie       | `#0EA5E9`          | `#E0F2FE`            | `#0C4A6E`            |
| Cadre légal       | `#22C55E`          | `#DCFCE7`            | `#14532D`            |
| Sécurité publique | `#F59E0B`          | `#FEF3C7`            | `#78350F`            |
| Intervention      | `#EF4444`          | `#FEE2E2`            | `#7F1D1D`            |
| Famille / Mineur  | `#A855F7`          | `#F3E8FF`            | `#581C87`            |
| Sécurité routière | `#06B6D4`          | `#CFFAFE`            | `#164E63`            |

---

## 2. Typographie

**Famille** : `GoogleFonts.montserrat` (cohérent avec le reste).

| Style              | Weight | Size       | Line height | Usage                          |
|--------------------|-------:|-----------:|------------:|--------------------------------|
| Display            | 900    | 28-32      | 1.05        | Titre Hero (intro cas)         |
| Title XL           | 900    | 22         | 1.15        | Titre page                     |
| Title L            | 800    | 18         | 1.20        | Titre section                  |
| Title M            | 800    | 16         | 1.25        | Titre card                     |
| Body L             | 700    | 16         | 1.55        | Texte principal (lecture)      |
| Body M             | 600    | 14         | 1.50        | Texte secondaire               |
| Body S             | 600    | 12.5       | 1.40        | Métadonnées, chips             |
| Mono numérique     | 900    | 36-48      | 1.0         | Score révélé                   |

**Letter spacing** : -0.2 sur titres, 0 sur body, +0.5 sur uppercase tags.

---

## 3. Espacements & rayons

| Token  | Valeur | Usage                                          |
|--------|-------:|------------------------------------------------|
| `s1`   | 4 px   | Padding interne minimal                        |
| `s2`   | 8 px   | Espacement entre éléments inline               |
| `s3`   | 12 px  | Padding cards petites                          |
| `s4`   | 14 px  | Padding cards moyennes                         |
| `s5`   | 16 px  | Padding cards larges                           |
| `s6`   | 20 px  | Padding sections                               |
| `s7`   | 24 px  | Espacement entre sections                      |
| `s8`   | 32 px  | Espacement majeur                              |
| `r1`   | 8 px   | Rayon chips                                    |
| `r2`   | 12 px  | Rayon inputs                                   |
| `r3`   | 16 px  | Rayon cards                                    |
| `r4`   | 18 px  | Rayon cards larges                             |
| `r5`   | 20 px  | Rayon sheets                                   |
| `r6`   | 24 px  | Rayon hero                                     |
| `rPill`| 999 px | Rayon boutons pill                             |

---

## 4. Composants clés (à factoriser dans `lib/core/cas_pratique/widgets/`)

### 4.1. `CasPratiqueScaffold`

Le scaffold immersif avec :
- Gradient background (mode light = bleu, mode dark = navy)
- Halo radial blanc subtil au-dessus du centre
- Vignette douce sur les bords
- Lignes premium en backdrop (existant `_LinesPainter`)
- TopBar transparent avec back pill et titre centré

### 4.2. `CasPratiqueCard`

Card élevée avec :
- `borderRadius: 18`
- `border: 1px outlineVariant`
- `boxShadow: blur(18) y(10) opacity(0.10/0.35)`
- Surface light = blanc / dark = `#0B102A`

### 4.3. `ThemeBadge`

Pill thème :
- Hauteur 28
- Padding horiz 12
- Icon 16 + label
- Background couleur soft du thème
- Texte couleur principale du thème

### 4.4. `DifficultyChip`

3 variants :
- `Facile` : vert
- `Moyen` : bleu
- `Difficile` : orange/rouge

### 4.5. `AnswerTextArea`

```
┌─────────────────────────────────────────────────┐
│  [Compteur 234 / 400]            [☁️ Sauvegardé] │
├─────────────────────────────────────────────────┤
│                                                 │
│  Tape ta réponse ici...                         │
│  (multi-lignes, scrollable)                     │
│                                                 │
└─────────────────────────────────────────────────┘
   ─────── focus border bleu animé ───────
```

- Padding 16
- Font Body L
- Min height 200
- Max height 400 (puis scroll interne)
- Border focus = `kBlueLight` light / `cInfo` dark
- Animation focus : 280ms easeOutCubic

### 4.6. `ScoreReveal`

Centerpiece de la page correction :
- `CircularProgressIndicator` 200 × 200 px
- StrokeWidth 14
- Couleur dynamique : 0-30 % `cDanger`, 30-70 % `cWarning`, 70-100 % `cSuccess`
- Animation : remplissage 0 → score en 1.2 s, courbe `Curves.easeOutCubic`
- Au centre : nombre en Mono 48 + `/{maxPoints}` en Body L muted
- Sous-texte : pourcentage en Title L
- Confettis si percent ≥ 80 % (package `confetti`)

### 4.7. `PointPill`

Pour chaque point dans la correction :
```
┌─────────────────────────────────────────┐
│ ✅  Qualifier l'infraction       │ 1 pt │
└─────────────────────────────────────────┘
```
- 3 variants couleur selon status (covered/partial/missing)
- Tap → expand : description du point + détail des groupes matchés
- Si missing : bouton "Faire appel" en bas

### 4.8. `AppealSheet`

Bottom sheet avec :
- Header : rappel point attendu + ta réponse
- Textarea : "Pourquoi penses-tu que ta réponse est correcte ?"
- Bouton "Envoyer mon appel" (kBlueLight)
- Bouton "Annuler" (ghost)

---

## 5. Animations

| Animation                         | Durée  | Courbe              |
|-----------------------------------|-------:|---------------------|
| Page transition                   | 320 ms | `easeOutCubic`      |
| Bouton press scale                | 120 ms | `easeOut`           |
| Card fade-in                      | 280 ms | `easeOutCubic`      |
| List stagger (card par card)      | +60 ms | `easeOutCubic`      |
| Score reveal                      | 1200 ms| `easeOutCubic`      |
| Confettis                         | 3000 ms| auto                |
| Snackbar / toast                  | 200 ms | `easeOut`           |
| Focus textarea border             | 280 ms | `easeOutCubic`      |
| Auto-save indicator pulse         | 1500 ms| `easeInOutSine` (loop)|
| Accordion expand/collapse         | 240 ms | `easeOutCubic`      |
| Spring (célébrations seulement)   | 600 ms | `elasticOut`        |

**Toujours respecter** :
```dart
final disable = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
```

---

## 6. Haptic feedback

| Action                              | Type                        |
|-------------------------------------|-----------------------------|
| Tap sur card / chip                 | `selectionClick()`          |
| Validation d'une question           | `mediumImpact()`            |
| Reveal du score final               | `heavyImpact()` puis `selectionClick()` × 3 (rythmé) |
| Erreur (réponse vide, save fail)    | `vibrate()` court            |
| Pull-to-refresh trigger             | `selectionClick()`          |
| Bouton "Faire appel" envoyé         | `lightImpact()`             |

---

## 7. États (loading, empty, error)

### 7.1. Loading
- **Skeleton** systématique (jamais spinner brut) :
  - Liste cas : 5 cards skeleton avec gradient shimmer
  - Détail cas : header + texte skeleton
  - Correction : 3 sections skeleton avec barres de progression dégradées

### 7.2. Empty
- **Illustration centrée** (vector inline)
- Titre : ce qui manque
- Sous-titre explicatif
- Bouton CTA pour résoudre

Exemples :
- Liste vide (offline) : "Pas de connexion. Tes cas favoris apparaîtront ici quand tu seras en ligne."
- Aucun résultat de filtre : "Aucun cas trouvé. Essaie avec d'autres filtres."

### 7.3. Error
- **Toast** pour erreurs récupérables (auto-save échoué : "On réessaie automatiquement")
- **Page d'erreur** pour erreurs bloquantes (cas introuvable : "Ce cas n'est plus disponible")

---

## 8. Accessibility

- Contraste **AA minimum** sur tous les textes (vérifié au pixel près)
- `Semantics` labels sur tous les boutons et inputs
- `MediaQuery.disableAnimations` respecté (T107)
- Tailles de touche **≥ 44 × 44 px**
- VoiceOver / TalkBack testés sur les flows clés
- Reduce transparency (iOS) : retirer les blurs, garder les surfaces opaques

---

## 9. Dark / Light auto-switch

- L'app a déjà `AppSettingsController` avec `themeMode.value`
- Aucune page nouvelle ne doit forcer un mode → toujours suivre le `ThemeMode`
- Tester chaque page dans les 3 modes : `ThemeMode.light`, `ThemeMode.dark`, `ThemeMode.system`

---

## 10. Tokens Flutter (à ajouter dans `lib/core/cas_pratique/theme/cas_pratique_theme.dart`)

```dart
class CpTokens {
  // Surfaces
  static const surfaceLight       = Color(0xFFFFFFFF);
  static const surfaceDark        = Color(0xFF0B102A);
  static const surfaceContainerL  = Color(0xFFF4F6FB);
  static const surfaceContainerD  = Color(0xFF0F1438);

  // Sémantiques
  static const success     = Color(0xFF22C55E);
  static const successDark = Color(0xFF34D399);
  static const warning     = Color(0xFFF59E0B);
  static const warningDark = Color(0xFFFBBF24);
  static const danger      = Color(0xFFEF4444);
  static const dangerDark  = Color(0xFFF87171);
  static const info        = Color(0xFF0EA5E9);
  static const infoDark    = Color(0xFF38BDF8);

  // Brand
  static const blueLight  = Color(0xFF1147D9);
  static const darkNavy   = Color(0xFF000B36);

  // Spacings
  static const s1 = 4.0,  s2 = 8.0,  s3 = 12.0, s4 = 14.0;
  static const s5 = 16.0, s6 = 20.0, s7 = 24.0, s8 = 32.0;

  // Radii
  static const r1 = 8.0,  r2 = 12.0, r3 = 16.0, r4 = 18.0;
  static const r5 = 20.0, r6 = 24.0;
  static const rPill = 999.0;
}
```

---

## 11. Mockups texte (ASCII) des pages clés

### 11.1. Liste des cas

```
┌──────────────────────────────────────┐
│ ←  Cas pratiques        [🔍 search]  │
│        Entraînement /15              │
├──────────────────────────────────────┤
│ ┌── Mode concours ────────────────┐  │
│ │ 📋  Lis. Structure. Valide.     │  │
│ │ [Déontologie] [Timing] [Valide] │  │
│ └────────────────────────────────-┘  │
│                                      │
│ Filtres : [Année ▾] [Thème ▾] [⇅]    │
│                                      │
│ ┌─────────────────────────────────┐  │
│ │ 🔵 Cas n°1   [11/15]    [→]    │  │
│ │ Cambriolage en Xville · 2024    │  │
│ │ [⭐ 15 pts]  [⏱ ~15 min]       │  │
│ └─────────────────────────────────┘  │
│                                      │
│ ┌─────────────────────────────────┐  │
│ │ 🔵 Cas n°2  [Nouveau]   [→]    │  │
│ │ Contrôle d'identité · 2025      │  │
│ │ [⭐ 15 pts]  [⏱ ~15 min]       │  │
│ └─────────────────────────────────┘  │
└──────────────────────────────────────┘
```

### 11.2. Page Question

```
┌──────────────────────────────────────┐
│ ←   Question 2 / 3      [📖 Cas]    │
├──────────────────────────────────────┤
│                                      │
│ Question 2                           │
│ Quelles mesures de prévention        │
│ peut-on conseiller à M. BRAVO ?      │
│                                      │
│ ┌─ Ta réponse ──────────────────┐   │
│ │ 234 / 400          ☁️ Sauvé   │   │
│ │                                │   │
│ │ Je conseille à M. BRAVO de     │   │
│ │ s'inscrire à l'opération…      │   │
│ │                                │   │
│ │                                │   │
│ └────────────────────────────────┘   │
│                                      │
│      [ Valider ma réponse ]          │
└──────────────────────────────────────┘
```

### 11.3. Page Correction (reveal)

```
┌──────────────────────────────────────┐
│ ←   Correction                       │
├──────────────────────────────────────┤
│                                      │
│            ⭕  ╲                      │
│           ╱      ╲                    │
│          │   12   │   /15            │
│           ╲      ╱                    │
│            ╲    ╱       80 %          │
│            (confettis !)              │
│                                      │
│ ▼ Question 1   [4/5]                 │
│   ✅ Qualifier l'infraction          │
│   ✅ Préciser les démarches          │
│   🟡 Conseil pré-plainte              │
│   ❌ Mention article 322-1            │
│      [🤔 Faire appel]                │
│                                      │
│ ▶ Question 2   [4/5]                 │
│ ▶ Question 3   [4/5]                 │
│                                      │
│ ┌── Réponse parfaite (Q1) ────────┐  │
│ │ Les faits décrits par M. BRAVO… │  │
│ └─────────────────────────────────┘  │
│                                      │
│      [ Retour à la liste ]           │
└──────────────────────────────────────┘
```

---

## 12. Variantes selon device

| Device         | Adaptations spécifiques                                        |
|----------------|----------------------------------------------------------------|
| iPhone SE      | Padding réduit (s4 au lieu de s5), titres -2 pt                |
| Petits Android | Idem iPhone SE                                                 |
| iPad / tablette| Layout 2 colonnes pour la liste, page Question avec sidebar Cas|
| Foldable       | À ne pas optimiser pour MVP (acceptable si fonctionnel)        |
