# État d'avancement — Scolarité Policier Adjoint
_Mis à jour : 2026-06-15_

## Principe architectural
- **Contenus PA** : `lib/content/pa_scolarite/`
- **Hub pages PA** : `lib/content/pa_scolarite/[module]_pages/`  
  (pages de navigation / catégories — généralement vides ou stub)
- **Pages de contenu réelles** : copiées depuis `lib/content/gpx_scolarite/`  
  avec `routeName` modifié pour avoir le préfixe `/pa/`
- **Routing** : `lib/routes/app_router.dart` + imports dans `lib/main.dart`
- **Home PA** : `lib/features/home/home_page_pa_school.dart`

---

## ✅ MODULES COMPLÈTEMENT CODÉS (fichiers + routes)

| Module | Dossier PA | Status |
|--------|-----------|--------|
| Formation initiale | `formation_initiale/` | ✅ 2 pages + routes |
| Organisation PN | `organisation_pn/` | ✅ 8 pages + routes |
| Agents verbalisateurs | `circulation_pages/` | ✅ route enregistrée |

---

## ⚠️ MODULES — FICHIERS EXISTENT, ROUTES MANQUANTES

Ces modules ont leurs fichiers `.dart` créés avec les bons `routeName` (préfixe `/pa/`),
**MAIS** ces classes ne sont PAS importées dans `main.dart`  
et leurs routes ne sont PAS dans `app_router.dart`.

### 1. INSTITUTION & VALEURS — Déontologie
**Dossier** : `lib/content/pa_scolarite/institution_valeurs/deontologie/`  
**Routes attendues par home_page_pa_school** :
```
/pa/institution/deontologie/code_commente
/pa/institution/deontologie/marques_respect
/pa/institution/deontologie/droits_obligations
/pa/institution/deontologie/hors_service_amaris
/pa/institution/deontologie/sanctions_recompenses
/pa/institution/deontologie/enquete_administrative
/pa/institution/deontologie/reseaux_sociaux
```
→ **Prompt** : `PROMPT_01_institution_valeurs_routes.md`

### 2. INSTITUTION & VALEURS — Hiérarchie info
**Dossier** : `lib/content/pa_scolarite/institution_valeurs/hierarchie_info/`  
**Routes attendues** :
```
/pa/institution/hierarchie_info/compte_rendu
/pa/institution/hierarchie_info/formalisme_rapport
/pa/institution/hierarchie_info/modeles
```

### 3. INSTITUTION & VALEURS — Accueil public
**Routes attendues** :
```
/pa/institution/accueil_public/charte
/pa/institution/accueil_public/marianne
/pa/institution/accueil_public/doctrine
/pa/institution/accueil_public/demarches
/pa/institution/accueil_public/protection_locaux
```

### 4. INSTITUTION & VALEURS — Laïcité / Histoire
**Routes attendues** :
```
/pa/institution/laicite/laicite_dlpaj
/pa/institution/laicite/charte
/pa/institution/laicite/rites_cultes
/pa/institution/histoire/reperes
```

---

## ⚠️ SOCLE INITIAL DPS/DPG — Routes manquantes

Les routes dans `home_page_pa_school.dart` pour le socle initial utilisent des chemins
comme `/pa/dps_dpg/socle_initial/atteintes_biens/vol`,  
mais les pages PA ont des `routeName` différents (ex: `/pa/dps_dpg/atteintes_biens/vol`).

**Il faut soit :**
- Ajouter des alias dans `app_router.dart` qui font correspondre les routes home ↔ pages existantes
- OU modifier les `routeName` dans les pages pour qu'ils correspondent aux routes home

→ **Prompt** : `PROMPT_02_socle_initial_routes.md`

### Routes socle initial attendues par home_page_pa_school

```
/pa/dps_dpg/socle_initial/atteintes_biens/vol
/pa/dps_dpg/socle_initial/atteintes_biens/destructions
/pa/dps_dpg/socle_initial/atteintes_biens/tags_graffitis
/pa/dps_dpg/socle_initial/atteintes_personnes/violences_fsi   (image modifiée)
/pa/dps_dpg/socle_initial/atteintes_personnes/viol
/pa/dps_dpg/socle_initial/atteintes_personnes/exhibition
/pa/dps_dpg/socle_initial/atteintes_personnes/atteintes_vie
/pa/dps_dpg/socle_initial/autorite_etat/refus_obtemperer
/pa/dps_dpg/socle_initial/autorite_etat/outrage
/pa/dps_dpg/socle_initial/autorite_etat/rebellion
/pa/dps_dpg/socle_initial/organisation_judiciaire/organisation
/pa/dps_dpg/socle_initial/organisation_judiciaire/magistrature
/pa/dps_dpg/socle_initial/circulation/agents_verbalisateurs   ← DÉJÀ OK
```
Pour generalités, cadres_juridiques, contrôle_identité → les routes pointent déjà vers `/gpx/...` (pages GPX partagées) donc ✅ déjà fonctionnel.

