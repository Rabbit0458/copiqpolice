# PROMPT 03 — Brancher les routes DPS/DPG Socle Avancé PA

## Contexte
Mêmes principes que PROMPT_02. Les fichiers existent, leurs routeNames ont le préfixe `/pa/dps_dpg/`.
On ajoute des **alias routes** dans `app_router.dart` sans modifier les routeNames existants.

**Pages ABSENTES en PA → coder manuellement (voir TACHES_MANUELLES.md) :**
- Acteurs PJ : OPJ, APJ, Assistants d'enquête, Prérogatives, Procureur, Juge instruction
- Immunités et inviolabilités
- Abstention volontaire de combattre un sinistre
- Entrave volontaire à l'arrivée des secours
- Outrage sexiste et sexuel

---

## Imports à ajouter dans main.dart

```dart
// === PA Socle avancé — Généralités DPG ===
import 'package:copiqpolice/content/pa_scolarite/dpg_pages/loi_penale_contenu_page.dart'
    as pa_droit_penal;
import 'package:copiqpolice/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart'
    as pa_resp_penale;

// === PA Socle avancé — Atteintes aux biens ===
import 'package:copiqpolice/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/extorsion_contenu_page.dart'
    as pa_extorsion;
import 'package:copiqpolice/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/escroquerie_contenu_page.dart'
    as pa_escroquerie;
import 'package:copiqpolice/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart'
    as pa_abus_conf;
import 'package:copiqpolice/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/filouteries_contenu_page.dart'
    as pa_filouterie;
import 'package:copiqpolice/content/pa_scolarite/atteintes_biens_pages/recel_non_justification/recel_page.dart'
    as pa_recel;
// abstention_sinistre : voir TACHES_MANUELLES.md

// === PA Socle avancé — Atteintes aux personnes ===
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_contenu_page.dart'
    as pa_involontaires;
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/menaces_avec_condition_page.dart'
    as pa_menaces;
// entrave_secours : voir TACHES_MANUELLES.md
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_obstacle_commission_crime_delit_page.dart'
    as pa_non_obstacle;
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart'
    as pa_non_assist;
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/appels_messages_malveillants_agressions_sonores_page.dart'
    as pa_appels;
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart'
    as pa_risque;

// === PA Socle avancé — Délits routiers ===
// Ces pages existent dans circulation_pages/ avec routeNames socle_initial/circulation/...
// On les réutilise ici via alias supplémentaires
import 'package:copiqpolice/content/pa_scolarite/circulation_pages/rodeo_motorise_contenu_page.dart'
    as pa_rodeo;
import 'package:copiqpolice/content/pa_scolarite/circulation_pages/incitation_organisation_promotion_page.dart'
    as pa_incitation;
import 'package:copiqpolice/content/pa_scolarite/circulation_pages/delit_fuite_page.dart'
    as pa_delit_fuite;
import 'package:copiqpolice/content/pa_scolarite/circulation_pages/refus_obtemperer_page.dart'
    as pa_refus;
import 'package:copiqpolice/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart'
    as pa_alcool;

// === PA Socle avancé — Autorité de l'État ===
import 'package:copiqpolice/content/pa_scolarite/atteintes_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart'
    as pa_menaces_dep;
import 'package:copiqpolice/content/pa_scolarite/atteintes_nation_pages/probite/corruption_page.dart'
    as pa_corruption;
import 'package:copiqpolice/content/pa_scolarite/atteintes_nation_pages/probite/probite_contenu_page.dart'
    as pa_probite;

// === PA Socle avancé — Stupéfiants ===
import 'package:copiqpolice/content/pa_scolarite/stupefiants_pages/usage_illicite_contenu_page.dart'
    as pa_stup_usage;
import 'package:copiqpolice/content/pa_scolarite/stupefiants_pages/cession_offre_contenu_page.dart'
    as pa_stup_cession;
```

---

## Routes alias à ajouter dans app_router.dart

