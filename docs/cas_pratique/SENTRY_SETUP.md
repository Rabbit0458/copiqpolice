# 🛰️ COP'IQ — Sentry / Crashlytics setup (CODE-053)

Guide d'intégration du wrapper `lib/core/monitoring/sentry_setup.dart` pour la production.

---

## 1. Dépendance Flutter

Ajouter dans **`pubspec.yaml`** sous `dependencies:` :

```yaml
dependencies:
  sentry_flutter: ^8.10.0
```

Puis :

```bash
flutter pub get
```

---

## 2. DSN & variables `--dart-define`

Le wrapper lit 4 variables d'environnement (JAMAIS hard-codées) :

| Variable                       | Valeurs                                      | Par défaut             |
|--------------------------------|----------------------------------------------|------------------------|
| `SENTRY_DSN`                   | DSN public Sentry (`https://…@sentry.io/…`) | vide → no-op           |
| `SENTRY_ENV`                   | `prod` / `staging` / `dev`                   | `dev`                  |
| `APP_RELEASE`                  | `copiqpolice@1.0.0+12`                        | `copiqpolice@unknown`  |
| `SENTRY_TRACES_SAMPLE_RATE`    | `0.0` … `1.0`                                | `0.1` (10 %)           |

Exemple de commande complète :

```bash
flutter run \
  --dart-define=SENTRY_DSN="https://xxxxxx@o111111.ingest.sentry.io/2222222" \
  --dart-define=SENTRY_ENV=prod \
  --dart-define=APP_RELEASE=copiqpolice@1.0.0+12 \
  --dart-define=SENTRY_TRACES_SAMPLE_RATE=0.1
```

> 🔒 **Si `SENTRY_DSN` est vide** (mode dev sans monitoring), Sentry n'est PAS initialisé et toutes les API (`AppMonitoring.captureException`, etc.) sont des no-op silencieux. Aucune perf cost, aucun crash possible côté SDK.

---

## 3. Wiring dans `main.dart`

Le wiring est volontairement **non automatique** pour respecter la règle « pas de breaking change dans main.dart ». Coller ces 3 ajouts dans l'entry point :

```dart
import 'package:copiqpolice/core/monitoring/sentry_setup.dart';

Future<void> main() async {
  // remplacer `runApp(...)` par :
  await runAppWithMonitoring(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // ... le reste de l'init existante (Supabase, etc.) ...
    runApp(const MyApp());
  });
}
```

Puis dans le handler d'auth (signedIn / signedOut), idéalement à côté du wiring `CasPratiqueAppealsListener` :

```dart
// signedIn
await AppMonitoring.setUserId(id: u!.id, email: u.email);

// signedOut
await AppMonitoring.clearUser();
```

---

## 4. Android — configuration native

Aucune dépendance native obligatoire (Sentry est full-Dart pour Android). Mais pour les **stack traces des binaires Kotlin/Java** :

`android/app/build.gradle` :

```groovy
android {
  buildTypes {
    release {
      // Permet à Sentry de récupérer les mappings ProGuard/R8
      minifyEnabled true
      shrinkResources true
      proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'),
                    'proguard-rules.pro'
    }
  }
}
```

`android/app/proguard-rules.pro` (créer si absent) :

```pro
# Sentry Flutter
-keep class io.sentry.** { *; }
```

---

## 5. iOS — configuration native

`ios/Runner/Info.plist` — ajouter si vous voulez activer le **dSYM upload** (recommandé pour la release) :

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <false/>
</dict>
```

Et dans `ios/Podfile`, après `target 'Runner' do` :

```ruby
# Sentry — pas de pod natif requis avec sentry_flutter ≥ 8.x.
# Si vous montez en version ≥ 9 avec native crash handler :
# pod 'Sentry', '~> 8.18'
```

---

## 6. Source-maps & dSYM upload (release)

Pour avoir des stack traces lisibles en production, il faut uploader les symboles à chaque release.

### CLI Sentry

```bash
brew install getsentry/tools/sentry-cli   # macOS
# ou via npm : npm install -g @sentry/cli
```

Ajouter à **`.github/workflows/flutter-release.yml`** (CODE-097) :

```yaml
- name: Upload Flutter symbols to Sentry
  env:
    SENTRY_AUTH_TOKEN: ${{ secrets.SENTRY_AUTH_TOKEN }}
    SENTRY_ORG: copiqpolice
    SENTRY_PROJECT: copiqpolice-flutter
  run: |
    flutter build apk --release \
      --dart-define=SENTRY_DSN=$SENTRY_DSN \
      --dart-define=APP_RELEASE=copiqpolice@${{ github.ref_name }} \
      --split-debug-info=./build/symbols \
      --obfuscate
    sentry-cli debug-files upload \
      --org $SENTRY_ORG \
      --project $SENTRY_PROJECT \
      ./build/symbols
    sentry-cli releases new "copiqpolice@${{ github.ref_name }}"
    sentry-cli releases finalize "copiqpolice@${{ github.ref_name }}"
```

(Idem pour iOS : `flutter build ipa --split-debug-info=...`.)

---

## 7. Alertes admin (Slack / email)

Côté **dashboard Sentry** :

1. **Alerts → Create Alert** → "An issue is created"
2. Filtres :
   - `level >= error`
   - `tags.module == cas_pratique`
3. Actions :
   - Send notification to **Slack** channel `#copiqpolice-incidents`
   - Send email to `dev@copiqpolice.fr`

Recommandation : créer 3 règles distinctes pour ne pas spammer :
- **P0** : crash apps (level=fatal) → immediate
- **P1** : engine_crashed côté backend → every 5 min batch
- **P2** : warning level → digest journalier

---

## 8. Sample policy

| Type d'événement                       | Sample rate  | Justification                              |
|----------------------------------------|--------------|--------------------------------------------|
| Crash / exception non gérée            | **100 %**    | trop critique pour échantillonner          |
| Performance trace (transactions)       | **10 %**     | équilibre coût / signal                    |
| Breadcrumbs (debug)                    | tous attachés au crash | gratuit, ne pèse que sur les events envoyés |
| Custom messages (`captureMessage`)     | 100 %        | en général voulu                            |

Override via `--dart-define=SENTRY_TRACES_SAMPLE_RATE=0.05` si la facture grimpe.

---

## 9. Test local rapide

```bash
flutter run \
  --dart-define=SENTRY_DSN="<DSN_DEV>" \
  --dart-define=SENTRY_ENV=staging \
  --dart-define=APP_RELEASE=copiqpolice@local
```

Puis depuis n'importe quel widget :

```dart
ElevatedButton(
  onPressed: () => AppMonitoring.captureMessage(
    'Test depuis le bouton',
    level: SentryLevel.warning,
  ),
  child: const Text('Test Sentry'),
);
```

Vérifier que l'event apparaît dans le dashboard Sentry sous `environment: staging`.

---

## 10. Privacy

- `sendDefaultPii = false` : pas d'IP / User-Agent envoyés par défaut
- `setUserId(id: …)` envoie uniquement l'UUID Supabase de l'utilisateur (pas d'email/pseudo sauf si explicitement fourni)
- `module: cas_pratique` tagué automatiquement sur chaque event → filtrage facile

---

**Quand ces 10 étapes sont validées, Sentry est prêt pour la production.** 🚀
