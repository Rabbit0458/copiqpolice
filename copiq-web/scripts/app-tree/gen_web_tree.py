"""Génère src/data/app-tree.json (arborescence de l'app Flutter pour le site) et
copie les images utilisées dans public/app/img/.

Sources : inventaire/01_homes_cartes.md (§7) + 03_scolarite.md (§7.B) parsés par
parse_tree.py → app_tree.json, et correspondances base (db_cours.json,
db_sourcepath.json).
"""
import json, os, re, shutil, unicodedata

ROOT = '/home/claude/tools/tree'
WEB = '/home/claude/work/copiq-web'
IMG_SRC = '/home/claude/app/imgweb'
IMG_DST = f'{WEB}/public/app/img'

tree = json.load(open(f'{ROOT}/app_tree.json'))
spm = json.load(open(f'{ROOT}/db_sourcepath.json'))
route_to_src = {}
for src, routes in spm.items():
    for r in routes:
        route_to_src.setdefault(r, src)

used_images = set()


def img(name):
    if not name:
        return None
    name = name.replace('assets/images/', '')
    if os.path.exists(f'{IMG_SRC}/{name}.webp'):
        used_images.add(name)
        return f'{name}.webp'
    return None


def clean(s):
    """Libellés Dart : retire les échappements (\\') et pose l'apostrophe typographique."""
    if not s:
        return s
    s = s.replace("\\'", "’").replace('\\"', '"').replace("'", "’")
    s = re.sub(r"\s+", " ", s).strip()
    s = re.sub(r"\.\.$", "…", s)
    return s


def slug(s):
    s = unicodedata.normalize('NFKD', s).encode('ascii', 'ignore').decode()
    return re.sub(r'[^a-z0-9]+', '-', s.lower()).strip('-')


# Culture générale : route → catégorie quiz_questions + suffixe du nom de quiz (comme l'app).
# « Histoire » n'existe pas en base : l'app interroge une catégorie vide ; le site
# utilise « France » (histoire de France) pour proposer de vraies questions.
CG = {
    'histoire_france': ('France', 'histoire'),
    'institutions_europeennes': ('Institutions', 'institutions européennes'),
    'actualite': ('Actualite', 'actualité'),
    'geographie': ('Geographie', 'géographie'),
    'francais': ('France', 'France'),
    'langue': ('France', 'France'),
    'sport': ('Sport', 'sport'),
    'sciences': ('Sciences', 'sciences'),
    'sante': ('Sante', 'santé'),
    'police_securite': ('Police', 'police'),
    'mythologie': ('Mythologie', 'mythologie'),
    'musique': ('Musique', 'musique'),
    'cinema': ('Cinema', 'cinéma'),
    'droit': ('Droit', 'droit'),
    'securite_routiere': ('Securite', 'sécurité routière'),
}
QUIZKEY_FILE = {'institutions_europeennes': 'institutions_europeens', 'francais': 'france', 'langue': 'france', 'police_securite': 'police'}

PA_CG_THEMES = [
    ('Histoire de France', 'histoire_france'), ('Institutions européennes', 'institutions_europeennes'),
    ('Actualité', 'actualite'), ('Géographie', 'geographie'), ('Langue française', 'francais'),
    ('Sport & culture générale', 'sport'), ('Sciences', 'sciences'), ('Santé', 'sante'),
    ('Police & sécurité', 'police_securite'), ('Mythologie & culture générale', 'mythologie'),
    ('Musique & culture générale', 'musique'), ('Cinéma & culture générale', 'cinema'),
    ('Droit & culture générale', 'droit'), ('Sécurité routière', 'securite_routiere'),
]

# Sujets portés plus tard sur le web (lots suivants du chantier).
APP_ONLY_REASON = {
    'photolangage': "L’épreuve de photolangage (sujets, rédaction chronométrée et correction détaillée) arrive sur le site dans un prochain lot.",
    'tests_psy': "Les tests psychotechniques arrivent sur le site dans un prochain lot, avec les mêmes exercices que l’application.",
    'tests_psychotechniques': "Les tests psychotechniques chronométrés arrivent sur le site dans un prochain lot, avec les mêmes exercices que l’application.",
    'langue_etrangere': "Les QCM de langue étrangère arrivent sur le site dans un prochain lot.",
    'epreuves_gpx': "Cette fiche sur la structure du concours arrive sur le site dans un prochain lot.",
    'cas_pratique': "Le moteur de cas pratiques corrigés arrive sur le site dans un prochain lot.",
}


def cg_leaf(track, label, key, image):
    cat, suffix = CG[key]
    prefix = 'PA - ' if track == 'pa' else ''
    return {
        'id': slug(f'cg-{key}'), 'label': label, 'image': image, 'kind': 'cg', 'category': cat,
        'moduleName': f'{prefix}Culture générale', 'quizName': f'{prefix}Quiz culture générale {suffix}',
        'quizKey': f"{'pa_' if track == 'pa' else ''}quiz_culture_generale_{QUIZKEY_FILE.get(key, key)}",
    }


