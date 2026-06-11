# COP'IQ — Analytics Dashboards & Funnels
> CODE-074 — Phase N (Analytics, A/B, perf)  
> Outil cible : **PostHog** (cloud EU ou self-hosted)

---

## 1. Funnels critiques

### 1.1 Funnel d'acquisition → activation

| Étape | Event PostHog | Propriétés clés | Seuil alerte drop-off |
|---|---|---|---|
| 1. Install (1ère ouverture) | `app_opened` (native) | platform, version | — |
| 2. Onboarding complété | `onboarding_completed` | duration_s | > 60 % abandon → 🔴 |
| 3. Module Cas Pratique ouvert | `cp_screen_viewed` (screen=list) | — | > 50 % abandon → 🟠 |
| 4. Premier cas ouvert | `cp_case_opened` | case_slug, difficulty | > 50 % abandon → 🟠 |
| 5. Premier cas démarré | `cp_case_started` | attempt_id | > 40 % abandon → 🟠 |
| 6. Premier cas terminé (correction affichée) | `cp_correction_shown` | percent_score, is_first_attempt=true | > 50 % abandon → 🔴 |

**Alerte globale** : si conversion étape 4→6 < 30 % sur 7 jours → notifier #analytics Slack.

---

### 1.2 Funnel de rétention (semaine 2)

| Étape | Définition | Métrique |
|---|---|---|
| J0 | Utilisateur démarre son 1er cas | baseline |
| J1 | Revient et démarre un 2e cas | cible ≥ 40 % |
| J7 | A complété ≥ 3 cas distincts | cible ≥ 25 % |
| J14 | A complété ≥ 5 cas distincts | cible ≥ 15 % |
| J30 | A complété ≥ 10 cas | cible ≥ 10 % |

**Requête PostHog (SQL insight)** :
```sql
SELECT
  person_id,
  min(timestamp) as first_case_start,
  count(distinct properties->>'case_slug') as unique_cases
FROM events
WHERE event = 'cp_case_started'
GROUP BY person_id
```

---

### 1.3 Funnel de partage viral

| Étape | Event | Cible |
|---|---|---|
| Correction affichée | `cp_correction_shown` | baseline |
| Bouton partager cliqué | `cp_share_clicked` | ≥ 20 % des corrections |
| Retour via deep link | `cp_case_opened` + `$referrer = 'share'` | ≥ 5 % des partages |

---

## 2. Cohortes hebdomadaires

### 2.1 Définition des cohortes

| Cohorte | Filtre PostHog |
|---|---|
| **Active Week N** | A déclenché `cp_case_started` dans la semaine N |
| **Completed Week N** | A déclenché `cp_correction_shown` dans la semaine N |
| **Power Users** | ≥ 3 cas complétés en 7 jours |
| **At Risk** | Actif semaine N-2, inactif semaine N-1, inactif semaine N |

### 2.2 Dashboard PostHog — Cohortes

Créer un **Insight de rétention** (PostHog > Insights > Retention) :
- **Starting event** : `cp_case_started`
- **Returning event** : `cp_case_started`
- **Period** : Weekly
- **Cohort size** : 7 jours

Exporter les données chaque lundi à 9h00 (CET) vers un Google Sheet ou Slack via PostHog webhook.

---

## 3. Alertes drop-off automatiques

### 3.1 Configuration PostHog Alerts

Aller dans **PostHog > Alerts** et créer les alertes suivantes :

| Alerte | Condition | Canal |
|---|---|---|
| `funnel_step4_to_5_drop` | Conversion `cp_case_opened → cp_case_started` < 60 % sur 7 jours glissants | Slack #alerts-analytics |
| `funnel_step5_to_6_drop` | Conversion `cp_case_started → cp_correction_shown` < 50 % sur 7 jours | Slack #alerts-analytics |
| `share_rate_low` | `cp_share_clicked / cp_correction_shown` < 10 % sur 7 jours | Slack #alerts-analytics |
| `appeal_rate_spike` | `cp_appeal_created / cp_correction_shown` > 30 % sur 7 jours | Slack #alerts-product (potentiel bug engine) |
| `retention_d7_drop` | Rétention J7 < 15 % sur cohorte de la semaine | Slack #alerts-analytics |

### 3.2 Webhook Slack (exemple payload)

