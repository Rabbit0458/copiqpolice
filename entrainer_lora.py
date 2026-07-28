# -*- coding: utf-8 -*-
"""
COP'IQ - Entrainement d'un LoRA "Police Nationale francaise" sur Replicate.

Ce script (a lancer sur TON ordinateur) :
  1. prepare un jeu d'images d'entrainement (dossier lora_dataset),
     en telechargeant au passage tes cas1-11 existants,
  2. convertit tout en JPG propre,
  3. zippe le dossier et l'envoie a Replicate,
  4. cree (si besoin) un modele destination sur ton compte,
  5. lance l'entrainement fast-flux-trainer (~2 min, < 2 $),
  6. ecrit l'identifiant du modele entraine dans lora_model.txt.

Ensuite, generer_photolangage_ia.py utilisera automatiquement ce modele.
"""

import os, sys, time, json, zipfile, uuid, io
import urllib.request, urllib.error

ICI = os.path.dirname(os.path.abspath(__file__))
DATASET = os.path.join(ICI, "lora_dataset")

# --- Reglages ---------------------------------------------------------------
NOM_MODELE   = "copiq-police-nationale"   # nom du modele cree sur ton compte
MOT_DECLENCHEUR = "PNFR"                   # mot-cle injecte dans les prompts
BASE_SUPABASE = "https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/photolangage_pa/"
CAS_EXISTANTS = ["cas1.jpg","cas2.jpg","cas3.jpeg","cas4.jpg","cas5.webp",
                 "cas6.webp","cas7.jpg","cas8.jpg","cas9.jpg","cas10.webp","cas11.webp"]

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
AUTH = {"Authorization": "Bearer " + TOKEN, "User-Agent": "copiq-lora/1.0"}

# --- Petits appels HTTP -----------------------------------------------------
def api_get(url):
    r = urllib.request.Request(url, headers=AUTH, method="GET")
    with urllib.request.urlopen(r, timeout=120) as resp:
        return json.loads(resp.read().decode())

def api_post(url, payload):
    h = dict(AUTH); h["Content-Type"] = "application/json"
    r = urllib.request.Request(url, data=json.dumps(payload).encode(), headers=h, method="POST")
    with urllib.request.urlopen(r, timeout=120) as resp:
        return json.loads(resp.read().decode())

def telecharger(url, dest):
    r = urllib.request.Request(url, headers={"User-Agent": "copiq"})
    with urllib.request.urlopen(r, timeout=120) as resp:
        open(dest, "wb").write(resp.read())

# --- Etape 1 : preparer le dataset -----------------------------------------
def preparer_dataset():
    os.makedirs(DATASET, exist_ok=True)
    # Telecharge les cas existants s'ils ne sont pas deja la.
    for nom in CAS_EXISTANTS:
        dest = os.path.join(DATASET, nom)
        if not os.path.exists(dest):
            try:
                telecharger(BASE_SUPABASE + nom, dest)
                print("   + telecharge %s" % nom)
            except Exception as e:
                print("   ! %s : %s" % (nom, e))

    # Convertit TOUTES les images en JPG RGB propre (webp/png -> jpg).
    try:
        from PIL import Image
    except ImportError:
        print("ERREUR : Pillow manquant. Fais : pip install pillow"); sys.exit(1)

    exts = (".jpg", ".jpeg", ".png", ".webp", ".bmp")
    images = [f for f in os.listdir(DATASET) if f.lower().endswith(exts)]
    n = 0
    for f in images:
        chemin = os.path.join(DATASET, f)
        base, ext = os.path.splitext(f)
        if ext.lower() in (".webp", ".png", ".bmp", ".jpeg"):
            try:
                im = Image.open(chemin).convert("RGB")
                im.save(os.path.join(DATASET, base + ".jpg"), "JPEG", quality=95)
                if ext.lower() != ".jpg":
                    os.remove(chemin)
                n += 1
            except Exception as e:
                print("   ! conversion %s : %s" % (f, e))
    finales = [f for f in os.listdir(DATASET) if f.lower().endswith(".jpg")]
    print("   Dataset : %d images JPG (%d converties)" % (len(finales), n))
    if len(finales) < 8:
        print("\n   ATTENTION : trop peu d'images (%d). Ajoute des vraies photos de" % len(finales))
        print("   Police Nationale dans le dossier lora_dataset (vise 15-25), puis relance.")
        sys.exit(1)
    return finales

