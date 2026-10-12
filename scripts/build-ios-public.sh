#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo 'Ce script doit etre lance sur le MacBook avec Xcode.' >&2
  exit 1
fi

for tool in flutter pod xcodebuild; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Outil manquant : $tool" >&2
    exit 1
  fi
done

if [[ ! -f config/revenuecat.public.json ]]; then
  echo 'Configuration publique RevenueCat manquante.' >&2
  exit 1
fi

xcodebuild -version
flutter --version
flutter pub get
flutter analyze
flutter test
flutter build ipa --release --export-method app-store \
  --dart-define-from-file=config/revenuecat.public.json

echo 'IPA generee dans build/ios/ipa. Aucun envoi ni soumission automatique.'
echo 'Tester ce build sur TestFlight avant la soumission publique.'
open build/ios/ipa