def app_only(route):
    for k, reason in APP_ONLY_REASON.items():
        if k in route:
            return reason
    return "Ce contenu arrive sur le site dans un prochain lot. Il est déjà disponible dans l’application COP’IQ."


def leaf_for(track, card, l):
    route = l['route']
    image = img(l.get('image')) or img(card['image'])
    m = re.search(r'culture_generale_(\w+)$', route)
    if m and m.group(1) in CG:
        out = cg_leaf(track, clean(l['label']), m.group(1), image)
        out['route'] = route
        return out
    base = {'id': slug(route.split('/', 2)[-1])[:90], 'label': clean(l['label']), 'image': image, 'route': route}
    if l.get('type') == 'QUIZ' and l.get('module'):
        return {**base, 'kind': 'quiz', 'module': l['module'], 'moduleName': clean(card['label']), 'quizName': clean(l['label'])}
    db = l.get('db')
    if db:
        return {**base, 'kind': 'course', 'db': db, 'src': route_to_src.get(db)}
    return {**base, 'kind': 'app', 'reason': app_only(route)}


PROGRAM_META = {
    'institutionValeurs': ('institution_valeurs', 'Institution & Valeurs', 'school.jpeg'),
    'dpsDpg': ('dps_dpg', 'DPS / DPG', 'exam.jpeg'),
    'mememtoCirculationRoutiere': ('memento_circulation_routiere', 'Mémento • Circulation routière', 'contravention.jpeg'),
    'policierEnIntervention': ('policier_en_intervention', 'Policier en intervention — Socle initial', 'cat_hierarchie.jpg'),
    'policierEnInterventionsa': ('policier_en_intervention_avance', 'Policier en intervention — Socle avancé', 'cat_hierarchie.jpg'),
    'recueilPvApj20': ('recueil_pv_apj20', 'Recueil de procès-verbaux (APJ 20)', 'pp_instruction_mandats_detention.jpeg'),
    'dimensionHumaine': ('dimension_humaine', 'Dimension humaine', 'dignite_discriminations.jpeg'),
}
PROGRAM_ORDER = ['institutionValeurs', 'dpsDpg', 'mememtoCirculationRoutiere', 'policierEnIntervention', 'policierEnInterventionsa', 'recueilPvApj20', 'dimensionHumaine']

out = {}
for section, programs in tree.items():
    track = section.split('_')[0]
    progs = []
    keys = ['concours'] if 'exam' in section else [k for k in PROGRAM_ORDER if k in programs]
    for pkey in keys:
        cards = []
        for c in programs[pkey]:
            card = {'id': slug(c['route'].split('/', 2)[-1])[:80], 'label': clean(c['label']), 'badge': clean(c['badge']), 'image': img(c['image']), 'route': c['route']}
            leaves = [leaf_for(track, c, l) for l in c['leaves']]
            if section == 'pa_exam' and 'connaissances_generales' in c['route']:
                gpx_imgs = {}
                for gc in tree['gpx_exam']['concours']:
                    for gl in gc['leaves']:
                        mm = re.search(r'culture_generale_(\w+)$', gl['route'])
                        if mm:
                            gpx_imgs[mm.group(1)] = img(gl.get('image'))
                leaves = [cg_leaf('pa', label, key, gpx_imgs.get(key) or card['image']) for label, key in PA_CG_THEMES]
            if not leaves:
                # Carte à ouverture directe (ex. cas pratique GPX) : une seule entrée.
                leaves = [{'id': card['id'], 'label': clean(c['label']), 'image': card['image'], 'route': c['route'], 'kind': 'app', 'reason': app_only(c['route'])}]
            card['leaves'] = leaves
            cards.append(card)
        if 'exam' in section:
            progs.append({'key': 'concours', 'label': 'Concours', 'image': None, 'cards': cards})
        else:
            k, label, image = PROGRAM_META[pkey]
            progs.append({'key': k, 'label': label, 'image': img(image), 'cards': cards})
    out[section] = progs

# ─── Profondeur réelle des cours (navigation Flutter) ─────────────────────
# Une feuille « cours » de l'app peut ouvrir une page d'intro (« Commencer »),
# un sommaire de sous-cours (cartes) ou enchaîner plusieurs pages : on suit la
# navigation des fichiers Dart pour retrouver tous les vrais contenus.
import sys as _sys
_sys.path.insert(0, '/home/claude/tools/courses')
from resolve import resolve as _resolve, module_of as _module_of, is_quiz as _is_quiz  # noqa: E402
from graph import file_of_route as _file_of_route  # noqa: E402
QUIZ_MODULES = set(json.load(open('/home/claude/tools/courses/quiz_modules.json')))
QUIZ_CANDIDATES = set()

