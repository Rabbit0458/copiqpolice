"""
COP'IQ — Cas Pratique — Audit bundle size
Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-078

Lance `flutter build apk/ipa --analyze-size`, parse les outputs JSON et
imprime un rapport :
  • Taille totale APK / IPA
  • Top 20 assets/libs par poids
  • Comparaison vs cibles (APK < 25 MB, IPA < 50 MB)
  • Détection automatique des PNG > 100 KB (candidats WebP)
  • Détection des polices entières (candidates subsets)

Usage :
  python audit_bundle_size.py --android
  python audit_bundle_size.py --ios
  python audit_bundle_size.py --android --ios --report
"""

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path

# ──────────────────────────────────────────────────────────────────────────
#  CONFIG
# ──────────────────────────────────────────────────────────────────────────

PROJECT_ROOT = Path(__file__).resolve().parent.parent
TARGET_APK_MB = 25
TARGET_IPA_MB = 50
PNG_WEBP_THRESHOLD_KB = 100  # PNG plus gros que ça → candidat WebP
TOP_N = 20

# ──────────────────────────────────────────────────────────────────────────
#  UTILS
# ──────────────────────────────────────────────────────────────────────────


def human_size(n_bytes: int) -> str:
    """Formate une taille en bytes en KB/MB/GB lisible."""
    for unit in ("B", "KB", "MB", "GB"):
        if n_bytes < 1024:
            return f"{n_bytes:.1f} {unit}"
        n_bytes /= 1024
    return f"{n_bytes:.1f} TB"


def run(cmd: list[str], cwd: Path = PROJECT_ROOT) -> int:
    """Lance une commande shell, stream le stdout."""
    print(f"$ {' '.join(cmd)}")
    return subprocess.call(cmd, cwd=cwd)


# ──────────────────────────────────────────────────────────────────────────
#  PARSE FLUTTER BUILD JSON
# ──────────────────────────────────────────────────────────────────────────


def find_analysis_json(build_dir: Path) -> Path | None:
    """Trouve le dernier fichier d'analyse JSON généré par flutter build."""
    candidates = sorted(build_dir.glob("**/apk-code-size-analysis_*.json"))
    candidates += sorted(build_dir.glob("**/ios-code-size-analysis_*.json"))
    return candidates[-1] if candidates else None


def parse_size_tree(node: dict, prefix: str = "") -> list[tuple[str, int]]:
    """Parse l'arbre récursif de tailles renvoyé par Flutter.
    Retourne une liste plate (path, size_bytes)."""
    out: list[tuple[str, int]] = []
    name = node.get("n", "")
    size = node.get("value", 0)
    full = f"{prefix}/{name}" if prefix else name
    children = node.get("children")
    if children:
        for c in children:
            out.extend(parse_size_tree(c, full))
    else:
        out.append((full, size))
    return out


def analyze_json(json_path: Path) -> dict:
    """Lit le JSON Flutter et produit un rapport agrégé."""
    data = json.loads(json_path.read_text(encoding="utf-8"))
    root = data.get("apk") or data.get("ios") or data
    items = parse_size_tree(root)
    items.sort(key=lambda x: -x[1])

    total = sum(s for _, s in items)
    top = items[:TOP_N]
    by_type = {}
    for path, size in items:
        ext = Path(path).suffix.lower() or "<no-ext>"
        by_type[ext] = by_type.get(ext, 0) + size

    return {
        "total_bytes": total,
        "items_count": len(items),
        "top": top,
        "by_type": sorted(by_type.items(), key=lambda x: -x[1]),
    }


# ──────────────────────────────────────────────────────────────────────────
#  HEURISTIQUES — assets candidats compression
# ──────────────────────────────────────────────────────────────────────────


def find_compression_candidates() -> dict:
    """Scan assets/ pour identifier les fichiers à optimiser."""
    assets_dir = PROJECT_ROOT / "assets"
    if not assets_dir.exists():
        return {"png_large": [], "fonts_full": []}

    png_large = []
    for png in assets_dir.glob("**/*.png"):
        size = png.stat().st_size
        if size > PNG_WEBP_THRESHOLD_KB * 1024:
            png_large.append((str(png.relative_to(PROJECT_ROOT)), size))
    png_large.sort(key=lambda x: -x[1])

    fonts_full = []
    fonts_dir = assets_dir.parent / "assets" / "fonts"
    if fonts_dir.exists():
        for f in fonts_dir.glob("**/*.ttf"):
            size = f.stat().st_size
            if size > 100 * 1024:
                fonts_full.append((str(f.relative_to(PROJECT_ROOT)), size))
    fonts_full.sort(key=lambda x: -x[1])

    return {"png_large": png_large, "fonts_full": fonts_full}


# ──────────────────────────────────────────────────────────────────────────
#  RAPPORT
# ──────────────────────────────────────────────────────────────────────────


