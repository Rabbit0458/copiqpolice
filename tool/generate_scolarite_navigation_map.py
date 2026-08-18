#!/usr/bin/env python3
"""Génère la cartographie exhaustive GPX/PA depuis les sources Flutter."""

from __future__ import annotations

import json
import math
import re
from collections import Counter, defaultdict
from datetime import datetime
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
SOURCES = ROOT / "progression/migration_data/sources.jsonl"
MARKDOWN = ROOT / "progression/CARTOGRAPHIE_COMPLETE_SCOLARITE_GPX_PA.md"
PNG = ROOT / "progression/CARTOGRAPHIE_PYRAMIDALE_SCOLARITE_GPX_PA.png"
ROUTER = ROOT / "lib/routes/app_router.dart"
EXPECTED = 1409

ROUTE_RE = re.compile(r"['\"](/(?:gpx|pa)[^'\"]*)['\"]")
CLASS_RE = re.compile(r"\bclass\s+([A-Z][A-Za-z0-9_]*)\b")
CTOR_RE = re.compile(r"\b(?:const\s+)?([A-Z][A-Za-z0-9_]*(?:Page|Screen|Quiz))\s*\(")
ROUTE_ENTRY_RE = re.compile(
    r"['\"](/(?:gpx|pa)[^'\"]*)['\"]\s*:\s*\([^)]*\)\s*=>\s*(?:const\s+)?([A-Z][A-Za-z0-9_]*)\s*\(",
    re.MULTILINE,
)
ROUTE_BLOCK_RE = re.compile(
    r"['\"](/(?:gpx|pa)[^'\"]*)['\"]\s*:\s*\([^)]*\)\s*\{(.*?)(?=\n\s{4}(?:['\"]/(?:gpx|pa)|[A-Z][A-Za-z0-9_]*\.routeName)|\n\s{2}\};)",
    re.MULTILINE | re.DOTALL,
)
RETURN_CLASS_RE = re.compile(r"\breturn\s+(?:const\s+)?([A-Z][A-Za-z0-9_]*)\s*\(")


def clean(value: object) -> str:
    return str(value or "").replace("|", "\\|").replace("\n", " ").strip()


def label_from_path(value: str) -> str:
    value = re.sub(r"\.dart$", "", value)
    value = re.sub(r"_(?:contenu_)?page$", "", value)
    value = value.replace("_", " ").replace("-", " ")
    return " ".join(part.capitalize() for part in value.split())


def load_sources() -> list[dict]:
    rows = []
    with SOURCES.open(encoding="utf-8") as handle:
        for line in handle:
            if line.strip():
                rows.append(json.loads(line))
    rows.sort(key=lambda row: row["source_path"])
    if len(rows) != EXPECTED:
        raise RuntimeError(f"Périmètre invalide : {len(rows)} fichiers au lieu de {EXPECTED}")
    return rows


