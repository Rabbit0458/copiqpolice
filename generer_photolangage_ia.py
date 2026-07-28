# -*- coding: utf-8 -*-
"""
COP'IQ - Generateur d'images photolangage (Police Nationale) via Replicate.

Si lora_model.txt existe (cree par entrainer_lora.py) : utilise TON modele
entraine -> uniforme Police Nationale authentique.
Sinon : repli sur Flux 1.1 Pro Ultra (uniforme approximatif).

LOT TEST : 10 images en local dans apercu_photolangage_ia pour valider.
"""

import os, sys, time, json
import urllib.request, urllib.error

ICI = os.path.dirname(os.path.abspath(__file__))
DOSSIER_SORTIE = os.path.join(ICI, "apercu_photolangage_ia")
DELAI_ENTRE_IMAGES = 11   # sous <5$ de credit : 6 img/min. Mets 1 si credit >=5$.

# --- Modele : LoRA entraine si dispo, sinon Ultra --------------------------
def charger_modele():
    p = os.path.join(ICI, "lora_model.txt")
    if os.path.exists(p):
        lignes = [l.strip() for l in open(p, encoding="utf-8") if l.strip()]
        if lignes:
            modele = lignes[0]
            trigger = lignes[1] if len(lignes) > 1 else ""
            return modele, trigger, "lora"
    return "black-forest-labs/flux-1.1-pro-ultra", "", "ultra"

MODELE, TRIGGER, MODE = charger_modele()

# --- Description d'uniforme (issue de vraies photos Police Nationale) -------
UNIFORME = (
    "authentic modern French Police Nationale gear: dark navy blue uniform, "
    "black tactical vest with MOLLE webbing and POLICE in bold white block capital "
    "letters across the back, round POLICE NATIONALE shoulder patch with a "
    "blue white red tricolore emblem, navy forage cap or navy cap marked POLICE, "
    "sidearm in a black thigh holster, chest radio; realistic French street, "
    "natural daylight, 35mm DSLR photojournalism, ultra realistic, sharp focus, "
    "realistic proportions, anatomically correct, natural hands, "
    "one single coherent action, no text errors, no watermark"
)

# Scenes coherentes (corps non enchevetres, civils en tenue civile explicite).
SCENES = [
    ("controle_identite",  "two French police officers checking the identity papers of a man in a brown jacket standing on a Paris sidewalk, daytime"),
    ("controle_routier",   "two French police officers at a night traffic checkpoint beside a marked police car with blue lights, talking to a driver through the car window"),
    ("patrouille_pedestre","two French police officers walking on foot patrol along a Parisian street, daytime"),
    ("interpellation",     "a French police officer calmly handcuffing a compliant man in a plain grey hoodie who stands facing a wall, a second officer standing beside them, the detained man in ordinary civilian clothes with no markings"),
    ("controle_deux_roues","two French police officers checking the documents of a scooter rider stopped on a city square, the rider in civilian clothes wearing a black helmet"),
    ("stupefiants",        "two French police officers examining small sealed bags of seized narcotics laid out on a table indoors, focus on the table"),
    ("maintien_ordre",     "a calm standing line of French police officers in black public-order helmets with a blue band forming a cordon on a boulevard, daytime"),
    ("depistage_alcool",   "a French police officer holding a roadside breathalyser device toward a driver standing next to a car, daytime"),
    ("securisation",       "two French police officers standing guard beside blue and white police tape around a parked car on a city street"),
    ("patrouille_velo",    "two French police officers riding bicycles along a city street, daytime"),
]

# --- Token ------------------------------------------------------------------
def lire_token():
    p = os.path.join(ICI, "replicate_token.txt")
    if os.path.exists(p):
        t = open(p, encoding="utf-8").read().strip()
        if t:
            return t
    t = os.environ.get("REPLICATE_API_TOKEN", "").strip()
    if t:
        return t
    print("ERREUR : token manquant (replicate_token.txt)"); sys.exit(1)

TOKEN = lire_token()
# User-Agent explicite : evite le blocage Cloudflare 1010 sur l'API Replicate.
HEADERS = {"Authorization": "Bearer " + TOKEN, "Content-Type": "application/json",
           "User-Agent": "copiq-generator/1.0"}

