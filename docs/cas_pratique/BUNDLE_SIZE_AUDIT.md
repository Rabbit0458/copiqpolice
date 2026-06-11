# COP'IQ — Cas Pratique — Audit bundle size & compression

Réf : `docs/cas_pratique/PROGRESSION_CODE.md` — CODE-078

Cible : **APK < 25 MB**, **IPA < 50 MB**.

---

## 1. Lancer l'audit

```bash
# Scan rapide des assets sans build
python tools/audit_bundle_size.py --candidates

# Audit Android complet (build + analyse)
python tools/audit_bundle_size.py --android

# Audit iOS complet (nécessite Xcode / Mac)
python tools/audit_bundle_size.py --ios

# Les deux
python tools/audit_bundle_size.py --android --ios
```

Le script produit un rapport avec :
- Taille totale + comparaison à la cible
- Top 20 items par poids
- Répartition par type (.dart, .png, .so, etc.)
- Candidats compression (PNG > 100 KB, polices > 100 KB)
- Gain estimé après optimisation

---

## 2. PNG → WebP

WebP gagne **typiquement 60-80 %** sur les PNG photos / illustrations.

### Conversion automatique

```bash
# Convertir tous les PNG dans assets/images/ en WebP
# (Linux/Mac)
for f in assets/images/**/*.png; do
  cwebp -q 85 -m 6 -mt "$f" -o "${f%.png}.webp"
done

# Windows PowerShell
Get-ChildItem -Recurse assets/images -Filter *.png | ForEach-Object {
  cwebp -q 85 -m 6 -mt $_.FullName -o ($_.FullName -replace '\.png$', '.webp')
}
```

Installer `cwebp` :
- Windows : [https://developers.google.com/speed/webp/download](https://developers.google.com/speed/webp/download)
- Mac : `brew install webp`
- Linux : `apt install webp`

### Côté Flutter

Flutter charge automatiquement les `.webp` via `AssetImage` / `Image.asset`. **Aucun changement de code** sauf si le path est hardcodé avec `.png` :

```dart
// Avant
Image.asset('assets/images/logo.png')

// Après (le moteur charge le webp en priorité s'il existe)
Image.asset('assets/images/logo.webp')
```

### Ne PAS convertir

- Les icônes < 10 KB (gain négligeable, perte de qualité possible)
- Les icônes avec transparence stricte (PNG-8 reste meilleur)
- `assets/icon_profile/` (déjà optimisées)

---

## 3. Icônes en SVG

Les icônes UI doivent être **vectorielles** :

```yaml
# pubspec.yaml
dependencies:
  flutter_svg: ^2.0.10+1
```

```dart
SvgPicture.asset('assets/icons/share.svg', width: 24, height: 24)
```

Gain typique : un PNG icône @3x de 4 KB devient un SVG de 800 bytes (≈ -80%).

Source d'icônes optimisées : [https://lucide.dev/](https://lucide.dev/) (déjà utilisé en React).

---

## 4. Polices en subsets

Les polices `InstrumentSans-*.ttf` font ~120 KB chacune × 8 = ~1 MB.

### Option A — subset Latin (recommandé)

Garder uniquement les caractères Latin + accents français + ponctuation.

```bash
# Installer fonttools
pip install fonttools brotli

# Créer un subset (caractères Latin + français + symboles courants)
pyftsubset assets/fonts/InstrumentSans-Regular.ttf \
  --output-file=assets/fonts/InstrumentSans-Regular-subset.ttf \
  --unicodes="U+0020-007E,U+00A0-00FF,U+0152-0153,U+2013-2014,U+2018-201D,U+20AC"
```

Gain : ~40-60% par police.

### Option B — Google Fonts dynamique (déjà en place)

Le package `google_fonts: ^8.1.0` télécharge les polices à la demande depuis le CDN Google.

**Inconvénient** : nécessite Internet au 1er lancement.  
**Avantage** : 0 KB dans le bundle.

Si on accepte le coût réseau initial, on peut supprimer **toutes** les polices de `assets/fonts/` et perdre ~1 MB de bundle.

---

## 5. Splitting des architectures (Android)

```bash
# Build par ABI (au lieu d'un fat APK)
flutter build apk --split-per-abi --release
```

Produit 3 APK :
- `app-armeabi-v7a-release.apk` (~16 MB)
- `app-arm64-v8a-release.apk` (~18 MB)
- `app-x86_64-release.apk` (~19 MB)

→ Le Play Store sert le bon APK selon le device. Économie : ~30% par utilisateur.

**Ou** publier en **App Bundle** (`.aab`) qui fait la même chose automatiquement :

```bash
flutter build appbundle --release
```

C'est la méthode **recommandée par Google Play** depuis 2021.

---

## 6. Tree-shaking & code-shaking

Flutter fait du tree-shaking automatique en `--release`. À vérifier :

```bash
# Inspecte les .dart restants dans le bundle
flutter build apk --release --analyze-size --target-platform=android-arm64

# Ouvre l'analyse dans DevTools
flutter pub global activate devtools
flutter pub global run devtools
# Puis "Open File" sur le JSON dans build/
```

### Patterns qui tuent le tree-shaking

❌ `import 'package:foo/foo.dart' show *;`  
❌ Réflexion (`dart:mirrors` — déjà pas dispo en release)  
❌ Méthodes appelées dynamiquement via reflection-like

✅ Imports nommés explicites  
✅ `const` partout  
✅ Pas de `Map<String, Function>` de handlers (préférer le pattern matching)

---

## 7. Audit régulier

Ajouter un hook CI/CD :

```yaml
# .github/workflows/bundle-size.yml
- name: Audit bundle size
  run: python tools/audit_bundle_size.py --android

- name: Fail if APK > 25 MB
  run: |
    size_mb=$(stat -c%s build/app/outputs/flutter-apk/app-release.apk | awk '{print $1/1024/1024}')
    if (( $(echo "$size_mb > 25" | bc -l) )); then
      echo "❌ APK is $size_mb MB > 25 MB target"
      exit 1
    fi
```

---

## 8. Checklist release

- [ ] `python tools/audit_bundle_size.py --candidates` → 0 PNG > 100 KB
- [ ] Polices en subset OU `google_fonts` dynamique
- [ ] Icônes UI en SVG (pas en PNG)
- [ ] `flutter build appbundle --release` (pas `--apk`)
- [ ] `flutter build ipa --release --analyze-size`
- [ ] CI/CD vérifie la taille
- [ ] Tree-shaking sain (pas de `.dart` mort en bundle)