```dart
// =====================================================
// PA SOCLE AVANCÉ — GÉNÉRALITÉS (DPG)
// =====================================================
'/pa/dps_dpg/socle_avance/generalites/droit_penal': (_) =>
    const pa_droit_penal.LoiPenaleContenuPage(),
// immunites_inviolabilites : voir TACHES_MANUELLES.md — à coder manuellement
'/pa/dps_dpg/socle_avance/generalites/responsabilite_penale': (_) =>
    const pa_resp_penale.PaResponsabilitePenalePage(),

// =====================================================
// PA SOCLE AVANCÉ — ACTEURS DE LA POLICE JUDICIAIRE
// voir TACHES_MANUELLES.md — toutes ces pages à coder manuellement :
// /pa/dps_dpg/socle_avance/acteurs_pj/opj
// /pa/dps_dpg/socle_avance/acteurs_pj/apj
// /pa/dps_dpg/socle_avance/acteurs_pj/assistants_enquete
// /pa/dps_dpg/socle_avance/acteurs_pj/prerogatives
// /pa/dps_dpg/socle_avance/acteurs_pj/procureur
// /pa/dps_dpg/socle_avance/acteurs_pj/juge_instruction
// =====================================================

// =====================================================
// PA SOCLE AVANCÉ — ATTEINTES AUX BIENS
// =====================================================
'/pa/dps_dpg/socle_avance/atteintes_biens/extorsion': (_) =>
    const pa_extorsion.ExtorsionContenuPage(),
'/pa/dps_dpg/socle_avance/atteintes_biens/escroquerie': (_) =>
    const pa_escroquerie.EscrquerieContenuPage(),
'/pa/dps_dpg/socle_avance/atteintes_biens/abus_confiance': (_) =>
    const pa_abus_conf.AbusDeConfianceContenuPage(),
'/pa/dps_dpg/socle_avance/atteintes_biens/filouterie': (_) =>
    const pa_filouterie.FilouteriesContenuPage(),
'/pa/dps_dpg/socle_avance/atteintes_biens/recel': (_) =>
    const pa_recel.RecelPage(),
// abstention_sinistre → TACHES_MANUELLES.md

// =====================================================
// PA SOCLE AVANCÉ — ATTEINTES AUX PERSONNES
// =====================================================
'/pa/dps_dpg/socle_avance/atteintes_personnes/involontaires': (_) =>
    const pa_involontaires.AtteintesInvolontairesContenuPage(),
'/pa/dps_dpg/socle_avance/atteintes_personnes/menaces': (_) =>
    const pa_menaces.MenacesAvecConditionPage(),
// entrave_secours → TACHES_MANUELLES.md
'/pa/dps_dpg/socle_avance/atteintes_personnes/non_obstacle': (_) =>
    const pa_non_obstacle.NonObstacleCommissionCrimeDelitPage(),
'/pa/dps_dpg/socle_avance/atteintes_personnes/non_assistance': (_) =>
    const pa_non_assist.NonAssistancePersonnePenilPage(),
'/pa/dps_dpg/socle_avance/atteintes_personnes/appels_malveillants': (_) =>
    const pa_appels.AppelsMessagesMalveillantsAgressionsSonoresPage(),
'/pa/dps_dpg/socle_avance/atteintes_personnes/risque_autrui': (_) =>
    const pa_risque.RisqueCauseAutruiPage(),

// =====================================================
// PA SOCLE AVANCÉ — DÉLITS ROUTIERS
// (mêmes pages que socle initial circulation, alias supplémentaires)
// =====================================================
'/pa/dps_dpg/socle_avance/delits_routiers/rodeo': (_) =>
    const pa_rodeo.RodeoMotoriseContenuPage(),
'/pa/dps_dpg/socle_avance/delits_routiers/incitation': (_) =>
    const pa_incitation.IncitationOrganisationPromotionPage(),
'/pa/dps_dpg/socle_avance/delits_routiers/delit_fuite': (_) =>
    const pa_delit_fuite.DelitFuitePage(),
'/pa/dps_dpg/socle_avance/delits_routiers/refus_obtemperer': (_) =>
    const pa_refus.RefusObtempererPage(),
// "autres" = alcool / stupefiants / permis / vérifications → ouvre la page alcool en entrée
'/pa/dps_dpg/socle_avance/delits_routiers/autres': (_) =>
    const pa_alcool.EtatAlcooliqueContenuPage(),

// =====================================================
// PA SOCLE AVANCÉ — AUTORITÉ DE L'ÉTAT
// =====================================================
'/pa/dps_dpg/socle_avance/autorite_etat/menaces': (_) =>
    const pa_menaces_dep.MenacesEnversDepositaireAutoriteContenuPage(),
// corruption_passive → la page corruption_page.dart (probablement corruption active + passive)
'/pa/dps_dpg/socle_avance/autorite_etat/corruption_passive': (_) =>
    const pa_corruption.CorruptionPage(),
'/pa/dps_dpg/socle_avance/autorite_etat/corruption_active': (_) =>
    const pa_probite.ProbiteContenuPage(),

// =====================================================
// PA SOCLE AVANCÉ — STUPÉFIANTS
// =====================================================
'/pa/dps_dpg/socle_avance/stupefiants/usage_illicite': (_) =>
    const pa_stup_usage.UsageIlliciteContenuPage(),
'/pa/dps_dpg/socle_avance/stupefiants/cession_offre': (_) =>
    const pa_stup_cession.CessionOffreContenuPage(),
```

---

## Notes importantes

### Noms exacts des classes — à vérifier avant d'appliquer
```bash
grep "^class " \
  lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/extorsion_contenu_page.dart \
  lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/escroquerie_contenu_page.dart \
  lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart \
  lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/filouteries_contenu_page.dart \
  lib/content/pa_scolarite/atteintes_biens_pages/recel_non_justification/recel_page.dart \
  lib/content/pa_scolarite/stupefiants_pages/usage_illicite_contenu_page.dart \
  lib/content/pa_scolarite/stupefiants_pages/cession_offre_contenu_page.dart \
  lib/content/pa_scolarite/atteintes_nation_pages/probite/corruption_page.dart \
  lib/content/pa_scolarite/dpg_pages/loi_penale_contenu_page.dart
```

### Corruption : 2 routes pour 1 page
La page `CorruptionPage` couvre peut-être corruption passive + active.
Si c'est le cas, les deux routes alias peuvent pointer vers la même classe.

### Délits routiers "Autres"
La route `/pa/dps_dpg/socle_avance/delits_routiers/autres` affiche un label dynamique
(alcool, stupefiants, permis, vérifications...). La page `EtatAlcooliqueContenuPage`
peut servir de point d'entrée, mais idéalement créer une page hub listant ces délits.
À définir selon le contenu voulu.
