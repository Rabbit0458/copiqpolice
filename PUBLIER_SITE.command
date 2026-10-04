#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
WEB_DIR="$SCRIPT_DIR/copiq-web"
BUNDLED_NODE="/Users/kaiso/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin"

cd "$WEB_DIR"

echo "COP'IQ — préparation du dossier fae16dc1"
echo "1/3 Vérification de l'environnement…"

if command -v npm >/dev/null 2>&1; then
  echo "2/3 Compilation et publication…"
  npm run release:hosting
elif [[ -x "$BUNDLED_NODE/node" && -d "$WEB_DIR/node_modules" ]]; then
  echo "2/3 Compilation et publication avec le runtime COP'IQ…"
  PATH="$BUNDLED_NODE:/usr/bin:/bin:/usr/sbin:/sbin" \
    "$BUNDLED_NODE/node" node_modules/next/dist/bin/next build
  PATH="$BUNDLED_NODE:/usr/bin:/bin:/usr/sbin:/sbin" \
    "$BUNDLED_NODE/node" scripts/publish-static.mjs
elif command -v pnpm >/dev/null 2>&1; then
  echo "2/3 Compilation et publication…"
  pnpm run release:hosting
else
  echo "Impossible de trouver Node.js. Installe Node.js 20 ou ouvre le projet dans Codex."
  exit 1
fi

echo "3/3 Terminé. Le dossier fae16dc1 peut être glissé chez l'hébergeur."
