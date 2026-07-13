# Tâches manuelles — Pages PA sans équivalent GPX (ou à vérifier)

Ces pages n'ont pas d'équivalent dans la scolarité GPX, ou les pages GPX équivalentes
ne correspondent pas exactement au programme PA. Elles nécessitent un codage manuel.

---

## ✅ DÉJÀ CODÉES MANUELLEMENT

| Page | Dossier PA | Statut |
|------|-----------|--------|
| Organisation judiciaire (structure, juridictions, voies de recours…) | `organisation_judiciaire_pages/` | ✅ 5 pages |
| Agents verbalisateurs (compétences) | `circulation_pages/agents_verbalisateurs_circulation_page.dart` | ✅ |

---

## 🔴 À CODER — Acteurs de la Police Judiciaire (Socle avancé)

**Routes attendues dans home_page_pa_school :**
```
/pa/dps_dpg/socle_avance/acteurs_pj/opj
/pa/dps_dpg/socle_avance/acteurs_pj/apj
/pa/dps_dpg/socle_avance/acteurs_pj/assistants_enquete
/pa/dps_dpg/socle_avance/acteurs_pj/prerogatives
/pa/dps_dpg/socle_avance/acteurs_pj/procureur
/pa/dps_dpg/socle_avance/acteurs_pj/juge_instruction
```

**Dossier de destination** : `lib/content/pa_scolarite/cadres_juridiques_pages/acteurs_pj/` (à créer)

**Source GPX possible** :
- `lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/` → OPJ/APJ pages
- Vérifier : `grep -rn "opj\|OPJ\|APJ\|acteurs" lib/content/gpx_scolarite/ --include="*.dart" | head -20`

**À faire** :
1. Vérifier si des pages GPX couvrent ces sujets (OPJ, APJ, Assistants enquête, etc.)
2. Si oui : copier + adapter + enregistrer les routes
3. Si non : créer les pages de zéro (contenu juridique sur les prérogatives)
4. Ajouter les routes dans `app_router.dart` et imports dans `main.dart`

---

## 🔴 À CODER — Hiérarchie des personnels de la Police Nationale (Socle initial)

**Route attendue** : `/pa/dps_dpg/socle_initial/hierarchie` (CategoryConfig hub seulement)
**SubCategory** : `Hiérarchie des personnels de la Police Nationale` → `/gpx/generalites/hierarchie_intro`

Cette route pointe déjà vers `/gpx/generalites/hierarchie_intro` (GPX route existante).
→ **Vérifier si cette route est déjà enregistrée.** Si oui : ✅ pas d'action.
Si non : ajouter l'alias.

---

## 🔴 À CODER — Immunités et inviolabilités (Socle avancé Généralités)

**Route attendue** : `/pa/dps_dpg/socle_avance/generalites/immunites_inviolabilites`

**Source GPX possible** :
```bash
find lib/content/gpx_scolarite -name "*immunit*" -o -name "*inviolab*"
```
Si la page GPX existe : la copier vers `lib/content/pa_scolarite/dpg_pages/` avec routeName
`/pa/dps_dpg/generalites/immunites_inviolabilites` puis ajouter l'alias dans app_router.

Si elle n'existe pas : créer manuellement une page sur les immunités et inviolabilités
(parlementaires, diplomatiques, etc. — programme PA).

---

## 🔴 À CODER — Abstention volontaire de combattre un sinistre (Socle avancé)

**Route attendue** : `/pa/dps_dpg/socle_avance/atteintes_biens/abstention_sinistre`

**Source GPX possible** :
```bash
find lib/content/gpx_scolarite -name "*sinistre*" -o -name "*abstention*"
```
Si trouvé : copier vers `lib/content/pa_scolarite/atteintes_biens_pages/` + router.
Si non : créer une page dédiée (art. 322-14 CP : abstention de prévenir/éteindre un sinistre).

---

## 🔴 À CODER — Entrave volontaire à l'arrivée des secours (Socle avancé)

**Route attendue** : `/pa/dps_dpg/socle_avance/atteintes_personnes/entrave_secours`

