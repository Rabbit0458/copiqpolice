# PROMPT 01 — Brancher les routes Institution & Valeurs PA

## Contexte
Les fichiers de contenu pour les modules Institution & Valeurs de la scolarité PA existent déjà
dans `lib/content/pa_scolarite/institution_valeurs/`. Leurs `routeName` sont correctement définis
avec le préfixe `/pa/`. Ils ne sont pas encore importés dans `main.dart` ni enregistrés dans `app_router.dart`.

**Contraintes absolues** :
- Ne pas modifier la logique métier ni les routes existantes
- Ne pas déplacer les fichiers GPX
- Les pages PA ont les mêmes noms de classe que les GPX → utiliser des alias Dart à l'import

---

## Étape 1 — Ajouter les imports PA dans main.dart

Ajoute les imports suivants dans `lib/main.dart`, en utilisant des **alias** pour éviter les conflits
de noms avec les classes GPX déjà importées.

```dart
// === PA institution_valeurs — déontologie ===
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/deontologie/gpx_code_deontologie_commente_page.dart'
    as pa_deonto_code;
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/deontologie/marques_exterieures_respect_page.dart'
    as pa_deonto_marques;
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart'
    as pa_deonto_droits;
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/deontologie/hors_service_amaris_page.dart'
    as pa_deonto_hors;
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/deontologie/sanctions_recompenses_page.dart'
    as pa_deonto_sanc;
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/deontologie/enquete_administrative_page.dart'
    as pa_deonto_enq;
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/deontologie/reseaux_sociaux_page.dart'
    as pa_deonto_rsoc;

// === PA institution_valeurs — hiérarchie info ===
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/hierarchie_info/compte_rendu_page.dart'
    as pa_hier_cr;
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/hierarchie_info/formalisme_rapport_page.dart'
    as pa_hier_fr;
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/hierarchie_info/modeles_rapports_page.dart'
    as pa_hier_mod;

// === PA institution_valeurs — accueil public ===
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/accueil_public/charte_accueil_public_victimes_page.dart'
    as pa_acc_charte;
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart'
    as pa_acc_marianne;
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart'
    as pa_acc_doctrine;
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart'
    as pa_acc_dem;
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/accueil_public/protection_locaux_police_page.dart'
    as pa_acc_prot;

// === PA institution_valeurs — laïcité ===
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/laicite/gpx_laicite_dlpaj_page.dart'
    as pa_laic_dlpaj;
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/laicite/charte_laicite_services_publics_page.dart'
    as pa_laic_charte;
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/laicite/rites_cultes_france_page.dart'
    as pa_laic_rites;

// === PA institution_valeurs — histoire ===
import 'package:copiqpolice/content/pa_scolarite/institution_valeurs/histoire/histoire_reperes_page.dart'
    as pa_hist;
```

---

## Étape 2 — Ajouter les routes dans app_router.dart

Dans `lib/routes/app_router.dart`, ajoute ces routes (section PA, après les routes organisation_pn) :

