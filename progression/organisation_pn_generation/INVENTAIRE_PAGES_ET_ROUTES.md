# Inventaire des pages, composants et routes

## Quiz Organisation directement concernés

| Portée | Fichier | Route | Module attendu |
|---|---|---|---|
| Scolarité GPX | `lib/content/gpx_scolarite/institutions_valeurs/quiz_institutions_valeurs/quiz_organisation_page.dart` | `/gpx/institution/organisation_pn/quiz` | `gpx_institutions_valeurs_quiz_institutions_valeurs_quiz_organisation_page` |
| Scolarité PA | `lib/content/pa_scolarite/institutions_valeurs_quiz/pa_quiz_organisation_page.dart` | `/pa/institution/organisation_pn/quiz` | `pa_institutions_valeurs_quiz_pa_quiz_organisation_page` |

Les deux fichiers ont la même banque locale et le même moteur visuel. La future connexion doit extraire uniquement le modèle et le dépôt de données communs, sans modifier les widgets de difficulté, question, correction, résultat, son, haptique, thème ou accessibilité.

## Pages de cours Organisation partagées

La cartographie recense les routes homologues GPX et PA vers les pages suivantes :

- `organisation_page.dart` — organisation générale ;
- `organigramme_mi_page.dart` — ministère de l'Intérieur ;
- `organigrammes_pn_page.dart` — DGPN et directions ;
- `dgsi_page.dart` — DGSI ;
- `prefecture_police_page.dart` — Préfecture de police ;
- `hierarchie_pn_page.dart` — corps, grades et chaîne hiérarchique ;
- `horaires_service_sp_page.dart` — horaires et cycles en sécurité publique.

Les wrappers PA `pa_*.dart` redirigent vers ces routes communes. Ils doivent être conservés.

## Huit pages fournies

Les huit fichiers `institution_valeurs_pages/...` sont des coquilles de 21 lignes utilisant `ScolariteText.value(source_path, "f00001", "Page en construction")`. Leur contenu doit être recherché dans l'inventaire, les fragments injectés et les pages réelles :

- DGPN/DGSI/PP → pages Organisation/DGSI/Préfecture ;
- histoire de la police → contenu et sources officielles Histoire ;
- hiérarchie des personnels → `hierarchie_pn_page.dart` et les 25 assets de grades ;
- formation initiale → pages GPX et PA dédiées ;
- égalité/diversité/protections → contenus institutions/valeurs correspondants ;
- droits/obligations et déontologie → pages déontologie GPX/PA ;
- horaires SP → page Organisation partagée.

## Composants transversaux contrôlés

- `lib/core/services/learning_answer_history_service.dart` et RPC `record_learning_answer` ;
- `lib/core/services/quiz_report_queue_service.dart` et `report_question` ;
- schéma `quiz_history` / `quiz_answer_history` ;
- `copiq-web/src/app/admin/signalements/` ;
- `copiq-web/src/lib/admin/report-target-resolver.ts` ;
- RPC de cycle éditorial et `admin_audit_logs`.

## Pages homologues de référence visuelle

Le contrôle porte au minimum sur les quiz Institutions/valeurs Accueil du public et Déontologie, en GPX et PA. Ils partagent la même structure d'écrans et constituent les témoins de non-régression. Les pages Exam GPX/PA restent hors branche de données et hors migration.

## Exceptions

- Exam GPX et Exam PA : contrôlés pour l'absence de route/module Organisation ciblé, non raccordés à la banque `school`.
- Les pages « en construction » ne seront pas modifiées pour cette tâche ; elles sont utilisées comme pointeurs de corpus seulement.