**Source GPX possible** :
```bash
find lib/content/gpx_scolarite -name "*entrave*" -o -name "*secours*"
```
Si trouvé : copier + router.
Si non : créer une page (art. 223-5 à 223-7 CP).

---

## 🔴 À CODER — Outrage sexiste et sexuel (Socle initial Atteintes personnes)

**Route attendue** : `/pa/dps_dpg/socle_initial/atteintes_personnes/outrage_sexiste`

**Source GPX possible** :
```bash
find lib/content/gpx_scolarite -name "*outrage_sexiste*" -o -name "*sexuel*outrage*"
```
Si trouvé : copier vers `pa_scolarite/atteintes_personnes_pages/` + router.
Si non : créer une page (art. 621-1 CP : outrage sexiste).

---

## ⚠️ À VÉRIFIER — Pages avec "image modifiée"

Les pages suivantes ont une image différente dans la scolarité PA vs GPX.
Lors du branchement des routes, vérifier que l'image utilisée dans la `CategoryConfig`
de `home_page_pa_school.dart` est la bonne image PA (pas l'image GPX).

Pages concernées (d'après les annotations du cahier des charges) :
- Violences contre les FSI (`violences_fsi`) — image modifiée
- Le droit pénal — image modifiée
- Immunités et inviolabilités — image modifiée
- La responsabilité pénale — image modifiée
- Tous les acteurs PJ (OPJ, APJ, Assistants, Prérogatives, Procureur, Juge instruction)
- Toutes les atteintes aux biens socle avancé
- Atteintes aux personnes socle avancé (involontaires, menaces, entrave, non obstacle, non assistance)
- Incitation/organisation/promotion (délits routiers)
- Refus d'obtempérer (socle avancé délits routiers)
- Menaces envers dépositaires
- Corruption passive

**Action** : dans `home_page_pa_school.dart`, vérifier que `image:` pointe vers le bon fichier asset.
Ne PAS modifier `home_page_gpx_school.dart`.

---

## ⚠️ À VÉRIFIER — Contrôle d'identité (quiz)

**Route dans home_page_pa_school** :
```
route: '/pa/dps_dpg/socle_initial/controle_identite'
```
La CategoryConfig contrôle identité doit ouvrir le quiz PA contrôle identité :
`lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_controle_identite.dart`

Vérifier que ce quiz est correctement enregistré et que la route de la CategoryConfig
est branchée sur ce quiz (pas sur un quiz GPX).

---

## ⚠️ À VÉRIFIER — Quiz PA pour chaque module

Chaque module du socle initial/avancé doit avoir son quiz PA.
Vérifier dans `lib/content/pa_scolarite/quiz_scolarite_pa/` que les fichiers quiz suivants existent
et sont correctement enregistrés dans `app_router.dart` :

| Module | Fichier quiz PA |
|--------|----------------|
| Atteintes aux biens (socle initial) | `pa_quiz_crimes_delits_bien.dart` |
| Atteintes aux personnes (socle initial) | `pa_quiz_crimes_delits_personne.dart` |
| Atteintes aux personnes — viol/agressions | `pa_quiz_viol_inceste_agressions.dart` |
| Autorité de l'État (socle initial) | `pa_quiz_crimes_delits_nation.dart` |
| Organisation judiciaire | `pa_quiz_juridiction_page.dart` |
| Acteurs PJ | `pa_quiz_hierarchie_page.dart` |
| Atteintes aux biens (socle avancé) | `pa_quiz_crimes_delits_bien.dart` (même quiz) |
| Stupéfiants | `pa_quiz_stupéfiants.dart` |
| Circulation routière | `pa_quiz_circulation_routiere.dart` |

---

## 📋 Ordre de priorité recommandé

1. Appliquer PROMPT_01 (institution_valeurs routes) — le plus simple, 0 page à créer
2. Appliquer PROMPT_02 (socle initial routes) — 1-2 pages manquantes max
3. Appliquer PROMPT_03 (socle avancé routes) — 2-3 pages manquantes
4. Coder les acteurs PJ (6 pages)
5. Coder immunités/inviolabilités, abstention sinistre, entrave secours, outrage sexiste
