"""Graphe de navigation des pages de cours Flutter (lib/) → JSON."""
import os, re, json, sys
LIB = '/home/claude/app/lib'
def norm(p):
    return re.sub(r'#U([0-9a-fA-F]{4})', lambda m: chr(int(m.group(1), 16)), p)

files = {}
for root, _, fs in os.walk(LIB):
    for f in fs:
        if f.endswith('.dart'):
            full = os.path.join(root, f)
            rel = 'lib/' + norm(os.path.relpath(full, LIB))
            try:
                files[rel] = open(full, encoding='utf-8', errors='ignore').read()
            except Exception:
                pass

cls_file = {}
for rel, src in files.items():
    for m in re.finditer(r'\bclass\s+([A-Za-z_]\w*)\s+extends\s+(\w+)', src):
        name = m.group(1)
        if name.startswith('_'):
            continue
        cls_file.setdefault(name, rel)

routes = {}
for rel, src in files.items():
    for m in re.finditer(r"'(/[^'\s]+)'\s*:\s*\([^)]*\)\s*=>\s*(?:const\s+)?([A-Z]\w*)", src):
        routes.setdefault(m.group(1), m.group(2))
    for m in re.finditer(r"case\s+'(/[^'\s]+)'\s*:[^;]{0,200}?(?:const\s+)?([A-Z]\w*)\(", src):
        routes.setdefault(m.group(1), m.group(2))
# routeName statiques
static_route = {}
for rel, src in files.items():
    for m in re.finditer(r"static\s+const\s+(?:String\s+)?(\w+)\s*=\s*'(/[^']+)'", src):
        before = src[:m.start()]
        cm = list(re.finditer(r'\bclass\s+([A-Za-z_]\w*)', before))
        if cm:
            c = cm[-1].group(1)
            static_route[(c, m.group(1))] = m.group(2)
            routes.setdefault(m.group(2), c)

fc = json.load(open('/home/claude/tools/courses/frag_counts.json'))

def file_of_route(r):
    c = routes.get(r)
    return cls_file.get(c) if c else None

Q = r"""(?:'((?:[^'\\\n]|\\.)+)'|"((?:[^"\\\n]|\\.)+)")"""
SV = r"(?:ScolariteText\.value\(\s*(?:" + Q + r"\s*,\s*){0,2})?"
TITLE_RE = re.compile(r"\b(?:title|label|titre)\s*:\s*(?:const\s+)?(?:Text\(\s*)?" + SV + Q, re.S)
SUB_RE = re.compile(r"\b(?:subtitle|sousTitre|description)\s*:\s*(?:const\s+)?(?:Text\(\s*)?" + SV + Q, re.S)
def lastq(m):
    g = [x for x in m.groups() if x]
    return g[-1] if g else None
IMG_RE = re.compile(r"'assets/images/([^']+)'")

def subtitle_of(win):
    i = max(win.rfind('subtitle:'), win.rfind('description:'))
    if i < 0:
        return None
    seg = win[i:]
    m = re.search(r"\b(imagePath|textMain|onTap|image|icon|tag|color)\s*:", seg[10:])
    if m:
        seg = seg[:10 + m.start()]
    parts = []
    for q in re.finditer(Q, seg):
        t = q.group(1) or q.group(2)
        if t.startswith('lib/') or re.fullmatch(r'f\d{5}', t):
            continue
        parts.append(t)
    return ''.join(parts).strip() or None


def outgoing(rel):
    src = files.get(rel, '')
    own_cls = {m.group(1) for m in re.finditer(r'\bclass\s+([A-Za-z_]\w*)', src)}
    out = []
    seen = set()
    last = [0]
    def add(target, pos, how):
        if not target or target == rel or target in seen:
            return
        seen.add(target)
        win = src[max(0, pos - 3000, last[0]):pos]
        last[0] = pos
        t = list(TITLE_RE.finditer(win)); s = list(SUB_RE.finditer(win)); im = list(IMG_RE.finditer(win))
        out.append({'file': target, 'pos': pos, 'how': how,
                    'title': lastq(t[-1]) if t else None,
                    'subtitle': subtitle_of(win),
                    'image': im[-1].group(1) if im else None})
    cand = []
    for m in re.finditer(r"['\"](/[^'\"\s]+)['\"]", src):
        r = m.group(1)
        if r in routes:
            cand.append((m.start(), file_of_route(r), 'route:' + r))
    for m in re.finditer(r'\b([A-Z]\w*)\.(\w+)\b', src):
        key = (m.group(1), m.group(2))
        if key in static_route and m.group(1) not in own_cls:
            cand.append((m.start(), cls_file.get(m.group(1)), 'static:' + m.group(1)))
    for m in re.finditer(r'(?:=>|builder:\s*\([^)]*\)\s*=>|push\w*\(|page:|child:|destination:|target:|screen:)\s*(?:const\s+)?([A-Z]\w*)\(', src):
        c = m.group(1)
        if c in own_cls:
            continue
        f = cls_file.get(c)
        if f and f.startswith('lib/content'):
            cand.append((m.start(), f, 'class:' + c))
    for pos, f, how in sorted(cand, key=lambda x: x[0]):
        add(f, pos, how)
    out.sort(key=lambda x: x['pos'])
    return out

if __name__ == '__main__':
    print(len(files), 'fichiers', len(cls_file), 'classes', len(routes), 'routes')
    for p in sys.argv[1:]:
        print('==', p, fc.get(p))
        for o in outgoing(p):
            print('  ->', o['file'], fc.get(o['file'], {}).get('n'), o['how'], '|', o['title'], '|', o['image'])
