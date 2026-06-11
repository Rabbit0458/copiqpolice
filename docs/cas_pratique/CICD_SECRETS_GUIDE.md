# 🔐 Guide des Secrets GitHub — COP'IQ CI/CD

> Tous ces secrets doivent être ajoutés dans **Settings → Secrets and variables → Actions** du repo GitHub.

---

## 📱 Android

| Secret | Description | Comment l'obtenir |
|--------|-------------|-------------------|
| `ANDROID_KEYSTORE_BASE64` | Keystore JKS encodé en base64 | `base64 -w0 your-keystore.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | Mot de passe du keystore | Valeur choisie à la génération |
| `ANDROID_KEY_ALIAS` | Alias de la clé | Ex : `copiq-release` |
| `ANDROID_KEY_PASSWORD` | Mot de passe de la clé | Valeur choisie à la génération |
| `GOOGLE_PLAY_JSON_KEY` | JSON service account Play Console | [Console Google Cloud → IAM → Comptes de service](https://console.cloud.google.com/iam-admin/serviceaccounts) |

### Générer le keystore Android

```bash
keytool -genkey -v \
  -keystore copiq-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias copiq-release \
  -dname "CN=COP'IQ, OU=Mobile, O=Copiq SAS, L=Paris, S=IDF, C=FR"

# Encoder en base64 pour le secret GitHub
base64 -w0 copiq-release.jks | pbcopy
```

### Configurer `android/app/build.gradle`

Assure-toi que le fichier `android/app/build.gradle` lit `android/key.properties` :

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

---

## 🍎 iOS

| Secret | Description | Comment l'obtenir |
|--------|-------------|-------------------|
| `MATCH_PASSWORD` | Passphrase pour chiffrer le repo Match | Valeur arbitraire — à conserver précieusement |
| `MATCH_GIT_BASIC_AUTHORIZATION` | `base64("user:personal_access_token")` | Génère un PAT GitHub avec accès au repo certs |
| `APP_STORE_CONNECT_API_KEY_ID` | ID de la clé API App Store Connect | [App Store Connect → Users & Access → Keys](https://appstoreconnect.apple.com/access/api) |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID (même page) | App Store Connect → Users & Access → Keys |
| `APP_STORE_CONNECT_API_KEY` | Contenu du fichier `.p8` téléchargé | Coller le contenu brut du fichier |
| `APPLE_ID` | Email du compte développeur Apple | Ex : `devteam@copiq.fr` |
| `APPLE_TEAM_ID` | Team ID Apple Developer | [developer.apple.com → Account → Membership](https://developer.apple.com/account/#!/membership/) |
| `ITC_TEAM_ID` | Team ID App Store Connect (si différent) | App Store Connect → Users & Access |

### Initialiser Fastlane Match

```bash
# 1. Créer un repo GitHub PRIVÉ : github.com/copiq/ios-certs (ne jamais pousser en public !)

# 2. Initialiser Match
cd fastlane
bundle exec fastlane match init
# → Type: git
# → URL: https://github.com/copiq/ios-certs.git

# 3. Générer les certs appstore
bundle exec fastlane match appstore
```

---

## 📊 Sentry

| Secret | Description | Comment l'obtenir |
|--------|-------------|-------------------|
| `SENTRY_DSN` | DSN du projet Flutter | [sentry.io → Settings → Projects → Client Keys](https://sentry.io) |
| `SENTRY_AUTH_TOKEN` | Token pour upload des sources | [sentry.io → Settings → Auth Tokens](https://sentry.io/settings/auth-tokens/) |
| `SENTRY_ORG` | Slug de l'organisation | Ex : `copiq-sas` (visible dans l'URL Sentry) |
| `SENTRY_PROJECT` | Slug du projet Flutter | Ex : `copiqpolice-flutter` |

---

## 📈 Analytics

| Secret | Description |
|--------|-------------|
| `POSTHOG_API_KEY` | Clé API PostHog (Project API Key) |
| `CODECOV_TOKEN` | Token Codecov pour upload couverture |

---

## 🚀 Workflow de release

```bash
# 1. Bumper la version dans pubspec.yaml
#    version: 1.0.0+1  →  version: 1.1.0+2

# 2. Committer + pusher
git add pubspec.yaml
git commit -m "chore: bump version to 1.1.0+2"
git push

# 3. Créer et pusher le tag → déclenche flutter-release.yml
git tag v1.1.0
git push origin v1.1.0
```

Le pipeline se déclenche automatiquement et :
1. ✅ Build + signe l'APK et l'AAB Android
2. ✅ Build + signe l'IPA iOS
3. ✅ Upload les symbols sur Sentry
4. ✅ Publie l'AAB sur le Play Store (internal track)
5. ✅ Publie l'IPA sur TestFlight
6. ✅ Crée une GitHub Release avec changelog auto

---

## 🐛 Debug local Fastlane

```bash
# Tester le build Android en local
cd fastlane
bundle exec fastlane android build_release

# Tester l'upload Play Store (dry run)
GOOGLE_PLAY_JSON_KEY=./google-play-key.json \
  bundle exec fastlane android deploy_internal

# Tester le build iOS en local
bundle exec fastlane ios build_release

# Voir les logs Fastlane détaillés
bundle exec fastlane android build_release --verbose
```
