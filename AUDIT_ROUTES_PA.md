# Audit complet des routes — Application CopiqPolice
*Généré le 16 juin 2026 — Analyse statique Flutter/Dart*

---

## Résumé exécutif

| Indicateur | Valeur |
|---|---|
| Routes disponibles dans app_router | **1 397** (447 littérales + 1 325 via `.routeName`, union) |
| Configs analysées | 4 (PA_SCHOOL, GPX_SCHOOL, PA_EXAM, GPX_EXAM) |
| Routes hub/parent (OK, pas besoin d'enregistrement) | **~51** |
| Pages inexistantes à créer | **~67** |
| Targets de redirection cassées (bug pré-existant) | **90** |

---

## 1. app_router.dart — Registre des routes

**Fichier :** `lib/routes/app_router.dart`

- **447 routes littérales** enregistrées directement sous forme de chaînes
- **1 325 routes via `.routeName`** — chaque page déclare `static const String routeName = '...'` et est enregistrée via `ClassName.routeName: (_) => const ClassName()`
- **1 397 routes uniques** après union (certains recoupements entre les deux modes)
- `appOnGenerateRoute` gère le fallback vers `RouteRegistry.routes`
- Section alias DPS/DPG PA scolarité : ligne ~2639 (56 alias ajoutés en session précédente)

**Statut : ✅ Registre sain — 0 doublon détecté**

---

## 2. PA_SCHOOL — `home_page_pa_school.dart`

**Résumé :** 327 routes dans la config, 94 clés dans `redirectConfig`.

### 2.1 Routes de navigation directe

| Catégorie | Statut | Détail |
|---|---|---|
| Routes DPS/DPG GPX scolarité | ✅ OK | Enregistrées via `.routeName` (1325 routes) |
| `/home-pa-school` | ✅ OK | Trouvée via `.routeName` hors `lib/content/` |
| Routes intervention, institution GPX | ✅ OK | Enregistrées |

### 2.2 Routes PA sans pages (❌ à créer)

Ces routes apparaissent dans la config PA_SCHOOL mais aucune page Flutter n'existe :

**`/pa/dps_dpg/socle_initial/*` — 9 routes :**
- `/pa/dps_dpg/socle_initial/atteintes_biens`
- `/pa/dps_dpg/socle_initial/atteintes_personnes`
- `/pa/dps_dpg/socle_initial/autorite_etat`
- `/pa/dps_dpg/socle_initial/cadres_juridiques`
- `/pa/dps_dpg/socle_initial/circulation`
- `/pa/dps_dpg/socle_initial/controle_identite`
- `/pa/dps_dpg/socle_initial/generalites`
- `/pa/dps_dpg/socle_initial/hierarchie`
- `/pa/dps_dpg/socle_initial/organisation_judiciaire`

**`/pa/dps_dpg/socle_avance/*` — 7 routes :**
- `/pa/dps_dpg/socle_avance/acteurs_pj`
- `/pa/dps_dpg/socle_avance/atteintes_biens`
- `/pa/dps_dpg/socle_avance/atteintes_personnes`
- `/pa/dps_dpg/socle_avance/autorite_etat`
- `/pa/dps_dpg/socle_avance/delits_routiers`
- `/pa/dps_dpg/socle_avance/generalites`
- `/pa/dps_dpg/socle_avance/stupefiants`

**`/pa/institution/*` — 7 routes :**
- `/pa/institution/accueil_public`
- `/pa/institution/deontologie`
- `/pa/institution/formation_initiale`
- `/pa/institution/hierarchie_info`
- `/pa/institution/histoire`
- `/pa/institution/laicite`
- `/pa/institution/organisation_pn`

### 2.3 Bug pré-existant : redirectConfig cassé — 90 targets invalides

**Fichier :** `home_page_pa_school.dart`, ligne ~4103
**`const Map<String, String> redirectConfig` — 94 entrées**

**Problème 1 — Accent é/e (83 targets) :**
Les clés redirectent vers des URLs avec accent (`/gpx_scolarité_pages/...`) mais les `routeName` réels des pages utilisent `scolarite` sans accent (`/gpx_scolarite_pages/...`). Résultat : `pushNamed` échoue silencieusement → page inconnue.

Exemples de targets cassées :
```
/gpx_scolarité_pages/armes_munitions_pages              ← é au lieu de e
/gpx_scolarité_pages/droit_pénale_général_pages         ← é, é, é
/gpx_scolarité_pages/libertés_publiques_pages           ← é
/gpx_scolarité_pages/stupéfiants_pages                  ← é
/gpx_scolarité_pages/infraction_circulation_routière_pages ← è
```

**Problème 2 — Targets hub non-navigables (7 targets) :**
Ces cibles sont des routes parent qui ouvrent des bottom sheets via la config, elles ne sont pas pushNamed-ables :
- `/gpx/generalites/cadre_legal_armes`
- `/gpx/generalites/complicite`
- `/gpx/generalites/legitime_defense`
- `/gpx/generalites/libertes_publiques`
- `/gpx/generalites/retention_locaux_police`
- `/gpx/generalites/tentative_punissable`
- `/gpx_scolarite_pages/generalite_pages`

**Impact :** Tout utilisateur PA qui tente de naviguer vers une ancienne route PA sera redirigé vers une route GPX inexistante → écran vide ou 404.

**Action recommandée :** Corriger les 83 targets en retirant les accents (`scolarité` → `scolarite`, `pénale` → `penale`, `général` → `general`, `libertés` → `libertes`, `stupéfiants` → `stupefiants`, `routière` → `routiere`). Les 7 targets hub doivent pointer vers une sous-page feuille valide ou être supprimées.

---

## 3. GPX_SCHOOL — `home_page_gpx_school.dart`

**Résumé :** 377 routes dans la config, `redirectConfig` vide (1 seule entrée commentée).

### 3.1 Routes hub/parent — ✅ OK (pas d'enregistrement nécessaire)

Ces routes ouvrent un bottom sheet ou un panneau de sous-catégories via la config, elles ne sont pas des destinations `pushNamed` :

**39 routes hub**, dont :
- `/gpx/pv_apj20/introduction`, `/gpx/pv_apj20/interpellation`, `/gpx/pv_apj20/plainte`…
- `/gpx/pv_apj20/audition_suspect`, `/gpx/pv_apj20/circulation_routiere`…
- `/gpx/memento_circulation/natinf`, `/gpx/ton_vrai_module`…
- `/gpx_scolarite_pages/armes_munitions_pages`, `/gpx_scolarite_pages/cadres_juridiques_pages`… (12 catégories hub)

**Statut : ✅ Comportement attendu — pas de page à créer**

### 3.2 Dimension humaine — ❌ 18 routes sans pages

Le dossier `lib/content/dimension_humaine/` est vide ou inexistant. Aucune page Flutter n'existe pour ces routes :

**Hub :**
- `/gpx/dimension_humaine/communication`
- `/gpx/dimension_humaine/ethique`
- `/gpx/dimension_humaine/stress`

**Feuilles communication :**
- `/gpx/dimension_humaine/communication/dh1_fonctionnement`
- `/gpx/dimension_humaine/communication/dh3_strategies_public`
- `/gpx/dimension_humaine/communication/dh4_coordination_equipes`
- `/gpx/dimension_humaine/communication/adh2_posture_victime`
- `/gpx/dimension_humaine/communication/s3_2_violences_intrafamiliales`
- `/gpx/dimension_humaine/communication/quiz`

**Feuilles éthique :**
- `/gpx/dimension_humaine/ethique/adh1_facultes_mentales`
- `/gpx/dimension_humaine/ethique/adh4_violences_sexuelles_sexistes`
- `/gpx/dimension_humaine/ethique/adh6_confrontation_mort`
- `/gpx/dimension_humaine/ethique/quiz`

**Feuilles stress :**
- `/gpx/dimension_humaine/stress/dh2_stress`
- `/gpx/dimension_humaine/stress/dh2_carnet_ressources`
- `/gpx/dimension_humaine/stress/adh9_agressivite`
- `/gpx/dimension_humaine/stress/ac6_conduites_suicidaires`
- `/gpx/dimension_humaine/stress/quiz`

### 3.3 Pages quiz manquantes — ❌ 12 routes

Ces routes de quiz apparaissent dans la config mais aucune page quiz n'existe :

| Route quiz | Module parent |
|---|---|
| `/gpx/intervention/etrangers/quiz` | Intervention étrangers |
| `/gpx/intervention/animal/quiz` | Intervention animal |
| `/gpx/intervention/accident-circulation/quiz` | Accident circulation |
| `/gpx/intervention/stupefiants/quiz` | Stupéfiants |
| `/gpx/intervention/debit-boissons/quiz` | Débit de boissons |
| `/gpx/intervention/malades-mentaux/quiz` | Malades mentaux |
| `/gpx/intervention/mineurs/quiz` | Mineurs |
| `/gpx/intervention/autres/quiz` | Autres interventions |
| `/gpx/memento_circulation/procedures/quiz` | Procédures circulation |
| `/gpx/memento_circulation/controle_routier/quiz` | Contrôle routier |
| `/gpx/memento_circulation/equipements/quiz` | Équipements |
| `/gpx/institution/laicite/quiz` | Laïcité institution |

### 3.4 Pages institution GPX manquantes — ❌ 7 routes

| Route | Statut |
|---|---|
| `/gpx/institution/accueil_public` | ❌ Pas de page |
| `/gpx/institution/deontologie` | ❌ Pas de page |
| `/gpx/institution/formation_initiale` | ❌ Pas de page |
| `/gpx/institution/hierarchie_info` | ❌ Pas de page |
| `/gpx/institution/histoire` | ❌ Pas de page |
| `/gpx/institution/laicite` | ❌ Pas de page |
| `/pa/institution/organisation_pn` | ❌ Pas de page (référencée aussi dans GPX) |

### 3.5 Routes intervention hub — ✅ OK

Ces routes ouvrent un bottom sheet vers les sous-pages :
- `/gpx/intervention/accident-circulation`, `/gpx/intervention/animal`, `/gpx/intervention/autres`
- `/gpx/intervention/debit-boissons`, `/gpx/intervention/domicile`, `/gpx/intervention/etrangers`
- `/gpx/intervention/formulaires-utiles`, `/gpx/intervention/malades-mentaux`
- `/gpx/intervention/mineurs`, `/gpx/intervention/patrouille`
- `/gpx/intervention/prise-service`, `/gpx/intervention/stupefiants`
- `/gpx/memento_circulation/controle_routier`, `/gpx/memento_circulation/equipements`
- `/gpx/memento_circulation/procedures`

---

## 4. PA_EXAM — `home_page_pa_exam.dart`

**Résumé :** 35 routes dans la config — **34 pages inexistantes**.

Aucune page de contenu concours PA n'a encore été créée. Toutes ces routes pointent vers du contenu futur :

### 4.1 Épreuves (3 routes)
- `/pa_exam/concours/epreuves`
- `/pa_exam/concours/epreuves/tableau`
- `/pa_exam/concours/epreuves/visite_medicale_enquete`

### 4.2 Étude de texte (5 routes)
- `/pa_exam/concours/etude_texte`
- `/pa_exam/concours/etude_texte/methodologie`
- `/pa_exam/concours/etude_texte/fiches_de_cours`
- `/pa_exam/concours/etude_texte/entrainements_exercices`
- `/pa_exam/concours/etude_texte/entrainements_corriges`
- `/pa_exam/concours/etude_texte/entrainements_qcm`

### 4.3 Français (4 routes)
- `/pa_exam/concours/francais`
- `/pa_exam/concours/francais/fiches_de_cours`
- `/pa_exam/concours/francais/entrainements_exercices`
- `/pa_exam/concours/francais/entrainements_corriges`
- `/pa_exam/concours/francais/entrainements_qcm`

### 4.4 Connaissances générales (4 routes)
- `/pa_exam/concours/connaissances_generales`
- `/pa_exam/concours/connaissances_generales/fiches_de_cours`
- `/pa_exam/concours/connaissances_generales/entrainements_exercices`
- `/pa_exam/concours/connaissances_generales/entrainements_corriges`
- `/pa_exam/concours/connaissances_generales/entrainements_qcm`

### 4.5 Photolangage (3 routes)
- `/pa_exam/concours/photolangage`
- `/pa_exam/concours/photolangage/etapes_reussite`
- `/pa_exam/concours/photolangage/analyse`
- `/pa_exam/concours/photolangage/entrainements`

### 4.6 Tests psychotechniques (7 routes)
- `/pa_exam/concours/tests_psychotechniques`
- `/pa_exam/concours/tests_psy/analyse`
- `/pa_exam/concours/tests_psy/aptitude_verbale`
- `/pa_exam/concours/tests_psy/raisonnement_logique`
- `/pa_exam/concours/tests_psy/observation_attention`
- `/pa_exam/concours/tests_psy/personnalite`
- `/pa_exam/concours/tests_psy/entrainements_exercices`
- `/pa_exam/concours/tests_psy/entrainements_corriges`
- `/pa_exam/concours/tests_psy/entrainements_qcm`

### 4.7 Pages scolarité PA (2 routes)
- `/pa_scolarité_pages/cadres_juridiques`
- `/pa_scolarité_pages/procedure_penale/pp_gav`

---

## 5. GPX_EXAM — `home_page_gpx_exam.dart`

**Résumé :** 42 routes dans la config — **16 pages/routes manquantes**.

### 5.1 Routes utilitaires app (2 routes)
- `/abonnement` — page abonnement
- `/subscription` — page subscription (alias ?)

Ces routes peuvent nécessiter une page générique ou rediriger vers l'écran d'achat in-app.

### 5.2 Épreuves GPX (1 route)
- `/gpx_exam/concours/epreuves_gpx`

### 5.3 Culture générale (3 routes)
- `/gpx_exam/concours/culture_generale`
- `/gpx_exam/concours/culture_generale_` *(trailing underscore — probablement bug de nommage)*
- `/gpx_exam/concours/culture_generale_langue`

### 5.4 Langue étrangère (2 routes)
- `/gpx_exam/concours/langue_etrangere`
- `/gpx_exam/concours/langue_etrangere/exemples_` *(trailing underscore — probablement bug de nommage)*

### 5.5 Tests psychotechniques GPX (7 routes)
- `/gpx_exam/concours/tests_psychotechniques`
- `/gpx_exam/concours/tests_psychotechniques/` *(trailing slash — probablement bug)*
- `/gpx_exam/concours/tests_psychotechniques/comprendre_epreuve`
- `/gpx_exam/concours/tests_psychotechniques/mode_concours`
- `/gpx_exam/concours/tests_psychotechniques/calcul_mental`
- `/gpx_exam/concours/tests_psychotechniques/rotations`
- `/gpx_exam/concours/tests_psychotechniques/spatial`

### 5.6 Cas pratique (1 route)
- `/gpx_exam/concours/cas_pratique/` *(trailing slash — probablement bug)*

---

## 6. Tableau de bord — Bilan global

### Routes à créer par priorité

| Priorité | Module | Nb routes | Config concernée |
|---|---|---|---|
| 🔴 Haute | PA DPS/DPG socle initial/avancé | 16 | PA_SCHOOL |
| 🔴 Haute | PA Institution | 7 | PA_SCHOOL |
| 🔴 Haute | GPX Institution (sous-pages) | 7 | GPX_SCHOOL |
| 🟠 Moyenne | GPX Dimension humaine | 18 | GPX_SCHOOL |
| 🟠 Moyenne | Quiz intervention & mémento | 12 | GPX_SCHOOL |
| 🟡 Basse | PA_EXAM contenu concours | ~34 | PA_EXAM |
| 🟡 Basse | GPX_EXAM contenu concours | ~14 | GPX_EXAM |
| ⚪ Utilitaire | Abonnement / subscription | 2 | GPX_EXAM |

**Total pages à créer : ~110**

### Bugs à corriger

| Bug | Fichier | Gravité | Action |
|---|---|---|---|
| 83 redirect targets avec accent é | `home_page_pa_school.dart` redirectConfig | 🔴 Critique | Remplacer `é→e`, `è→e` dans les VALUES du map |
| 7 redirect targets vers routes hub | `home_page_pa_school.dart` redirectConfig | 🔴 Critique | Choisir une sous-page feuille valide ou supprimer l'entrée |
| Routes exam avec trailing slash/underscore | `home_page_gpx_exam.dart` | 🟠 Moyen | Normaliser les noms de routes |

### Ce qui fonctionne correctement ✅

- **1 397 routes uniques** disponibles dans l'app_router — aucun doublon
- **Toutes les pages DPS/DPG GPX scolarité** sont accessibles (crimes, sanctions, stupéfiants, armes, etc.)
- **Toutes les pages intervention GPX** feuilles sont accessibles (alertes-à-la-bombe, violation-bar, IPM, plans ORSEC, contrôle débits boissons, etc.)
- **Toutes les pages PV APJ20** sont accessibles
- **Les pages quiz DPS/DPG** (quiz armes, quiz procédure, quiz crime, etc.) sont accessibles
- **Le système de redirection** est architecturalement correct — seuls les targets sont cassés

---

## 7. Notes techniques

### Comment est calculée la disponibilité d'une route

Une route est considérée **disponible** si elle apparaît dans l'une des deux sources :
1. Enregistrée littéralement dans `RouteRegistry.routes` de `app_router.dart` sous forme `'/chemin/route': (_) => const MaPage()`
2. Déclarée via `static const String routeName = '/chemin/route'` dans une classe page ET enregistrée via `MaPage.routeName: (_) => const MaPage()`

### Méthode d'analyse

- Scan Python statique des fichiers `.dart` via `grep`
- Extraction des littéraux route dans `app_router.dart` : regex `'(/[^']+)':`
- Extraction des `.routeName` : scan `static const String routeName` sur la même ligne ET la ligne suivante (fix nécessaire — les déclarations mono-ligne étaient manquées)
- Comparaison avec les routes extraites de chaque config (clés STRING dans les fichiers `home_page_*.dart`)
- Les clés `redirectConfig` sont exclues de la comparaison (redirigées AVANT pushNamed)

---

*Fichier généré automatiquement — ne pas modifier manuellement*
*Pour mettre à jour : relancer l'analyse statique Python décrite en section 7*
