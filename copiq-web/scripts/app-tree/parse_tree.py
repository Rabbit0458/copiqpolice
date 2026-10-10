import re, json, sys
src = open('/home/claude/app/inventaire/01_homes_cartes.md', encoding='utf-8').read().split('\n')
res = open('/home/claude/app/inventaire/03_scolarite.md', encoding='utf-8').read().split('\n')

# résolution feuille -> type/module depuis 03 §7.B
leafinfo = {}
cur_track = None
for line in res:
    if line.startswith('### PA — table'): cur_track = 'pa'
    elif line.startswith('### GPX — table'): cur_track = 'gpx'
    m = re.match(r'^\| (COURS|QUIZ|[A-Z\-]+) \| (.+?) \| `([^`]+)` \| (.*?) \| (.*?) \| (.*?) \|$', line)
    if m and cur_track:
        typ, label, route, source, key, dart = m.groups()
        dartp = re.sub(r'#U([0-9a-fA-F]{4})', lambda mm: chr(int(mm.group(1),16)), dart.strip().strip('`'))
        leafinfo[(cur_track, route)] = {'type': typ, 'source': source.strip(), 'module': key.strip().strip('`') or None, 'dart': dartp or None}

top_re = re.compile(r'^- \*\*(.+?)\*\* — badge: _(.*?)_ — img `([^`]+)` — route `([^`]+)` ⇒ (.*)$')
sub_re = re.compile(r'^    - (.+?) → `([^`]+)`(?: \(img `([^`]+)`\))? ⇒ (.*)$')
section = None; program = None
tree = {}
for line in src:
    if line.startswith('### 7.1'): section = 'pa_exam'; program = 'concours'
    elif line.startswith('### 7.2'): section = 'gpx_exam'; program = 'concours'
    elif line.startswith('### 7.3'): section = 'pa_school'; program = None
    elif line.startswith('### 7.4'): section = 'gpx_school'; program = None
    elif line.startswith('## Annexe'): section = None
    if not section: continue
    m = re.match(r'^#### (?:Pa|Gpx)SchoolProgram\.(\w+)', line)
    if m: program = m.group(1); continue
    m = top_re.match(line)
    if m:
        label, badge, img, route, target = m.groups()
        card = {'label': label, 'badge': badge, 'image': img.replace('assets/images/', ''), 'route': route, 'target': re.sub(r'[*_`]', '', target).strip(), 'leaves': []}
        tree.setdefault(section, {}).setdefault(program, []).append(card); continue
    m = sub_re.match(line)
    if m and program and tree.get(section, {}).get(program):
        label, route, img, target = m.groups()
        track = section.split('_')[0]
        info = leafinfo.get((track, route), {})
        tree[section][program][-1]['leaves'].append({'label': label.strip(), 'route': route, 'image': img.replace('assets/images/', '') if img else None,
            'target': re.sub(r'[*_`]', '', target).strip(), 'type': info.get('type'), 'module': info.get('module'), 'source': info.get('source'), 'dart': info.get('dart')})
db=json.load(open('/home/claude/tools/tree/db_cours.json')); spm=json.load(open('/home/claude/tools/tree/db_sourcepath.json'))
import unicodedata
spn={unicodedata.normalize('NFC',k):v for k,v in spm.items()}
for s_,ps in tree.items():
    for p_,cs in ps.items():
        for c in cs:
            for l in c['leaves']:
                if l.get('type')=='QUIZ': continue
                d=None
                if l['route'] in db: d=l['route']
                elif l.get('dart') and unicodedata.normalize('NFC',l['dart']) in spn: d=spn[unicodedata.normalize('NFC',l['dart'])][0]
                l['db']=d
json.dump(tree, open('/home/claude/tools/tree/app_tree.json', 'w'), ensure_ascii=False, indent=1)
for s, progs in tree.items():
    for p, cards in progs.items():
        n = sum(len(c['leaves']) for c in cards)
        typed = sum(1 for c in cards for l in c['leaves'] if l['type'])
        dbn = sum(1 for c in cards for l in c['leaves'] if l.get('db'))
        q = sum(1 for c in cards for l in c['leaves'] if l.get('type')=='QUIZ')
        print(s, p, len(cards), 'cartes', n, 'feuilles', q, 'quiz', dbn, 'cours en base')