```json
{
  "text": "⚠️ *Alerte Analytics COP'IQ*",
  "blocks": [
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*funnel_step4_to_5_drop* — Conversion `case_opened → case_started` = *47 %* (seuil 60 %)\n<https://eu.posthog.com/project/xxx/insights/yyy|Voir le funnel>"
      }
    }
  ]
}
```

---

## 4. Dashboards PostHog recommandés

### 4.1 Dashboard "Activation Quotidienne"

Widgets :
1. **Funnel** : steps 1→6 (§1.1) — Vue J-7
2. **Trend** : `cp_case_started` par jour (7 derniers jours)
3. **Trend** : `cp_correction_shown` par jour
4. **Number** : taux de complétion moyen (`percent_score`) — moyenne sur 7 jours
5. **Pie** : répartition `difficulty` dans `cp_case_opened`

### 4.2 Dashboard "Engagement & Rétention"

Widgets :
1. **Rétention** : cohorte hebdo (§2.2)
2. **Table** : Top 10 cas les plus ouverts (`cp_case_opened.case_slug`)
3. **Trend** : `cp_appeal_created` par semaine
4. **Trend** : `cp_share_clicked` par semaine + `share_method` breakdown

### 4.3 Dashboard "Santé Engine"

Widgets :
1. **Distribution** : `cp_question_validated.percent_score` par bucket 0-20/20-40/40-60/60-80/80-100
2. **Trend** : taux `is_correct` par question_index (détecte les questions trop dures)
3. **Number** : taux d'appel (`cp_appeal_created / cp_question_validated`)

---

## 5. Events non-PII — récapitulatif complet

| Event | Propriétés loggées | Propriétés interdites |
|---|---|---|
| `cp_case_opened` | case_slug, theme_id, difficulty, total_questions | — |
| `cp_case_started` | case_slug, attempt_id, theme_id, difficulty | — |
| `cp_question_answered` | case_slug, attempt_id, question_index, total_questions, answer_length_chars | **texte de la réponse** |
| `cp_question_validated` | case_slug, attempt_id, question_index, score_obtained, score_max, is_correct | — |
| `cp_correction_shown` | case_slug, attempt_id, total_score, total_max, percent_score, is_first_attempt | — |
| `cp_appeal_created` | case_slug, attempt_id, question_index, correction_detail_id | — |
| `cp_share_clicked` | case_slug, percent_score, share_method | — |
| `cp_screen_viewed` | screen_name | — |

> **Règle PII** : ne jamais logger le texte libre saisi par l'utilisateur, son nom, son e-mail, son numéro, ni son adresse. Seule la longueur (`answer_length_chars`) est autorisée.

---

## 6. Intégration Flutter → PostHog

### 6.1 Ajouter le SDK (une seule fois, quand API key disponible)

```yaml
# pubspec.yaml
dependencies:
  posthog_flutter: ^4.0.0
```

```dart
// main.dart — après WidgetsFlutterBinding.ensureInitialized()
import 'package:posthog_flutter/posthog_flutter.dart';

await Posthog().setup(
  PostHogConfig(
    apiKey: const String.fromEnvironment('POSTHOG_API_KEY'),
    host: 'https://eu.posthog.com',
    captureApplicationLifecycleEvents: true,
    debug: kDebugMode,
  ),
);

CpAnalytics.I.bind(
  postHogApiKey: const String.fromEnvironment('POSTHOG_API_KEY'),
  postHogHost: 'https://eu.posthog.com',
  dynamicPostHog: Posthog(),
);
```

### 6.2 Identifier l'utilisateur à la connexion

```dart
// Dans le listener auth Supabase
supabase.auth.onAuthStateChange.listen((data) {
  final user = data.session?.user;
  CpAnalytics.I.identify(user?.id); // UUID uniquement, pas l'e-mail
});
```

### 6.3 Commandes de build (dart-define)

```bash
# Dev
flutter run --dart-define=POSTHOG_API_KEY=phc_DEV_KEY

# Release Android
flutter build apk --release \
  --dart-define=POSTHOG_API_KEY=phc_PROD_KEY

# Release iOS
flutter build ipa --release \
  --dart-define=POSTHOG_API_KEY=phc_PROD_KEY
```

---

*Dernière mise à jour : 2026-06-04 — CODE-074*
