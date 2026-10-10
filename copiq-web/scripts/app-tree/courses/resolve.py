import json, re, sys
sys.path.insert(0, '/home/claude/tools/courses')
from graph import outgoing, fc, files, norm
MIN = 8

def is_quiz(f):
    b = f.split('/')[-1]
    return '/quiz' in f or b.startswith('quiz') or '_quiz_' in b

def module_of(f):
    p = f[len('lib/content/'):-len('.dart')]
    p = p.replace('gpx_scolarite', 'gpx', 1).replace('pa_scolarite', 'pa', 1)
    p = re.sub(r'[^a-z0-9]+', '_', p.lower())
    return re.sub(r'_+', '_', p).strip('_')

def n(f):
    return fc.get(f, {}).get('n', 0)

def resolve(f, seen=(), depth=0):
    if f in seen or depth > 6:
        return None
    seen = seen + (f,)
    outs = [o for o in outgoing(f) if o['file'] not in seen]
    quizzes = [o for o in outs if is_quiz(o['file'])]
    pages = [o for o in outs if not is_quiz(o['file'])]
    kids = []
    for o in pages:
        r = resolve(o['file'], seen, depth + 1)
        if r:
            kids.append((o, r))
    if n(f) < MIN and len(kids) == 1 and not quizzes:
        return kids[0][1]
    if len(kids) >= 2 or (n(f) < MIN and len(kids) >= 1):
        return {'type': 'hub', 'file': f, 'n': n(f), 'children': [dict(r, card=o) for o, r in kids],
                'quizzes': [dict(q) for q in quizzes]}
    if n(f) >= MIN:
        # Une seule suite : page d'accroche courte vers le vrai cours → on suit.
        # Sinon (variante identique, renvoi vers un cours voisin) → on reste ici.
        if len(kids) == 1 and n(f) < 20 and kids[0][1].get('n', 0) >= 3 * n(f):
            return kids[0][1]
        return {'type': 'course', 'file': f, 'n': n(f), 'quizzes': [dict(q) for q in quizzes]}
    return None

if __name__ == '__main__':
    t = json.load(open('/home/claude/work/copiq-web/src/data/app-tree.json'))
    from collections import Counter
    cnt = Counter(); ex = {}
    for s, progs in t.items():
        if 'school' not in s: continue
        for p in progs:
            for c in p['cards']:
                for l in c['leaves']:
                    if l['kind'] != 'course' or not l.get('src'): continue
                    r = resolve(l['src'])
                    k = 'none' if not r else r['type'] + ('+next' if r.get('next') else '')
                    if r and r['type']=='course' and r['file']!=l['src']: k+='(followed)'
                    cnt[k] += 1; ex.setdefault(k, []).append((s, l['label'], r and r['file'].split('/')[-1], r and len(r.get('children',[]))))
    print(cnt)
    for k, v in ex.items():
        print('##', k); [print('  ', x) for x in v[:6]]
