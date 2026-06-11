# COP'IQ — Accessibility Audit WCAG AA

> **Statut** : Audit de référence — à re-passer avant chaque release majeure.
> **Référence tâche** : CODE-081 — Phase O Compliance & accessibilité
> **Dernière mise à jour** : 2026-06-05
> **Niveau cible** : WCAG 2.1 AA (+ bonnes pratiques mobile Flutter)

---

## 1. Résumé exécutif

| Domaine | Statut | Priorité |
|---|---|---|
| Contrastes couleurs | 🔴 À vérifier (palette brand) | P0 |
| Labels Semantics Flutter | 🟡 Partiellement implémenté | P1 |
| Tailles cibles tactiles | 🟡 Partiellement (≥ 44px requis) | P1 |
| Navigation clavier | 🔴 Non audité | P1 |
| VoiceOver / TalkBack | 🔴 Non testé | P1 |
| Animations réduites | 🔴 Non implémenté | P2 |
| Captions / sous-titres | ⚪ N/A (app texte) | — |

---

## 2. Critères WCAG 2.1 AA — checklist

### 2.1 Perceptible

#### 1.1 Alternatives textuelles
- [ ] **1.1.1** — Toute image non-décorative a un `Semantics(label: '...')` ou `ExcludeSemantics()` si décorative.
  - `PointPill` : vérifier que les icônes de statut (check, cross, warning) ont un `semanticLabel`.
  - `ScoreReveal` : le score chiffré doit être lisible par TalkBack (`"Votre score : 12 sur 20"`).
  - Avatars / illustrations dans `CasPratiqueScaffold` : ExcludeSemantics si purement décoratifs.

#### 1.3 Adaptabilité
- [ ] **1.3.1** — L'information ne repose pas uniquement sur la couleur.
  - `PointPill` : le statut correct/incorrect est-il communiqué aussi par un label textuel ou icône ? ✅ (icône + couleur)
  - `AppealCard` : statut pending/approved/rejected — vérifier icône + texte (pas seulement couleur).
- [ ] **1.3.4** — L'orientation n'est pas verrouillée (sauf nécessité).
  - Vérifier `SystemChrome.setPreferredOrientations` — si portrait-only, documenter la raison.
- [ ] **1.3.5** — Les champs de formulaire ont un `autofillHints` ou label descriptif.
  - `AnswerTextArea` : `TextField` a-t-il un `decoration.labelText` ou `hintText` lisible ?
  - Page Suppression compte : champ code 6 chiffres → `TextField(decoration: InputDecoration(labelText: 'Code de confirmation'))`.

#### 1.4 Distinguable
- [ ] **1.4.1** — L'info ne repose pas uniquement sur la couleur → voir 1.3.1.
- [ ] **1.4.3** — **Contraste minimum 4.5:1** pour le texte normal, **3:1** pour le grand texte.

