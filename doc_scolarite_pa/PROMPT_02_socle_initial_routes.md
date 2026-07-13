# PROMPT 02 — Brancher les routes DPS/DPG Socle Initial PA

## Contexte
Toutes les pages de contenu du socle initial existent dans `lib/content/pa_scolarite/`.
Leurs `routeName` ont le préfixe `/pa/dps_dpg/...` (ex: `/pa/dps_dpg/atteintes_biens/vol`).
Mais `home_page_pa_school.dart` utilise des routes différentes (ex: `/pa/dps_dpg/socle_initial/atteintes_biens/vol`).

**Solution retenue** : ajouter des routes alias dans `app_router.dart` qui font correspondre
les routes `home_page` aux classes de pages PA déjà existantes.
NE PAS modifier les `routeName` dans les fichiers de pages (cela casserait les liens internes).

**Contraintes** :
- Ne pas modifier la table supabase ni la logique métier
- Ne pas casser les pages quiz existantes
- Écrire en français dans les commentaires

---

## Routes déjà fonctionnelles (ne rien faire)

Ces routes du socle initial pointent déjà vers des routes `/gpx/...` enregistrées :
```
Généralités        → /gpx/generalites/classification_infractions  ✅
                   → /gpx/generalites/infraction_intro            ✅
                   → /gpx/generalites/tentative_intro             ✅
                   → /gpx/generalites/complicite_intro            ✅
                   → /gpx/generalites/legitimedefense_intro       ✅
                   → /gpx/generalites/usagedesarmes_intro         ✅
                   → /gpx/generalites/libertespubliques_intro     ✅
                   → /gpx/generalites/retention_locaux_police_intro ✅
Cadres juridiques  → /gpx/generalites/cadres_enquete_intro        ✅ (et autres /gpx/)
Contrôle identité  → quiz PA_controle_identite                     ✅
Circulation        → /pa/dps_dpg/socle_initial/circulation/agents_verbalisateurs ✅
                     (déjà enregistré via AgentsVerbalisateursCirculationPage)
```

---

## Imports à ajouter dans main.dart

```dart
// === PA Socle initial — Atteintes aux biens ===
import 'package:copiqpolice/content/pa_scolarite/atteintes_biens_pages/vol_page.dart'
    as pa_vol;
import 'package:copiqpolice/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/destructions_degradations_contenu_page.dart'
    as pa_dest;
import 'package:copiqpolice/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/sans_danger_dommage_leger_contenu_page.dart'
    as pa_dest_sd;
import 'package:copiqpolice/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart'
    as pa_dest_dp;
import 'package:copiqpolice/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart'
    as pa_tags;

// === PA Socle initial — Atteintes aux personnes ===
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/discriminations_contenu_page.dart'
    as pa_discrim;
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/atteintes_volontaires_integrite_contenu_page.dart'
    as pa_vv;
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart'
    as pa_vh;
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/violences_sur_fsi_page.dart'
    as pa_fsi;
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/atteinte_volontaire/atteintes_volontaires_vie_contenu_page.dart'
    as pa_vie;
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_inceste_agressions_avertissement_page.dart'
    as pa_viol_av;
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agressions_sexuelles_autres_que_viol_page.dart'
    as pa_agsex;
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/harcelement_sexuel_page.dart'
    as pa_harc;
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/exhibition_sexuelle_page.dart'
    as pa_exhib;
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_contenu_page.dart'
    as pa_mep;
import 'package:copiqpolice/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_intimite_personne.dart'
    as pa_intimite;
// Chercher le fichier outrage_sexiste dans pa_scolarite — s'il n'existe pas, voir TACHES_MANUELLES.md

// === PA Socle initial — Autorité de l'État ===
import 'package:copiqpolice/content/pa_scolarite/atteintes_nation_pages/atteintes_administration/rebellion_contenu_page.dart'
    as pa_rebellion;
import 'package:copiqpolice/content/pa_scolarite/atteintes_nation_pages/atteintes_administration/provocation_directe_rebellion_contenu_page.dart'
    as pa_prov_reb;
import 'package:copiqpolice/content/pa_scolarite/atteintes_nation_pages/atteintes_administration/atteintes_administration_contenu_page.dart'
    as pa_outrage;
// Vérifier le fichier PA pour refus_obtemperer dans circulation_pages ou atteintes_nation

// === PA Socle initial — Organisation judiciaire ===
import 'package:copiqpolice/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart'
    as pa_oj_struct;
import 'package:copiqpolice/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart'
    as pa_oj_mag;
```

---

## Routes alias à ajouter dans app_router.dart