---

## ⚠️ SOCLE AVANCÉ DPS/DPG — Routes manquantes

→ **Prompt** : `PROMPT_03_socle_avance_routes.md`

```
/pa/dps_dpg/socle_avance/generalites/droit_penal          (image modifiée)
/pa/dps_dpg/socle_avance/generalites/responsabilite_penale (image modifiée)
/pa/dps_dpg/socle_avance/acteurs_pj/opj                   (image modifiée)
/pa/dps_dpg/socle_avance/acteurs_pj/apj                   (image modifiée)
/pa/dps_dpg/socle_avance/acteurs_pj/assistants_enquete    (image modifiée)
/pa/dps_dpg/socle_avance/acteurs_pj/prerogatives          (image modifiée)
/pa/dps_dpg/socle_avance/acteurs_pj/procureur             (image modifiée)
/pa/dps_dpg/socle_avance/acteurs_pj/juge_instruction      (image modifiée)
/pa/dps_dpg/socle_avance/atteintes_biens/extorsion        (image modifiée)
/pa/dps_dpg/socle_avance/atteintes_biens/escroquerie      (image modifiée)
/pa/dps_dpg/socle_avance/atteintes_biens/abus_confiance   (image modifiée)
/pa/dps_dpg/socle_avance/atteintes_biens/filouterie       (image modifiée)
/pa/dps_dpg/socle_avance/atteintes_biens/recel            (image modifiée)
/pa/dps_dpg/socle_avance/atteintes_biens/abstention_sinistre (image modifiée)
/pa/dps_dpg/socle_avance/atteintes_personnes/involontaires (image modifiée)
/pa/dps_dpg/socle_avance/atteintes_personnes/menaces      (image modifiée)
/pa/dps_dpg/socle_avance/atteintes_personnes/entrave_secours (image modifiée)
/pa/dps_dpg/socle_avance/atteintes_personnes/non_obstacle (image modifiée)
/pa/dps_dpg/socle_avance/atteintes_personnes/non_assistance (image modifiée)
/pa/dps_dpg/socle_avance/atteintes_personnes/risque_autrui (image modifiée — déjà OK)
/pa/dps_dpg/socle_avance/delits_routiers/rodeo
/pa/dps_dpg/socle_avance/delits_routiers/incitation       (image modifiée)
/pa/dps_dpg/socle_avance/delits_routiers/delit_fuite
/pa/dps_dpg/socle_avance/delits_routiers/refus_obtemperer (image modifiée)
/pa/dps_dpg/socle_avance/delits_routiers/autres           (label dynamique)
/pa/dps_dpg/socle_avance/autorite_etat/menaces            (image modifiée)
/pa/dps_dpg/socle_avance/autorite_etat/corruption_passive (image modifiée)
/pa/dps_dpg/socle_avance/autorite_etat/corruption_active
/pa/dps_dpg/socle_avance/stupefiants/usage_illicite
/pa/dps_dpg/socle_avance/stupefiants/cession_offre
```

---

## ✅ Pages sans équivalent GPX — DÉJÀ codées manuellement

- **Organisation judiciaire** : `organisation_judiciaire_pages/` (5 pages) — codé manuellement ✅
- **Agents verbalisateurs** : `circulation_pages/agents_verbalisateurs_circulation_page.dart` — codé manuellement ✅

Voir `TACHES_MANUELLES.md` pour les pages encore à coder.

---

## 🔑 Résumé des actions restantes

1. **PROMPT_01** → Ajouter imports + routes PA institution_valeurs dans main.dart / app_router.dart
2. **PROMPT_02** → Connecter les routes socle initial (alias ou correction routeNames)
3. **PROMPT_03** → Connecter les routes socle avancé (alias ou correction routeNames)
4. **TACHES_MANUELLES** → Coder les quelques pages encore vides

**Note critique** : Les fichiers PA dans `institution_valeurs/` ont les mêmes noms de classes que les GPX.
Il faut les importer avec des **alias Dart** dans `main.dart` pour éviter les conflits.
Exemple : `import '...pa.../gpx_code_deontologie_commente_page.dart' as pa_deo;`
ET référencer `pa_deo.GpxCodeDeontologieCommentePage.routeName` dans `app_router.dart`.