# --- Etape 2 : zipper -------------------------------------------------------
def zipper():
    zpath = os.path.join(ICI, "lora_dataset.zip")
    with zipfile.ZipFile(zpath, "w", zipfile.ZIP_DEFLATED) as z:
        for f in os.listdir(DATASET):
            if f.lower().endswith(".jpg"):
                z.write(os.path.join(DATASET, f), f)
    print("   Zip cree : %s (%d Ko)" % (zpath, os.path.getsize(zpath) // 1024))
    return zpath

# --- Etape 3 : upload du zip (Files API) -----------------------------------
def upload_zip(zpath):
    boundary = "----copiq" + uuid.uuid4().hex
    data = open(zpath, "rb").read()
    pre = ("--%s\r\nContent-Disposition: form-data; name=\"content\"; "
           "filename=\"lora_dataset.zip\"\r\nContent-Type: application/zip\r\n\r\n" % boundary).encode()
    post = ("\r\n--%s--\r\n" % boundary).encode()
    body = pre + data + post
    h = dict(AUTH); h["Content-Type"] = "multipart/form-data; boundary=" + boundary
    r = urllib.request.Request("https://api.replicate.com/v1/files", data=body, headers=h, method="POST")
    with urllib.request.urlopen(r, timeout=300) as resp:
        j = json.loads(resp.read().decode())
    url = (j.get("urls") or {}).get("get") or j.get("url")
    if not url:
        raise RuntimeError("upload : URL introuvable dans la reponse")
    print("   Upload OK")
    return url

# --- Etape 4/5 : compte + modele destination -------------------------------
def compte():
    return api_get("https://api.replicate.com/v1/account")["username"]

def creer_modele_si_absent(owner):
    ref = "%s/%s" % (owner, NOM_MODELE)
    try:
        api_get("https://api.replicate.com/v1/models/%s" % ref)
        print("   Modele destination existant : %s" % ref)
        return ref
    except urllib.error.HTTPError as e:
        if e.code != 404:
            raise
    api_post("https://api.replicate.com/v1/models", {
        "owner": owner, "name": NOM_MODELE, "visibility": "private", "hardware": "gpu-t4",
        "description": "COP'IQ - LoRA Police Nationale (photolangage)",
    })
    print("   Modele destination cree : %s" % ref)
    return ref

# --- Etape 6/7/8 : entrainement --------------------------------------------
def entrainer(zip_url, destination):
    ver = api_get("https://api.replicate.com/v1/models/replicate/fast-flux-trainer")["latest_version"]["id"]
    tr = api_post(
        "https://api.replicate.com/v1/models/replicate/fast-flux-trainer/versions/%s/trainings" % ver,
        {"destination": destination,
         "input": {"input_images": zip_url, "trigger_word": MOT_DECLENCHEUR}})
    url = tr["urls"]["get"]
    print("   Entrainement lance (statut : %s)" % tr.get("status"))
    while True:
        tr = api_get(url)
        st = tr.get("status")
        if st in ("succeeded", "failed", "canceled"):
            break
        print("   ... %s" % st)
        time.sleep(10)
    if tr.get("status") != "succeeded":
        raise RuntimeError("entrainement %s : %s" % (tr.get("status"), tr.get("error")))
    print("   Entrainement termine avec succes.")

# --- main -------------------------------------------------------------------
def main():
    print("=" * 62)
    print(" COP'IQ - Entrainement LoRA Police Nationale")
    print("=" * 62)
    print("[1/6] Preparation du dataset...");        preparer_dataset()
    print("[2/6] Compression...");                   zpath = zipper()
    print("[3/6] Envoi a Replicate...");             zip_url = upload_zip(zpath)
    print("[4/6] Compte...");                         owner = compte()
    print("[5/6] Modele destination...");            dest = creer_modele_si_absent(owner)
    print("[6/6] Entrainement (~2 min)...");         entrainer(zip_url, dest)

    with open(os.path.join(ICI, "lora_model.txt"), "w", encoding="utf-8") as f:
        f.write(dest + "\n" + MOT_DECLENCHEUR + "\n")
    print("\n" + "=" * 62)
    print(" PRET. Modele : %s   (mot-cle : %s)" % (dest, MOT_DECLENCHEUR))
    print(" Lance maintenant LANCER_PHOTOLANGAGE_IA.bat pour generer.")
    print("=" * 62)

if __name__ == "__main__":
    try:
        main()
    except urllib.error.HTTPError as e:
        try: corps = e.read().decode()
        except Exception: corps = ""
        print("\nERREUR HTTP %s : %s" % (e.code, corps[:500]))
    except Exception as e:
        print("\nERREUR : %s" % e)