def inspect(rows: list[dict]) -> tuple[list[dict], dict[str, str], dict[str, str]]:
    class_to_file: dict[str, str] = {}
    file_classes: dict[str, list[str]] = {}
    contents: dict[str, str] = {}

    for row in rows:
        path = row["source_path"]
        text = (ROOT / path).read_text(encoding="utf-8", errors="replace")
        contents[path] = text
        classes = CLASS_RE.findall(text)
        file_classes[path] = classes
        for class_name in classes:
            class_to_file.setdefault(class_name, path)

    # L'inventaire de migration porte le chemin canonique de chaque page,
    # y compris lorsque app_router utilise `MaPage.routeName` plutôt qu'une
    # chaîne littérale. Il constitue donc la source principale de résolution.
    route_to_file = {
        row["course_route"]: row["source_path"]
        for row in rows
        if row.get("course_route")
    }
    router_text = ROUTER.read_text(encoding="utf-8", errors="replace")
    route_to_class = dict(ROUTE_ENTRY_RE.findall(router_text))
    for route, body in ROUTE_BLOCK_RE.findall(router_text):
        candidates = [
            class_name
            for class_name in RETURN_CLASS_RE.findall(body)
            if class_name in class_to_file
        ]
        if candidates:
            route_to_class[route] = candidates[-1]
    route_to_file.update(
        {
            route: class_to_file[class_name]
            for route, class_name in route_to_class.items()
            if class_name in class_to_file
        }
    )

    for row in rows:
        path = row["source_path"]
        text = contents[path]
        own_classes = set(file_classes[path])
        declared_routes = sorted(route for route, target in route_to_file.items() if target == path)
        outgoing_routes = sorted(set(ROUTE_RE.findall(text)) - set(declared_routes))
        outgoing_classes = sorted(
            class_name
            for class_name in set(CTOR_RE.findall(text))
            if class_name in class_to_file
            and class_name not in own_classes
            and class_to_file[class_name] != path
        )
        parts = Path(path).parts
        content_index = parts.index("content")
        relative = list(parts[content_index + 2 :])
        directories = relative[:-1]
        payload = row.get("extracted_payload") or {}
        title = clean(payload.get("title")) or label_from_path(Path(path).name)
        row.update(
            {
                "title": title,
                "classes": file_classes[path],
                "declared_routes": declared_routes,
                "outgoing_routes": outgoing_routes,
                "outgoing_classes": outgoing_classes,
                "directories": directories,
                "route_to_file": route_to_file,
                "class_to_file": class_to_file,
            }
        )
    return rows, route_to_file, class_to_file


def tree_for(rows: list[dict], track: str) -> dict:
    root: dict = {"_files": []}
    for row in rows:
        if row["track"].lower() != track:
            continue
        cursor = root
        for directory in row["directories"]:
            cursor = cursor.setdefault(directory, {"_files": []})
        cursor["_files"].append(row)
    return root


def write_tree(buffer: list[str], node: dict, depth: int, counters: dict[str, int]) -> None:
    children = sorted(key for key in node if key != "_files")
    for child in children:
        buffer.append(f"{'  ' * depth}- **{label_from_path(child)}**  `/{child}`")
        write_tree(buffer, node[child], depth + 1, counters)
    for row in sorted(node.get("_files", []), key=lambda item: item["source_path"]):
        counters["file"] += 1
        kind = "QUIZ" if row["content_type"] == "quiz" else "PAGE"
        title = clean(row["title"])
        buffer.append(
            f"{'  ' * depth}- **[{counters['file']:04d}] {title}** — `{kind}` — `{row['source_path']}`"
        )
        routes = row["declared_routes"] or ([row.get("course_route")] if row.get("course_route") else [])
        if routes:
            buffer.append(f"{'  ' * (depth + 1)}- Chemin(s) entrant(s) : " + ", ".join(f"`{route}`" for route in routes if route))
        if row["classes"]:
            buffer.append(f"{'  ' * (depth + 1)}- Classe(s) : " + ", ".join(f"`{value}`" for value in row["classes"]))
        links = []
        for route in row["outgoing_routes"]:
            target = row["route_to_file"].get(route)
            links.append(f"`{route}` → `{target or 'cible non résolue dans le registre statique'}`")
        for class_name in row["outgoing_classes"]:
            links.append(f"`{class_name}` → `{row['class_to_file'][class_name]}`")
        if links:
            buffer.append(f"{'  ' * (depth + 1)}- Redirection(s) sortante(s) : " + " ; ".join(links))