```dart
// ====== PA INSTITUTION & VALEURS — DÉONTOLOGIE ======
pa_deonto_code.GpxCodeDeontologieCommentePage.routeName: (_) =>
    const pa_deonto_code.GpxCodeDeontologieCommentePage(),
pa_deonto_marques.MarquesExterieuresRespectPage.routeName: (_) =>
    const pa_deonto_marques.MarquesExterieuresRespectPage(),
pa_deonto_droits.DroitsObligationsPoliciersPage.routeName: (_) =>
    const pa_deonto_droits.DroitsObligationsPoliciersPage(),
pa_deonto_hors.HorsServiceAmarisPage.routeName: (_) =>
    const pa_deonto_hors.HorsServiceAmarisPage(),
pa_deonto_sanc.SanctionsRecompensesPage.routeName: (_) =>
    const pa_deonto_sanc.SanctionsRecompensesPage(),
pa_deonto_enq.EnqueteAdministrativePage.routeName: (_) =>
    const pa_deonto_enq.EnqueteAdministrativePage(),
pa_deonto_rsoc.ReseauxSociauxPage.routeName: (_) =>
    const pa_deonto_rsoc.ReseauxSociauxPage(),

// ====== PA INSTITUTION & VALEURS — HIÉRARCHIE INFO ======
pa_hier_cr.CompteRenduPage.routeName: (_) =>
    const pa_hier_cr.CompteRenduPage(),
pa_hier_fr.FormalismeRapportPage.routeName: (_) =>
    const pa_hier_fr.FormalismeRapportPage(),
pa_hier_mod.ModelesRapportsPage.routeName: (_) =>
    const pa_hier_mod.ModelesRapportsPage(),

// ====== PA INSTITUTION & VALEURS — ACCUEIL PUBLIC ======
pa_acc_charte.CharteAccueilPublicVictimesPage.routeName: (_) =>
    const pa_acc_charte.CharteAccueilPublicVictimesPage(),
pa_acc_marianne.ReferentielMariannePage.routeName: (_) =>
    const pa_acc_marianne.ReferentielMariannePage(),
pa_acc_doctrine.GpxDoctrineAccueilVictimesVcPage.routeName: (_) =>
    const pa_acc_doctrine.GpxDoctrineAccueilVictimesVcPage(),
pa_acc_dem.DemarchesAdministrativesPage.routeName: (_) =>
    const pa_acc_dem.DemarchesAdministrativesPage(),
pa_acc_prot.ProtectionLocauxPolicePage.routeName: (_) =>
    const pa_acc_prot.ProtectionLocauxPolicePage(),

// ====== PA INSTITUTION & VALEURS — LAÏCITÉ ======
pa_laic_dlpaj.GpxLaiciteDlpajPage.routeName: (_) =>
    const pa_laic_dlpaj.GpxLaiciteDlpajPage(),
pa_laic_charte.CharteLaiciteServicesPublicsPage.routeName: (_) =>
    const pa_laic_charte.CharteLaiciteServicesPublicsPage(),
pa_laic_rites.RitesCultesFrancePage.routeName: (_) =>
    const pa_laic_rites.RitesCultesFrancePage(),

// ====== PA INSTITUTION & VALEURS — HISTOIRE ======
pa_hist.HistoireReperesPage.routeName: (_) =>
    const pa_hist.HistoireReperesPage(),
```

---

## Étape 3 — Vérifier les routeNames exacts dans les fichiers PA

Avant d'ajouter les routes, vérifier que chaque fichier PA a bien le bon `routeName` :

```bash
grep -A2 "static const String routeName" \
  lib/content/pa_scolarite/institution_valeurs/deontologie/*.dart \
  lib/content/pa_scolarite/institution_valeurs/hierarchie_info/*.dart \
  lib/content/pa_scolarite/institution_valeurs/accueil_public/*.dart \
  lib/content/pa_scolarite/institution_valeurs/laicite/*.dart \
  lib/content/pa_scolarite/institution_valeurs/histoire/*.dart
```

Les routeNames attendus (définis dans home_page_pa_school.dart) :
```
/pa/institution/deontologie/code_commente
/pa/institution/deontologie/marques_respect
/pa/institution/deontologie/droits_obligations
/pa/institution/deontologie/hors_service_amaris
/pa/institution/deontologie/sanctions_recompenses
/pa/institution/deontologie/enquete_administrative
/pa/institution/deontologie/reseaux_sociaux
/pa/institution/hierarchie_info/compte_rendu
/pa/institution/hierarchie_info/formalisme_rapport
/pa/institution/hierarchie_info/modeles
/pa/institution/accueil_public/charte
/pa/institution/accueil_public/marianne
/pa/institution/accueil_public/doctrine
/pa/institution/accueil_public/demarches
/pa/institution/accueil_public/protection_locaux
/pa/institution/laicite/laicite_dlpaj
/pa/institution/laicite/charte
/pa/institution/laicite/rites_cultes
/pa/institution/histoire/reperes
```

Si un `routeName` dans le fichier `.dart` ne correspond pas à ce que home_page attend,
corriger le `routeName` dans le fichier `.dart` (pas dans home_page).

---

## Étape 4 — Quiz Institution & Valeurs PA

Dans `home_page_pa_school.dart`, le quiz déontologie pointe vers `/gpx/institution/deontologie/quiz`
et le quiz accueil public vers `/gpx/institution/accueil_public/quiz`.
Ces routes GPX sont déjà enregistrées → pas de changement nécessaire pour les quiz.

---

## Vérification finale
```bash
# Chercher les routes manquantes après modification
grep "/pa/institution/" lib/routes/app_router.dart | sort
# Ne doit pas renvoyer "vide" — doit afficher les 19 routes ajoutées
```