**Palette à vérifier (outil recommandé : https://webaim.org/resources/contrastchecker/) :**

| Combinaison | Ratio estimé | Statut |
|---|---|---|
| `#FFFFFF` sur `#1147D9` (bouton primaire light) | 5.9:1 | ✅ |
| `#FFFFFF` sur `#000B36` (surface dark) | 19.1:1 | ✅ |
| `#1147D9` sur `#F5F7FF` (texte brand sur fond clair) | 5.7:1 | ✅ |
| Texte gris clair sur fond dark — **à vérifier** | ❓ | 🔴 |
| `CpTokens.textSecondary` sur `CpTokens.surfaceLight` | ❓ Mesurer | 🔴 |
| Texte placeholder `AnswerTextArea` | ❓ Mesurer | 🔴 |

**Action requise** : Utiliser `lib/core/cas_pratique/theme/cp_tokens.dart` comme source de vérité et mesurer toutes les combinaisons texte/fond avec l'outil WebAIM.

- [ ] **1.4.4** — Le texte peut être agrandi à 200% sans perte de contenu.
  - Flutter respecte `textScaleFactor` du système → vérifier que les layouts ne débordent pas à 200%.
  - `AnswerTextArea` : tester avec `textScaleFactor: 2.0` — le champ reste-t-il accessible ?
- [ ] **1.4.10** — Reflow : pas de scroll horizontal à 320 CSS px (≈ 320dp Flutter).
  - `CasPratiqueListPage` avec filtres chips : vérifier qu'à 320dp de large, les chips wrappent correctement.
- [ ] **1.4.11** — Contraste des composantes non-textuelles (icônes, bordures de champs) ≥ 3:1.

---

### 2.2 Utilisable

#### 2.1 Accessibilité au clavier (Flutter = focus traversal)
- [ ] **2.1.1** — Toutes les fonctionnalités disponibles au clavier (clavier bluetooth connecté ou switch access).
  - `CasPratiqueDynamicPage` : navigation entre questions via Tab → vérifier `FocusTraversalGroup`.
  - Bouton "Valider" : accessible sans tap (Enter/Space quand focused).
  - `AppealSheet` : modal entièrement navigable au clavier (fermeture via ESC = back button).
- [ ] **2.1.2** — Pas de piège au focus (sauf dialogs intentionnels avec focus trap).
  - Les `BottomSheet` des filtres : vérifier que le focus revient sur le bouton déclencheur à la fermeture.

#### 2.3 Convulsions / réactions physiques
- [ ] **2.3.1** — Aucun contenu ne clignote plus de 3 fois/seconde.
  - `ScoreReveal` animation : vérifier fréquence.

#### 2.4 Navigable
- [ ] **2.4.3** — Ordre de focus logique (lecture linéaire = sens de lecture).
  - Vérifier `FocusTraversalOrder` sur `CasPratiqueDynamicPage` : titre → situation → question 1 → réponse 1 → bouton valider → question 2...
- [ ] **2.4.6** — Titres et labels descriptifs.
  - `Scaffold.appBar.title` : utiliser des strings descriptives, pas juste "Cas Pratique".
  - Boutons icon-only : tous doivent avoir `Tooltip(message: '...')` ET `Semantics(label: '...')`.
- [ ] **2.4.7** — Focus visible : l'élément focusé doit être visible (Flutter utilise le `FocusHighlight` système).

#### 2.5 Modalités de saisie
- [ ] **2.5.3** — Le label accessible correspond au label visuel (pour les contrôles activables vocalement).
- [ ] **2.5.5** — **Taille des cibles ≥ 44 × 44 dp.**
  - `PointPill` : vérifier `minHeight`/`minWidth` (si < 44dp, wrapper dans `SizedBox` ou `GestureDetector` avec padding).
  - Boutons icône (back, appel, share) : vérifier taille effective.
  - Chips de filtres : vérifier padding vertical ≥ 10dp pour cible ≥ 44dp.

---

### 2.3 Compréhensible

#### 3.1 Lisible
- [ ] **3.1.1** — La langue de la page est définie.
  - Flutter : `MaterialApp(locale: const Locale('fr', 'FR'))` → ✅ si déjà présent.
  - Vérifier `MaterialApp` dans `main.dart`.

#### 3.2 Prévisible
- [ ] **3.2.1** — Le focus sur un élément ne déclenche pas de changement de contexte automatique.
  - `CasPratiqueListPage` : le debounce de recherche ne doit pas naviguer automatiquement.

#### 3.3 Assistance à la saisie
- [ ] **3.3.1** — Les erreurs de saisie sont identifiées textuellement.
  - `AnswerTextArea` : si `minLength` non atteinte, message d'erreur textuel (pas juste rouge).
  - Page Suppression : champ code 6 chiffres → afficher `"Format invalide — 6 chiffres requis"`.
- [ ] **3.3.2** — Les labels ou instructions sont présents pour les champs de saisie.

---

### 2.4 Robuste

#### 4.1 Compatible
- [ ] **4.1.2** — Nom, rôle, valeur pour tous les composants UI.
  - Les `Switch` dans les paramètres ont-ils un `Semantics(label: '...', toggled: bool)` ?
  - Les `CircularProgressIndicator` ont-ils `Semantics(label: 'Chargement en cours')`?

---

## 3. Flows critiques à tester (VoiceOver iOS / TalkBack Android)

| # | Flow | Actions à tester | Attendu |
|---|---|---|---|
| 1 | Liste des cas | Navigation linéaire dans la liste | Chaque carte annonce titre + thème + difficulté |
| 2 | Filtres | Ouverture du bottom sheet + toggle filtres | "Filtre par année, sélectionné : 2024" |
| 3 | Page cas | Lecture situation + navigation questions | Titre de chaque question annoncé avant le champ |
| 4 | Saisie réponse | AnswerTextArea | "Zone de texte, réponse question 1, vide" ou avec contenu |
| 5 | Validation | Bouton Valider | "Valider, bouton" — activable double-tap VoiceOver |
| 6 | Page correction | PointPill correct/incorrect | "Procédure correcte : 2 points obtenus sur 2" |
| 7 | Appel | Bouton Faire appel | "Faire appel sur ce point, bouton" |
| 8 | Score final | ScoreReveal | Annonce "Votre score : 14 sur 20, soit 70%" |
| 9 | Navigation retour | Back button en haut | Focus retourne sur le dernier élément de la liste |
| 10 | Dialog suppression | 2 dialogs suppression compte | Focus trap dans le dialog, ESC = annuler |

---

## 4. Animations et mouvement réduit

Flutter respecte `MediaQuery.of(context).disableAnimations` (Android "Supprimer les animations") et `MediaQuery.of(context).accessibleNavigation` (iOS "Réduire les animations").

**À implémenter dans les composants animés :**

```dart
// Pattern recommandé
final bool reduceMotion = MediaQuery.of(context).disableAnimations;
final duration = reduceMotion ? Duration.zero : const Duration(milliseconds: 400);

AnimatedContainer(
  duration: duration,
  // ...
)
```

**Composants concernés :**
- `ScoreReveal` — animation de dévoilement
- `CasPratiqueScaffold` — transitions de page
- `AppealSheet` — slide-up
- Toute animation dans `CasPratiqueListPage`

---

## 5. Outils recommandés

| Outil | Usage | Lien |
|---|---|---|
| Flutter Accessibility Inspector | Inspecter l'arbre sémantique Flutter | `flutter run --enable-software-rendering` + DevTools |
| WebAIM Contrast Checker | Vérifier ratios couleur | https://webaim.org/resources/contrastchecker/ |
| Colour Contrast Analyser | App desktop, pipette sur l'écran | https://www.tpgi.com/color-contrast-checker/ |
| VoiceOver (iOS) | Activer dans Réglages > Accessibilité | — |
| TalkBack (Android) | Activer dans Paramètres > Accessibilité | — |
| Switch Access (Android) | Test navigation clavier | — |
| aXe DevTools (web futur) | Audit automatisé HTML | https://www.deque.com/axe/ |

---

## 6. Plan d'action prioritaire

### P0 — Bloquant release (à corriger avant v1.0)
1. Mesurer et corriger les contrastes `CpTokens.textSecondary` sur tous les fonds.
2. Ajouter `Semantics(label: '...')` sur toutes les icônes des boutons action.
3. Vérifier taille 44dp minimum sur `PointPill` et chips filtres.

### P1 — Important UX (à corriger avant v1.1)
4. Implémenter `reduceMotion` dans `ScoreReveal` et `CasPratiqueScaffold`.
5. Tester VoiceOver flow complet (flows 1 à 10 ci-dessus).
6. Ajouter `FocusTraversalOrder` explicite sur `CasPratiqueDynamicPage`.
7. Messages d'erreur textuels dans `AnswerTextArea`.

### P2 — Nice to have (v1.2+)
8. Support `textScaleFactor: 2.0` sans layout overflow.
9. Audit web Next.js avec aXe lors du développement.
10. Tests automatisés accessibilité (flutter_test + `tester.ensureVisible`, semantics).

---

## 7. Commandes Flutter utiles

```bash
# Analyser les warnings d'accessibilité Flutter
flutter analyze

# Lancer avec Accessibility Inspector activé
flutter run --debug

# Générer rapport sémantique (DevTools)
# Dans DevTools > Flutter Inspector > cocher "Show Semantics"

# Vérifier le contrast depuis un screenshot
# (outil externe — Colour Contrast Analyser)
```

---

## 8. Log des corrections effectuées

| Date | Composant | Correction | Développeur |
|---|---|---|---|
| — | — | — | — |

*Ce tableau sera rempli à mesure des corrections.*