def generate_markdown(rows: list[dict], route_to_file: dict[str, str]) -> None:
    now = datetime.now().astimezone().isoformat(timespec="seconds")
    by_track = Counter(row["track"].upper() for row in rows)
    by_type = Counter(row["content_type"] for row in rows)
    all_routes = sorted({route for row in rows for route in row["outgoing_routes"]})
    resolved = [route for route in all_routes if route in route_to_file]
    unresolved = [route for route in all_routes if route not in route_to_file]
    direct_links = sum(len(row["outgoing_classes"]) for row in rows)

    out = [
        "# Cartographie exhaustive — Scolarité GPX et PA",
        "",
        f"> Générée automatiquement le `{now}` depuis les **1 409 fichiers sources Flutter**, `main.dart`, `app_router.dart` et l’inventaire de migration.",
        "> Une ligne numérotée correspond exactement à un fichier du registre de référence. Les chemins entrants et redirections sortantes sont placés sous leur page.",
        "",
        "## Contrôle de complétude",
        "",
        f"- Total contrôlé : **{len(rows)}/{EXPECTED} fichiers** — **{'CONFORME' if len(rows) == EXPECTED else 'NON CONFORME'}**",
        f"- GPX : **{by_track['GPX']} fichiers**",
        f"- PA : **{by_track['PA']} fichiers**",
        f"- Pages, cours et introductions : **{by_type['course']}**",
        f"- Fichiers de quiz : **{by_type['quiz']}**",
        f"- Composants, index et moteurs auxiliaires : **{len(rows) - by_type['course'] - by_type['quiz']}**",
        f"- Chemins sortants littéraux uniques détectés : **{len(all_routes)}**",
        f"- Chemins reliés statiquement à une page du registre : **{len(resolved)}**",
        f"- Navigation directe par classe Flutter : **{direct_links} liens**",
        f"- Chemins dynamiques, historiques ou non résolus statiquement : **{len(unresolved)}** (listés intégralement en fin de document)",
        "",
        "## Légende",
        "",
        "- `PAGE` : page de cours, introduction, menu, composant ou sous-page.",
        "- `QUIZ` : fichier contenant un quiz ou ses questions.",
        "- **Chemin entrant** : URL/route qui ouvre la page.",
        "- **Redirection sortante** : destination appelée depuis cette page.",
        "- Une cible « non résolue statiquement » peut être traitée par une route dynamique, un alias historique ou une navigation calculée à l’exécution ; elle reste volontairement visible pour l’audit.",
        "",
        "## Arborescence GPX",
        "",
    ]
    counter = {"file": 0}
    write_tree(out, tree_for(rows, "gpx"), 0, counter)
    gpx_end = counter["file"]
    out += ["", "## Arborescence PA", ""]
    write_tree(out, tree_for(rows, "pa"), 0, counter)
    out += [
        "",
        "## Index exhaustif des redirections",
        "",
        "| # | Filière | Page source | Type | Destination | Résolution |",
        "|---:|---|---|---|---|---|",
    ]
    edge_index = 0
    for row in rows:
        for route in row["outgoing_routes"]:
            edge_index += 1
            target = route_to_file.get(route)
            out.append(
                f"| {edge_index} | {row['track'].upper()} | `{row['source_path']}` | Route nommée | `{route}` | `{target or 'NON RÉSOLUE STATIQUEMENT'}` |"
            )
        for class_name in row["outgoing_classes"]:
            edge_index += 1
            out.append(
                f"| {edge_index} | {row['track'].upper()} | `{row['source_path']}` | Classe directe | `{class_name}` | `{row['class_to_file'][class_name]}` |"
            )
    out += [
        "",
        "## Chemins non résolus statiquement à contrôler",
        "",
    ]
    out.extend(f"- `{route}`" for route in unresolved)
    out += [
        "",
        "## Preuve de couverture",
        "",
        f"- Dernier numéro GPX : **{gpx_end:04d}**",
        f"- Dernier numéro global : **{counter['file']:04d}**",
        f"- Nombre total de redirections indexées : **{edge_index}**",
        f"- Contrôle final : **{'1 409/1 409 — CONFORME' if counter['file'] == EXPECTED else 'ÉCART DÉTECTÉ'}**",
        "",
    ]
    MARKDOWN.write_text("\n".join(out), encoding="utf-8")


def font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont:
    candidates = [
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf" if bold else "/System/Library/Fonts/Supplemental/Arial.ttf",
        "/System/Library/Fonts/Helvetica.ttc",
    ]
    for candidate in candidates:
        if Path(candidate).exists():
            return ImageFont.truetype(candidate, size=size)
    return ImageFont.load_default(size=size)


def shorten(text: str, limit: int) -> str:
    return text if len(text) <= limit else text[: limit - 1] + "…"


def rounded_box(draw: ImageDraw.ImageDraw, box: tuple[int, int, int, int], fill: str, outline: str, radius: int = 16, width: int = 2) -> None:
    draw.rounded_rectangle(box, radius=radius, fill=fill, outline=outline, width=width)


