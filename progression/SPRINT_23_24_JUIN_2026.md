# Sprint COP'IQ — Nuit du 23 au 24 juin 2026

## Tâches réalisées

---

### 1. Splash Screen
Conception et développement du splash screen de l'application COP'IQ.

---

### 2. Refonte complète de la page de connexion (`signin.dart`)
Réécriture intégrale avec un design institutionnel premium :
- Image de fond `assets/images/background_login.png` avec overlay dégradé bleu tricolore
- Logo centré, grand titre d'accroche, séparateur tricolore
- Carte blanche avec formulaire de connexion (email, mot de passe, remember me)
- Bouton dégradé avec ombre portée
- Rangée de statistiques et footer fixe avec logo bouclier
- Layout sans scroll `Column(spaceBetween)` + `resizeToAvoidBottomInset: false` pour gérer le clavier
- Logique Supabase, SharedPreferences et AppNotifier préservée
- Adaptation responsive multi-écrans (breakpoints compact / small / normal)

---

### 3. Bottom bar scolarité GPX — bouton changement de catégorie (`home_page_gpx_school.dart`)
- Remplacement du bouton QR code par un bouton grille (`Icons.grid_view_rounded`)
- Navigation vers `GpxSchoolArt` (sélecteur de catégorie)
- Pattern corrigé : `push<GpxSchoolProgram>` + await + `HomePageGpxSchool.program = picked` + `pushAndRemoveUntil`
- Fix bug retour sur mauvaise catégorie après changement de module

---

### 4. Bottom bar scolarité PA — même logique (`home_page_pa_school.dart`)
- Même implémentation que GPX appliquée à la scolarité Policier Adjoint
- Navigation vers `PaSchoolArt` avec `PaSchoolProgram`
- Pattern identique : `push<PaSchoolProgram>` + await + `HomePagePaSchool.program = picked` + `pushAndRemoveUntil`

---

### 5. Module PA — Mémento Circulation Routière
Ajout complet du module Mémento de la Circulation Routière pour la scolarité Policier Adjoint :

**`app_router.dart`** — 26 nouvelles routes `/pa/memento_circulation/...` enregistrées :
- 9 routes Procédures (amende forfaitaire, consignation, immobilisation, mise en fourrière, alcool, stupéfiants, rétention permis, permis à points)
- 6 routes Contrôle routier (cadre légal, permis conduire, BSR, certificat immatriculation, contrôle technique, assurance)
- 11 routes Équipements (pneumatiques, éclairage, chargement, plaques, rétroviseurs, essuie-glace, nuisances, ceinture, casque gants, casque cycliste, gilet haute visibilité)
- Réutilisation des mêmes widgets de contenu que GPX (aucune duplication)

**`home_page_pa_school.dart`** — `PaSchoolProgram.mememtoCirculationRoutiere` ajouté avec 3 catégories :
- Procédures circulation routière (9 fiches + quiz PA)
- Contrôle routier & pièces (6 fiches + quiz PA)
- Équipements véhicules & usagers (11 fiches + quiz PA)
- Quiz trackés sur le grade `pa` via `/pa/infraction_circulation_routière_pages/quiz/pa_quiz_circulation_routiere`

---

## Bugs corrigés

| Bug | Cause | Fix |
|-----|-------|-----|
| `RenderFlex overflowed by 36px` | Contenu > hauteur disponible | Breakpoints `compact/small/normal` + `Column(spaceBetween)` |
| `RenderFlex overflowed by 223px` (clavier ouvert) | Clavier compresse le layout | `resizeToAvoidBottomInset: false` |
| Footer coupé en bas | Row sans `crossAxisAlignment` | `CrossAxisAlignment.center` + icône 22px |
| Carte blanche tronquée | `Expanded` + scroll englobait le footer | Footer sorti du scroll, layout pur `Column` |
| Mauvaise catégorie après changement de module GPX | `pushNamed` retournait sur l'ancienne instance | `push<T>` + await + `pushAndRemoveUntil` |
| `undefined_identifier: GpxSchoolArt` | Import `show` incomplet | Ajout `GpxSchoolArt` dans la clause `show` |
| `equal_keys_in_map` dans `app_router.dart` | Route `PvIpmRemiseTiersPage` dupliquée | Suppression de la ligne en double |