def print_section(title: str):
    print()
    print("═" * 72)
    print(f"  {title}")
    print("═" * 72)


def report_build(platform: str, analysis: dict, target_mb: int):
    print_section(f"BUNDLE SIZE — {platform.upper()}")
    total_mb = analysis["total_bytes"] / (1024 * 1024)
    print(f"Taille totale  : {human_size(analysis['total_bytes'])} ({total_mb:.1f} MB)")
    print(f"Cible          : < {target_mb} MB")
    delta = total_mb - target_mb
    if delta <= 0:
        print(f"Status         : ✅ OK ({-delta:.1f} MB sous la cible)")
    else:
        print(f"Status         : ⚠️ DÉPASSÉ de {delta:.1f} MB")

    print()
    print(f"TOP {TOP_N} ITEMS PAR TAILLE :")
    for i, (path, size) in enumerate(analysis["top"], 1):
        print(f"  {i:>2}. {human_size(size):>10}  {path}")

    print()
    print("RÉPARTITION PAR TYPE :")
    for ext, size in analysis["by_type"][:10]:
        pct = (size / analysis["total_bytes"]) * 100
        print(f"  {ext:<10}  {human_size(size):>10}  ({pct:.1f}%)")


def report_candidates(c: dict):
    print_section("CANDIDATS COMPRESSION")
    if c["png_large"]:
        print()
        print(f"⚠️  PNG > {PNG_WEBP_THRESHOLD_KB} KB (passer en WebP) :")
        for path, size in c["png_large"][:20]:
            print(f"   {human_size(size):>10}  {path}")
        total = sum(s for _, s in c["png_large"])
        # WebP économise typiquement 60-80%
        savings = total * 0.70
        print(f"   → Gain estimé en WebP : ~{human_size(savings)}")
    else:
        print("✅ Pas de PNG > 100 KB.")

    if c["fonts_full"]:
        print()
        print("⚠️  POLICES > 100 KB (envisager subset Latin) :")
        for path, size in c["fonts_full"][:10]:
            print(f"   {human_size(size):>10}  {path}")
        total = sum(s for _, s in c["fonts_full"])
        # Un subset Latin économise typiquement 50%
        savings = total * 0.50
        print(f"   → Gain estimé en subset : ~{human_size(savings)}")
    else:
        print("✅ Pas de polices > 100 KB.")


# ──────────────────────────────────────────────────────────────────────────
#  COMMANDES BUILD
# ──────────────────────────────────────────────────────────────────────────


def build_android():
    print_section("BUILD ANDROID")
    code = run(
        [
            "flutter",
            "build",
            "apk",
            "--release",
            "--analyze-size",
            "--target-platform=android-arm64",
        ]
    )
    if code != 0:
        print(f"❌ Build Android failed (exit {code})")
        return None
    build_dir = PROJECT_ROOT / "build"
    json_path = find_analysis_json(build_dir)
    if not json_path:
        print("⚠️ Pas de JSON d'analyse trouvé.")
        return None
    print(f"📊 Analyse JSON : {json_path.relative_to(PROJECT_ROOT)}")
    return analyze_json(json_path)


def build_ios():
    print_section("BUILD iOS")
    code = run(
        [
            "flutter",
            "build",
            "ipa",
            "--release",
            "--analyze-size",
        ]
    )
    if code != 0:
        print(f"❌ Build iOS failed (exit {code})")
        return None
    build_dir = PROJECT_ROOT / "build"
    json_path = find_analysis_json(build_dir)
    if not json_path:
        print("⚠️ Pas de JSON d'analyse trouvé.")
        return None
    print(f"📊 Analyse JSON : {json_path.relative_to(PROJECT_ROOT)}")
    return analyze_json(json_path)


# ──────────────────────────────────────────────────────────────────────────
#  MAIN
# ──────────────────────────────────────────────────────────────────────────


def main():
    parser = argparse.ArgumentParser(description="Audit bundle size COP'IQ")
    parser.add_argument("--android", action="store_true", help="Audit Android")
    parser.add_argument("--ios", action="store_true", help="Audit iOS")
    parser.add_argument(
        "--candidates",
        action="store_true",
        help="Scan assets pour candidats compression seulement (pas de build)",
    )
    args = parser.parse_args()

    if not (args.android or args.ios or args.candidates):
        parser.print_help()
        sys.exit(1)

    if args.candidates:
        c = find_compression_candidates()
        report_candidates(c)
        return

    if args.android:
        a = build_android()
        if a:
            report_build("android", a, TARGET_APK_MB)

    if args.ios:
        a = build_ios()
        if a:
            report_build("ios", a, TARGET_IPA_MB)

    # Toujours rapport candidats à la fin
    c = find_compression_candidates()
    report_candidates(c)


if __name__ == "__main__":
    main()
