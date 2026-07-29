import re, json, sys

ROOT = r"C:\Users\kaiso\Desktop\copiqpolice"

def read(path):
    with open(f"{ROOT}\\{path}", encoding="utf-8") as f:
        return f.read()

def extract_section(content, start_marker, end_marker):
    start = content.index(start_marker)
    end = content.index(end_marker, start)
    return content[start:end]

def parse_categories(section):
    # Find each CategoryConfig block and its subcategories
    cats = []
    # split on 'CategoryConfig(' occurrences at top level (label: lines)
    cat_pattern = re.compile(r"(?<!Sub)CategoryConfig\(\s*label:\s*'((?:[^'\\]|\\.)*)'", re.S)
    positions = [(m.start(), m.group(1)) for m in cat_pattern.finditer(section)]
    for i, (pos, label) in enumerate(positions):
        block_end = positions[i+1][0] if i+1 < len(positions) else len(section)
        block = section[pos:block_end]
        # top-level category route
        route_m = re.search(r"route:\s*'((?:[^'\\]|\\.)*)'", block)
        cat_route = route_m.group(1) if route_m else None
        subs = []
        for sm in re.finditer(r"SubCategoryConfig\(\s*label:\s*'((?:[^'\\]|\\.)*)'.*?route:\s*'((?:[^'\\]|\\.)*)'", block, re.S):
            sub_label = sm.group(1)
            sub_route = sm.group(2)
            subs.append((sub_label, sub_route))
        cats.append({"label": label, "route": cat_route, "subs": subs})
    return cats

def build_router_index(router_content):
    # literal string keys: 'route': (builder) => ClassName(...)
    literal_map = {}
    for m in re.finditer(r"'((?:[^'\\]|\\.)*)':\s*\(_\)\s*(?:=>|\{)\s*(?:const\s+)?([A-Za-z_][A-Za-z0-9_]*)", router_content):
        literal_map[m.group(1)] = m.group(2)
    # ClassName.routeName: (builder) => const ClassName(
    class_map = {}
    for m in re.finditer(r"([A-Za-z_][A-Za-z0-9_]*)\.routeName:\s*\(_\)\s*(?:=>|\{)\s*(?:const\s+)?([A-Za-z_][A-Za-z0-9_]*)", router_content):
        class_map[m.group(1)] = m.group(2)
    return literal_map, class_map

def find_routename_values(lib_dir_files):
    # map ClassName -> routeName string value, by scanning all dart files
    pass

def resolve_route(route, literal_map, class_map, routename_to_class):
    if route in literal_map:
        return literal_map[route]
    if route in routename_to_class:
        return routename_to_class[route]
    return "NOT_FOUND"

def main():
    gpx_home = read("lib\\features\\home\\home_page_gpx_school.dart")
    pa_home = read("lib\\features\\home\\home_page_pa_school.dart")
    router = read("lib\\routes\\app_router.dart")

    gpx_section = extract_section(gpx_home, "GpxSchoolProgram.dpsDpg: [", "MÉMENTO CIRCULATION ROUTIÈRE")
    pa_section = extract_section(pa_home, "PaSchoolProgram.dpsDpg: [", "PaSchoolProgram.mememtoCirculationRoutiere")

    literal_map, class_map = build_router_index(router)

    # Build routeName -> class map by scanning all lib dart files for "static const String routeName = '...'"
    import subprocess
    routename_to_class = {}
    import os
    for dirpath, _, filenames in os.walk(f"{ROOT}\\lib"):
        for fn in filenames:
            if not fn.endswith(".dart"):
                continue
            fp = os.path.join(dirpath, fn)
            try:
                with open(fp, encoding="utf-8") as f:
                    txt = f.read()
            except Exception:
                continue
            for cm in re.finditer(r"class\s+([A-Za-z_][A-Za-z0-9_]*)\s", txt):
                cls = cm.group(1)
            # find pairs: class X ... routeName = 'Y' within reasonable proximity per class block
            for m in re.finditer(r"class\s+([A-Za-z_][A-Za-z0-9_]*)\b[^{]*\{", txt):
                cls = m.group(1)
                start = m.end()
                # look for routeName within next 2000 chars
                snippet = txt[start:start+3000]
                rm = re.search(r"routeName\s*=\s*\n?\s*'((?:[^'\\]|\\.)*)'", snippet)
                if rm:
                    routename_to_class[rm.group(1)] = cls

    gpx_cats = parse_categories(gpx_section)
    pa_cats = parse_categories(pa_section)

    def resolve_all(cats):
        out = []
        for cat in cats:
            entry = {"label": cat["label"], "route": cat["route"],
                     "resolved": resolve_route(cat["route"], literal_map, class_map, routename_to_class) if cat["route"] else None,
                     "subs": []}
            for (label, route) in cat["subs"]:
                entry["subs"].append({
                    "label": label, "route": route,
                    "resolved": resolve_route(route, literal_map, class_map, routename_to_class)
                })
            out.append(entry)
        return out

    gpx_resolved = resolve_all(gpx_cats)
    pa_resolved = resolve_all(pa_cats)

    with open(f"{ROOT}\\scripts\\_dpsdpg_gpx_resolved.json", "w", encoding="utf-8") as f:
        json.dump(gpx_resolved, f, ensure_ascii=False, indent=2)
    with open(f"{ROOT}\\scripts\\_dpsdpg_pa_resolved.json", "w", encoding="utf-8") as f:
        json.dump(pa_resolved, f, ensure_ascii=False, indent=2)

    print("GPX categories:", len(gpx_resolved), "subs total:", sum(len(c["subs"]) for c in gpx_resolved))
    print("PA categories:", len(pa_resolved), "subs total:", sum(len(c["subs"]) for c in pa_resolved))

if __name__ == "__main__":
    main()
