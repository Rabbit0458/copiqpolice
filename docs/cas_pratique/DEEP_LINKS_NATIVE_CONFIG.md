# Deep Links — Configuration Natif (CODE-071)

> **Status** : Configuration Dart ✅ livrée — Config native ⚠️ à faire manuellement par Kaïs  
> Handler : `lib/core/cas_pratique/deep_links/cp_deep_links_handler.dart`  
> URL cible : `https://app.copiq.fr/c/<slug>`

---

## Pourquoi faire manuellement ?

Les fichiers `android/app/src/main/AndroidManifest.xml` et `ios/Runner/Runner.entitlements`
sont hors du périmètre autorisé aux sessions autonomes (risque de casser le build natif).
Les modifications ci-dessous sont précises et sans ambiguïté — copier-coller suffit.

---

## 1. Android — AndroidManifest.xml

**Fichier** : `android/app/src/main/AndroidManifest.xml`

Ajouter dans le bloc `<activity android:name=".MainActivity" ...>`, **après** les intent-filters existants :

```xml
<!-- CODE-071 : Universal App Links — app.copiq.fr -->
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" android:host="app.copiq.fr" />
</intent-filter>
```

---

## 2. iOS — Runner.entitlements

**Fichier** : `ios/Runner/Runner.entitlements`

Si le fichier n'existe pas, le créer à côté de `Info.plist` avec ce contenu :

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.associated-domains</key>
    <array>
        <string>applinks:app.copiq.fr</string>
    </array>
</dict>
</plist>
```

Si le fichier existe déjà (avec `applinks:copiqpolice.app`), ajouter **uniquement** :
```xml
<string>applinks:app.copiq.fr</string>
```
dans le tableau `com.apple.developer.associated-domains`.

> **Xcode** : ouvrir `ios/Runner.xcworkspace` → Target Runner → Signing & Capabilities
> → Associated Domains → ajouter `applinks:app.copiq.fr`

---

## 3. Fichiers well-known serveur (hébergeur app.copiq.fr)

### Android — assetlinks.json

Créer `https://app.copiq.fr/.well-known/assetlinks.json` :

```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "fr.copiq.police",
    "sha256_cert_fingerprints": [
      "REMPLACER_PAR_SHA256_DU_KEYSTORE_RELEASE"
    ]
  }
}]
```

> Obtenir le SHA256 : `keytool -list -v -keystore upload-keystore.jks -alias upload`

### iOS — apple-app-site-association

Créer `https://app.copiq.fr/.well-known/apple-app-site-association` :

```json
{
  "applinks": {
    "apps": [],
    "details": [{
      "appID": "TEAMID.fr.copiq.police",
      "paths": ["/c/*"]
    }]
  }
}
```

> Remplacer `TEAMID` par ton Apple Team ID (visible dans developer.apple.com).  
> Le fichier doit être servi sans redirection, avec `Content-Type: application/json`.

---

## 4. iOS — Info.plist (scheme custom)

Si `copiqpolice://cas/<slug>` doit fonctionner aussi (scheme custom) :

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>copiqpolice</string>
    </array>
  </dict>
</array>
```

(Probablement déjà présent depuis le service existant — vérifier avant d'ajouter.)

---

## 5. Test en local

### Android
```bash
adb shell am start \
  -W -a android.intent.action.VIEW \
  -d "https://app.copiq.fr/c/case_1?utm_source=test" \
  fr.copiq.police
```

### iOS (simulateur)
```bash
xcrun simctl openurl booted "https://app.copiq.fr/c/case_1?utm_source=test"
```

### Résultat attendu
L'app ouvre directement `CasPratiqueDynamicPage` avec `caseSlug = 'case_1'`.  
Log dans la console :
```
[CpDeepLinks] → /gpx_exam/concours/cas_pratique/case_dynamic (slug: case_1, utm: CpUtmData({utm_source: test}))
```

---

## 6. UTM Tracking (prêt pour CODE-073)

Le handler log déjà les UTM params via `debugPrint`.
Quand CODE-073 (PostHog/Mixpanel) sera livré, décommenter le bloc `TODO` dans
`CpDeepLinksHandler._logUtm()` et remplacer par :

```dart
analytics_service.track('deep_link_opened', {
  'case_slug': slug,
  ...utm.toMap(),
});
```

---

## 7. Génération d'URLs de partage

Utiliser `CpDeepLinksHandler.I.shareUrl(slug, utmSource: 'share', utmMedium: 'app')` :

```dart
// Dans le bouton de partage :
final url = CpDeepLinksHandler.I.shareUrl(
  widget.caseSlug,
  utmSource: 'share',
  utmMedium: 'app',
  utmCampaign: 'cas_pratique_v1',
);
// Résultat : https://app.copiq.fr/c/case_1?utm_source=share&utm_medium=app&utm_campaign=cas_pratique_v1
```