def _post(url, payload, extra=None):
    h = dict(HEADERS)
    if extra: h.update(extra)
    r = urllib.request.Request(url, data=json.dumps(payload).encode(), headers=h, method="POST")
    with urllib.request.urlopen(r, timeout=180) as resp:
        return json.loads(resp.read().decode())

def _get(url):
    r = urllib.request.Request(url, headers=HEADERS, method="GET")
    with urllib.request.urlopen(r, timeout=180) as resp:
        return json.loads(resp.read().decode())

def construire_prompt(scene):
    base = (TRIGGER + ", " + scene) if TRIGGER else scene
    return base + ", " + UNIFORME

def payload_pour(prompt):
    if MODE == "lora":
        return {"input": {
            "prompt": prompt, "aspect_ratio": "4:3", "num_outputs": 1,
            "output_format": "jpg", "output_quality": 95,
            "go_fast": False, "megapixels": "1",
        }}
    return {"input": {
        "prompt": prompt, "aspect_ratio": "4:3", "output_format": "jpg",
        "raw": True, "safety_tolerance": 3,
    }}

def generer_une(prompt):
    url = "https://api.replicate.com/v1/models/%s/predictions" % MODELE
    payload = payload_pour(prompt)
    res = None
    for _ in range(8):
        try:
            res = _post(url, payload, {"Prefer": "wait"}); break
        except urllib.error.HTTPError as e:
            if e.code == 429:
                attente = 6
                try:
                    attente = int(json.loads(e.read().decode()).get("retry_after", 6)) + 1
                except Exception: pass
                print("   ... bride Replicate, retry dans %ds" % attente)
                time.sleep(attente); continue
            raise
    if res is None:
        raise RuntimeError("bride trop longtemps (429)")
    while res.get("status") in ("starting", "processing"):
        time.sleep(2); res = _get(res["urls"]["get"])
    if res.get("status") != "succeeded":
        raise RuntimeError("echec : %s" % json.dumps(res.get("error") or res.get("status")))
    out = res.get("output")
    if isinstance(out, list): out = out[0]
    if not out: raise RuntimeError("pas d'image en sortie")
    return out

def telecharger(url_img, chemin):
    r = urllib.request.Request(url_img, headers={"User-Agent": "copiq"})
    with urllib.request.urlopen(r, timeout=180) as resp:
        data = resp.read()
    open(chemin, "wb").write(data)
    return len(data)

def main():
    os.makedirs(DOSSIER_SORTIE, exist_ok=True)
    print("=" * 62)
    print(" COP'IQ - Lot test photolangage : %d images" % len(SCENES))
    if MODE == "lora":
        print(" Modele : %s  (LoRA entraine, mot-cle %s)" % (MODELE, TRIGGER))
    else:
        print(" Modele : %s  (repli - entraine d'abord le LoRA !)" % MODELE)
    print(" Sortie : %s" % DOSSIER_SORTIE)
    print("=" * 62)

    ok = 0
    for i, (cat, scene) in enumerate(SCENES, start=1):
        nom = "test_%02d_%s.jpg" % (i, cat)
        chemin = os.path.join(DOSSIER_SORTIE, nom)
        print("\n[%d/%d] %s" % (i, len(SCENES), cat))
        try:
            t0 = time.time()
            url_img = generer_une(construire_prompt(scene))
            poids = telecharger(url_img, chemin)
            print("   OK  %s  (%d Ko, %.0fs)" % (nom, poids // 1024, time.time() - t0))
            ok += 1
        except urllib.error.HTTPError as e:
            corps = ""
            try: corps = e.read().decode()
            except Exception: pass
            print("   ERREUR HTTP %s : %s" % (e.code, corps[:300]))
        except Exception as e:
            print("   ERREUR : %s" % e)
        if i < len(SCENES):
            time.sleep(DELAI_ENTRE_IMAGES)

    print("\n" + "=" * 62)
    print(" TERMINE : %d/%d images. Dossier : %s" % (ok, len(SCENES), DOSSIER_SORTIE))
    print("=" * 62)

if __name__ == "__main__":
    main()
