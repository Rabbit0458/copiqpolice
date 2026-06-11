# COP'IQ — Cas Pratique — Performance tuning

Réf : `docs/cas_pratique/PROGRESSION_CODE.md` — CODE-077

Cible :
- **60 fps minimum** sur tout device
- **90 fps idéal** sur Pixel 8 / Galaxy S23+ / OnePlus 11
- **120 fps** sur iPhone 13 Pro / 14 Pro / 15 Pro (ProMotion)

---

## 1. Côté Flutter (déjà livré)

Module : `lib/core/performance/cp_performance_utils.dart`

| Helper | Rôle |
|---|---|
| `CpImagePrecache.warmUp(ctx)` | Précache les images critiques au boot |
| `CpAdaptiveResolution.suffix(ctx)` | Sert `@1x`/`@2x`/`@3x` selon le DPR |
| `CpSliverHelpers.list(...)` | `SliverList` optimisé (no keep-alive, repaint boundaries, semantic indexes) |
| `CpFramePacing.currentRefreshRate(ctx)` | Lit le refresh rate natif |
| `CpJankMonitor.start(onReport: ...)` | Mesure les frame drops et reporte à Sentry / PostHog |

À câbler dans `main.dart` après init Supabase :

```dart
CpJankMonitor.start(
  onReport: (snap) => CpAnalytics.I.screenViewed(
    'cp_jank_report',
    extra: snap.toJson(),
  ),
);
```

---

## 2. Côté iOS — ProMotion 120 Hz

`ios/Runner/Info.plist` → ajouter cette clé :

```xml
<key>CADisableMinimumFrameDurationOnPhone</key>
<true/>
```

Sans cette clé, iOS **plafonne Flutter à 60 fps** même sur iPhone Pro.

### Vérification

```bash
flutter run --profile -d <iphone-pro-id>
# Dans DevTools → Performance → vérifier "GPU rasterizer" à 8.3ms / frame
```

---

## 3. Côté Android — High Refresh Rate

`android/app/build.gradle.kts` → vérifier que `minSdk >= 23` (Marshmallow). Déjà OK
(`minSdk 21` est trop bas pour `Window.setFrameRate` mais Android 23+ active
automatiquement le high refresh rate si le device le supporte et que l'app n'a
pas de `targetSdk` trop bas).

Pour forcer le high refresh rate sur tout l'écran (recommandé) :

`android/app/src/main/AndroidManifest.xml` → dans `<activity>` :

```xml
<meta-data
    android:name="io.flutter.embedding.android.EnableOnBackInvokedCallback"
    android:value="true" />
```

Et dans `MainActivity.kt`, surcharger `onCreate` :

```kotlin
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    // High refresh rate sur Android 11+
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
        val display = window.windowManager.defaultDisplay
        val supportedModes = display.supportedModes
        val highestMode = supportedModes.maxByOrNull { it.refreshRate }
        if (highestMode != null) {
            window.attributes = window.attributes.apply {
                preferredDisplayModeId = highestMode.modeId
            }
        }
    }
}
```

### Vérification

```bash
flutter run --profile -d <pixel-8-id>
adb shell dumpsys SurfaceFlinger | grep -i "refresh-rate"
# Doit afficher 90Hz ou 120Hz
```

---

## 4. Patterns Flutter à respecter

✅ **À FAIRE**
- `const` partout où possible (widgets, EdgeInsets, BorderRadius...)
- `SliverList` / `SliverGrid` pour les listes > 30 items
- `cached_network_image` pour les images réseau (déjà dans la roadmap CODE-077)
- `RepaintBoundary` autour des animations isolées
- `AutomaticKeepAliveClientMixin` UNIQUEMENT pour les `TabBarView` actifs
- Précacher les images critiques au boot

❌ **À ÉVITER**
- `setState` qui rebuild toute la page (préférer `ValueListenableBuilder` / `Selector`)
- `Opacity` à 1.0 ou 0.0 (utiliser `Visibility` ou conditional widgets)
- `BackdropFilter` superposés (très cher GPU)
- `Image.network` sans cache
- `Column` avec scroll dans un `SingleChildScrollView` quand on a > 50 items (passer en `Sliver*`)

---

## 5. Budget par frame

| Refresh rate | Budget total | Build budget | Raster budget |
|---|---|---|---|
| 60 Hz | 16.67 ms | 8 ms | 8 ms |
| 90 Hz | 11.11 ms | 5 ms | 6 ms |
| 120 Hz | 8.33 ms | 4 ms | 4 ms |

Au-delà → frame skippée → jank visible.

---

## 6. Profiling

```bash
# DevTools (recommandé)
flutter run --profile
# Puis F9 ou DevTools > Performance > "Start recording"

# Timeline JSON
flutter run --profile --trace-startup
# Le json est dans build/start_up_info.json

# Inspecter les frames lentes
flutter run --profile --observatory-port=8888
```

Cible :
- **avg frame build** < 5 ms
- **p99 frame total** < 16.67 ms (60fps) ou 11.11 ms (90fps)
- **jank ratio** < 1% (CpJankMonitor)

---

## 7. Checklist de release

- [ ] `flutter build apk --release --analyze-size` → APK < 25 MB
- [ ] `flutter build ipa --release` → IPA < 50 MB
- [ ] Toutes les images optimisées (TinyPNG / webp)
- [ ] `flutter run --profile` sur Pixel 8 → 90fps stable
- [ ] `flutter run --profile` sur iPhone Pro → 120fps stable
- [ ] `CpJankMonitor` jank_ratio < 1% sur 100 cas joués
- [ ] DevTools → Memory → pas de leak > 50 MB sur 30min d'usage
