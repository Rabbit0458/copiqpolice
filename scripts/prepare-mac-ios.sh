#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo 'Ce script doit être lancé sur le Mac avec Xcode installé.' >&2
  exit 1
fi
for tool in flutter pod xcodebuild; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Outil manquant : $tool. Installer Flutter, Xcode et CocoaPods avant de continuer." >&2
    exit 1
  fi
done
xcodebuild -version
flutter --version
# Regenerate Windows-specific generated paths on this Mac.
flutter pub get
flutter build ios --config-only --release --no-codesign \
  --dart-define-from-file=config/revenuecat.public.json
(
  cd ios
  pod install
)
echo 'Projet préparé. Dans Xcode : Runner, équipe W2S6S626U9, puis votre iPhone.'
open ios/Runner.xcworkspace