def _human(f):
    b = f.split('/')[-1].replace('.dart', '')
    b = re.sub(r'^(gpx_school_|pa_|gpx_)', '', b)
    b = re.sub(r'_(contenu_page|page|contenu|intro_page|intro)$', '', b)
    return b.replace('_', ' ').strip().capitalize()

def _chain(r):
    files = [r['file']]
    while r.get('next') and r['next'].get('type') == 'course' and len(files) < 8:
        r = r['next']
        files.append(r['file'])
    return files

STATS = {'followed': 0, 'chains': 0, 'groups': 0, 'children': 0, 'quizzes': 0}

def _quiz_leaf(parent_id, q, track):
    mod = _module_of(q['file'])
    QUIZ_CANDIDATES.add(mod)
    if len(QUIZ_MODULES) > 100 and mod not in QUIZ_MODULES:
        return None
    STATS['quizzes'] += 1
    label = clean(q.get('title')) or 'Quiz'
    return {'id': (parent_id + '--' + slug(label))[:110], 'label': label, 'image': img(q.get('image')), 'kind': 'quiz', 'module': mod, 'moduleName': label, 'quizName': label}

def _from_resolved(r, base, track, depth=0):
    if r['type'] == 'course':
        files = _chain(r)
        if files[0] != base.get('src'):
            STATS['followed'] += 1
        if len(files) > 1:
            STATS['chains'] += 1
        out = dict(base, kind='course', src=files[0])
        if len(files) > 1:
            out['srcs'] = files
        return out
    STATS['groups'] += 1
    kids = []
    for ch in r['children']:
        card = ch['card']
        label = clean(card.get('title')) or _human(ch['file'])
        cid = (base['id'] + '--' + slug(label))[:110]
        if any(k['id'] == cid for k in kids):
            cid = (cid + '-' + str(len(kids)))[:110]
        cb = {'id': cid, 'label': label, 'image': img(card.get('image')) or base.get('image'), 'subtitle': clean(card.get('subtitle'))}
        kids.append(_from_resolved(ch, cb, track, depth + 1))
        STATS['children'] += 1
    for q in r.get('quizzes', []):
        ql = _quiz_leaf(base['id'], q, track)
        if ql and not any(k.get('module') == ql['module'] for k in kids):
            kids.append(ql)
    g = {k: v for k, v in base.items() if k not in ('db', 'src', 'srcs', 'kind')}
    return dict(g, kind='group', children=kids)

for section, progs in out.items():
    if 'school' not in section:
        continue
    track = section.split('_')[0]
    for p in progs:
        for c in p['cards']:
            new = []
            for l in c['leaves']:
                if l['kind'] == 'course':
                    r = None
                    starts = [l.get('src')]
                    # Anomalie app : la carte « Contrôles et vérifications d’identité » (GPX) ouvre
                    # le flagrant délit ; le site ouvre le vrai cours du contrôle d’identité.
                    if re.search(r"contr[ôo]les et v[ée]rifications d.identit", l['label'], re.I):
                        base_dir = 'lib/content/gpx_scolarite/dps_dpg' if track == 'gpx' else 'lib/content/pa_scolarite'
                        starts = [f'{base_dir}/cadres_juridiques_pages/controle_identite/controle_identite_intro_page.dart']
                    for start in (*starts, _file_of_route(l.get('route') or ''), _file_of_route(l.get('db') or '')):
                        if start:
                            r = _resolve(start)
                            if r:
                                break
                    if r:
                        l = _from_resolved(r, l, track)
                new.append(l)
            c['leaves'] = new

            def _fix_quiz(ls, card_label=c['label']):
                for x in ls:
                    if x['kind'] == 'quiz' and x['id'].count('--'):
                        x['moduleName'] = card_label
                    _fix_quiz(x.get('children', []))
            _fix_quiz(new)
print('profondeur', STATS)
open('/home/claude/tools/courses/quiz_candidates.txt', 'w').write(','.join(sorted(QUIZ_CANDIDATES)))

os.makedirs(IMG_DST, exist_ok=True)
for name in used_images:
    shutil.copyfile(f'{IMG_SRC}/{name}.webp', f'{IMG_DST}/{name}.webp')

os.makedirs(f'{WEB}/src/data', exist_ok=True)
json.dump(out, open(f'{WEB}/src/data/app-tree.json', 'w'), ensure_ascii=False, separators=(',', ':'))

from collections import Counter
cnt = Counter(l['kind'] for progs in out.values() for p in progs for c in p['cards'] for l in c['leaves'])
print('images', len(used_images), 'kinds', dict(cnt), 'size', os.path.getsize(f'{WEB}/src/data/app-tree.json'))
ids = Counter((s, p['key'], c['id']) for s, progs in out.items() for p in progs for c in p['cards'])
print('dup card ids', [k for k, v in ids.items() if v > 1][:5])
lids = Counter((s, l['id']) for s, progs in out.items() for p in progs for c in p['cards'] for l in c['leaves'])
print('dup leaf ids', [k for k, v in lids.items() if v > 1][:8])