```dart
// =====================================================
// PA SOCLE INITIAL — ATTEINTES AUX BIENS
// =====================================================
'/pa/dps_dpg/socle_initial/atteintes_biens/vol': (_) =>
    const pa_vol.VolPage(),
'/pa/dps_dpg/socle_initial/atteintes_biens/destructions': (_) =>
    const pa_dest.DestructionsDegradationsContenuPage(),
'/pa/dps_dpg/socle_initial/atteintes_biens/sans_danger_personnes': (_) =>
    const pa_dest_sd.SansDangerDommageLegerContenuPage(),
'/pa/dps_dpg/socle_initial/atteintes_biens/dangereuses_personnes': (_) =>
    const pa_dest_dp.DangereusesPersonnesIntentionnelleContenuPage(),
'/pa/dps_dpg/socle_initial/atteintes_biens/tags_graffitis': (_) =>
    const pa_tags.TagsInscriptionsSignesDessinContenuPage(),

// =====================================================
// PA SOCLE INITIAL — ATTEINTES AUX PERSONNES
// =====================================================
'/pa/dps_dpg/socle_initial/atteintes_personnes/discriminations': (_) =>
    const pa_discrim.DiscriminationsContenuPage(),
'/pa/dps_dpg/socle_initial/atteintes_personnes/violences_volontaires': (_) =>
    const pa_vv.AtteintesVolontairesIntegriteContenuPage(),
'/pa/dps_dpg/socle_initial/atteintes_personnes/violences_habituelles': (_) =>
    const pa_vh.ViolencesHabituellesCoupleExPage(),
'/pa/dps_dpg/socle_initial/atteintes_personnes/violences_fsi': (_) =>
    const pa_fsi.ViolencesSurFsiPage(),
'/pa/dps_dpg/socle_initial/atteintes_personnes/atteintes_vie': (_) =>
    const pa_vie.AtteintesVolontairesVieContenuPage(),
// VIOL : ouvre d'abord l'avertissement, qui navigue ensuite vers le contenu
'/pa/dps_dpg/socle_initial/atteintes_personnes/viol': (_) =>
    const pa_viol_av.ViolIncesteAgressionsAvertissementPage(),
'/pa/dps_dpg/socle_initial/atteintes_personnes/agressions_sexuelles': (_) =>
    const pa_agsex.AgressionsSeuellesAutresQueViolPage(),
'/pa/dps_dpg/socle_initial/atteintes_personnes/harcelement_sexuel': (_) =>
    const pa_harc.HarcellementSexuelPage(),
'/pa/dps_dpg/socle_initial/atteintes_personnes/exhibition': (_) =>
    const pa_exhib.ExhibitionSexuellePage(),
'/pa/dps_dpg/socle_initial/atteintes_personnes/mineurs_mise_en_peril': (_) =>
    const pa_mep.MiseEnDangerContenuPage(),
'/pa/dps_dpg/socle_initial/atteintes_personnes/atteinte_intimite': (_) =>
    const pa_intimite.AtteintesIntimitePersonnePage(),
// outrage_sexiste : vérifier si un fichier PA existe, sinon → TACHES_MANUELLES.md

// =====================================================
// PA SOCLE INITIAL — AUTORITÉ DE L'ÉTAT
// =====================================================
'/pa/dps_dpg/socle_initial/autorite_etat/rebellion': (_) =>
    const pa_rebellion.RebellionContenuPage(),
'/pa/dps_dpg/socle_initial/autorite_etat/provocation_rebellion': (_) =>
    const pa_prov_reb.ProvocationDirecteRebellionContenuPage(),
// outrage et refus_obtemperer : chercher les classes PA correspondantes
// (AtteintesAdministrationContenuPage ou pages dédiées dans circulation_pages)
'/pa/dps_dpg/socle_initial/autorite_etat/outrage': (_) =>
    const pa_outrage.AtteintesAdministrationContenuPage(),
'/pa/dps_dpg/socle_initial/autorite_etat/refus_obtemperer': (_) =>
    const RefusObtempererPage(), // depuis circulation_pages PA

// =====================================================
// PA SOCLE INITIAL — ORGANISATION JUDICIAIRE
// =====================================================
'/pa/dps_dpg/socle_initial/organisation_judiciaire/organisation': (_) =>
    const pa_oj_struct.StructureJudiciairePage(),
'/pa/dps_dpg/socle_initial/organisation_judiciaire/magistrature': (_) =>
    const pa_oj_mag.JuridictionsPenalesPage(),
```

---

## Vérifications nécessaires avant de lancer

1. **Noms exacts des classes** : Lire chaque fichier PA cité pour confirmer le nom exact de la classe :
   ```bash
   grep "^class " lib/content/pa_scolarite/atteintes_biens_pages/vol_page.dart
   grep "^class " lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/discriminations_contenu_page.dart
   # etc.
   ```

2. **Pages manquantes** :
   - `outrage_sexiste` : chercher `outrage_sexiste` ou `outrage_sexuel` dans `pa_scolarite/`
   - `refus_obtemperer` (socle initial autorité état) : vérifier dans `atteintes_nation_pages/` ou `circulation_pages/`

3. **Page viol** : s'assurer que `ViolIncesteAgressionsAvertissementPage` navigue correctement
   vers le contenu viol après que l'utilisateur accepte l'avertissement.

---

## Quiz socle initial

Dans `home_page_pa_school.dart`, les quizzes du socle initial pointent vers :
- `pa_quiz_crimes_delits_bien.dart` → route à confirmer dans `quiz_scolarite_pa/`
- `pa_quiz_crimes_delits_personne.dart`
- etc.

Vérifier que chaque CategoryConfig du socle initial a bien son `quizRoute` correctement configuré
et enregistré dans `app_router.dart`.

Fichier quiz PA pour atteintes biens : `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_crimes_delits_bien.dart`
Fichier quiz PA pour atteintes personnes : `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_crimes_delits_personne.dart`