def generate_png(rows: list[dict]) -> None:
    row_index = {
        row["source_path"]: index
        for index, row in enumerate(rows, start=1)
    }
    width, height = 12000, 11200
    image = Image.new("RGB", (width, height), "#07111f")
    draw = ImageDraw.Draw(image)
    title_font, subtitle_font = font(78, True), font(34)
    track_font, module_font = font(40, True), font(21, True)
    level_font, file_font, small_font = font(26, True), font(17, True), font(14)

    draw.text((width // 2, 80), "PYRAMIDE COMPLÈTE — SCOLARITÉ COP’IQ", font=title_font, fill="#f8fafc", anchor="ma")
    draw.text((width // 2, 190), "Chaque tuile numérotée correspond à la même entrée dans le fichier Markdown", font=subtitle_font, fill="#93c5fd", anchor="ma")

    root_box = (width // 2 - 650, 300, width // 2 + 650, 470)
    rounded_box(draw, root_box, "#172554", "#60a5fa", 28, 5)
    draw.text((width // 2, 385), "NIVEAU 1 — APPLICATION COP’IQ", font=track_font, fill="#ffffff", anchor="mm")

    track_y = 700
    track_boxes = {
        "gpx": (1800, track_y, width // 2 - 300, track_y + 170),
        "pa": (width // 2 + 300, track_y, width - 1800, track_y + 170),
    }
    for track, box in track_boxes.items():
        center = ((box[0] + box[2]) // 2, (box[1] + box[3]) // 2)
        draw.line((width // 2, root_box[3], center[0], box[1]), fill="#64748b", width=10)
        rounded_box(draw, box, "#0f2c4d" if track == "gpx" else "#35204d", "#38bdf8" if track == "gpx" else "#c084fc", 24, 5)
        count = sum(1 for row in rows if row["track"].lower() == track)
        draw.text(center, f"NIVEAU 2 — SCOLARITÉ {track.upper()} — {count} FICHIERS", font=track_font, fill="#ffffff", anchor="mm")

    sections: dict[str, dict[str, list[dict]]] = defaultdict(lambda: defaultdict(list))
    for row in rows:
        track = row["track"].lower()
        module = row["directories"][0] if row["directories"] else "racine"
        sections[track][module].append(row)

    # Niveau 3 : domaines principaux. Leur largeur croissante matérialise la
    # troisième assise de la pyramide et chaque branche rejoint sa filière.
    module_top, module_h = 1120, 115
    module_centres: dict[tuple[str, str], tuple[int, int]] = {}
    for track_index, track in enumerate(("gpx", "pa")):
        modules = sorted(sections[track])
        half_left = 500 if track_index == 0 else width // 2 + 140
        half_right = width // 2 - 140 if track_index == 0 else width - 500
        columns = min(6, max(1, len(modules)))
        rows_count = math.ceil(len(modules) / columns)
        gap = 24
        box_w = (half_right - half_left - gap * (columns - 1)) // columns
        track_center = ((track_boxes[track][0] + track_boxes[track][2]) // 2, track_boxes[track][3])
        for index, module in enumerate(modules):
            column, line = index % columns, index // columns
            x = half_left + column * (box_w + gap)
            y = module_top + line * (module_h + 20)
            box = (x, y, x + box_w, y + module_h)
            center = ((box[0] + box[2]) // 2, (box[1] + box[3]) // 2)
            module_centres[(track, module)] = center
            draw.line((track_center[0], track_center[1], center[0], box[1]), fill="#274867" if track == "gpx" else "#60427d", width=4)
            rounded_box(draw, box, "#12324f" if track == "gpx" else "#3b2854", "#38bdf8" if track == "gpx" else "#c084fc", 14, 3)
            count = len(sections[track][module])
            draw.text((center[0], center[1] - 15), shorten(label_from_path(module), 34), font=module_font, fill="#ffffff", anchor="mm")
            draw.text((center[0], center[1] + 24), f"{count} fichiers", font=small_font, fill="#bae6fd" if track == "gpx" else "#e9d5ff", anchor="mm")

    draw.text((width // 2, 1040), "NIVEAU 3 — DOMAINES PRINCIPAUX", font=level_font, fill="#cbd5e1", anchor="mm")

    # Niveau 4 : toutes les pages. Dix colonnes par filière conservent des
    # libellés lisibles au zoom tout en formant la large base de la pyramide.
    pane_top, pane_bottom = 1950, height - 220
    draw.text((width // 2, 1840), "NIVEAU 4 — SOUS-DOMAINES, PAGES, SOUS-PAGES ET QUIZ", font=level_font, fill="#cbd5e1", anchor="mm")
    columns_per_track = 10
    outer_margin, centre_gap, gap = 260, 180, 12
    pane_width = width // 2 - outer_margin - centre_gap
    card_w = (pane_width - gap * (columns_per_track - 1)) // columns_per_track
    card_h = 108

    for track_index, track in enumerate(("gpx", "pa")):
        x_origin = outer_margin if track_index == 0 else width // 2 + centre_gap
        modules = sorted(sections[track].items(), key=lambda item: item[0])
        flat: list[tuple[str, dict]] = []
        for module, module_rows in modules:
            for row in sorted(module_rows, key=lambda item: item["source_path"]):
                flat.append((module, row))
        rows_per_column = math.ceil(len(flat) / columns_per_track)
        drawn = 0
        for column in range(columns_per_track):
            x = x_origin + column * (card_w + gap)
            y = pane_top
            previous_module = None
            start = column * rows_per_column
            end = min(len(flat), (column + 1) * rows_per_column)
            for module, row in flat[start:end]:
                if module != previous_module:
                    module_label = shorten(label_from_path(module), 36)
                    rounded_box(draw, (x, y, x + card_w, y + 52), "#12324f" if track == "gpx" else "#3b2854", "#1e4970" if track == "gpx" else "#60427d", 9, 1)
                    draw.text((x + 10, y + 26), module_label, font=small_font, fill="#7dd3fc" if track == "gpx" else "#d8b4fe", anchor="lm")
                    y += 58
                    previous_module = module
                if y + card_h > pane_bottom:
                    raise RuntimeError(f"Poster trop court : {track} colonne {column + 1}")
                quiz = row["content_type"] == "quiz"
                fill = "#173f35" if quiz else "#101f34"
                outline = "#34d399" if quiz else "#274867"
                rounded_box(draw, (x, y, x + card_w, y + card_h - 4), fill, outline, 8, 1)
                index = row_index[row["source_path"]]
                draw.text((x + 9, y + 12), f"{index:04d} {'QUIZ' if quiz else 'PAGE'}", font=small_font, fill="#6ee7b7" if quiz else "#93c5fd")
                draw.text((x + 9, y + 39), shorten(row["title"], 49), font=file_font, fill="#f8fafc")
                route = (row["declared_routes"] or [row.get("course_route") or "—"])[0]
                draw.text((x + 9, y + 70), shorten(route, 62), font=small_font, fill="#94a3b8")
                draw.text((x + 9, y + 92), shorten("/".join(row["directories"][-2:]), 62), font=small_font, fill="#64748b")
                y += card_h
                drawn += 1
        expected = sum(1 for row in rows if row["track"].lower() == track)
        if drawn != expected:
            raise RuntimeError(f"Couverture PNG incomplète pour {track}: {drawn}/{expected}")

    draw.text((width // 2, height - 95), "BASE DE LA PYRAMIDE : 1 409/1 409 FICHIERS • Le Markdown associé contient les chemins et redirections sans troncature.", font=subtitle_font, fill="#cbd5e1", anchor="mm")
    image.save(PNG, format="PNG", compress_level=4)


def main() -> None:
    rows = load_sources()
    rows, route_to_file, _ = inspect(rows)
    generate_markdown(rows, route_to_file)
    generate_png(rows)
    print(f"Markdown : {MARKDOWN}")
    print(f"PNG : {PNG}")
    print(f"Fichiers cartographiés : {len(rows)}")


if __name__ == "__main__":
    main()
