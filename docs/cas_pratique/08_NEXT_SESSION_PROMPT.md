# 🔁 Prompt de reprise pour la prochaine session (mode CODING)

> Ce prompt doit être envoyé tel quel par le script Python qui relance la conversation, toutes les 5 heures.

---

## ✂️ COPIER-COLLER CECI :

```
Tu reprends le développement du module Cas Pratique de l'application COP'IQ (Flutter + Supabase). Kaïs dort ou travaille : aucune question à lui poser, prends toutes les initiatives nécessaires.

PROTOCOLE OBLIGATOIRE :

1. Ouvre `docs/cas_pratique/PROGRESSION_CODE.md`.
2. Trouve la PREMIÈRE tâche non cochée (ligne commençant par `- [ ] CODE-XXX —`).
3. Exécute-la INTÉGRALEMENT :
   - Crée / édite les fichiers indiqués
   - Respecte les specs des fichiers de référence (numérotés 01 à 10 dans le même dossier)
   - Respecte la palette #1147D9 / #000B36, la typo Montserrat, dark+light mode
4. Marque la tâche `- [x] (date du jour)` dans PROGRESSION_CODE.md.
5. Ajoute une ligne dans le tableau "LOG DES SESSIONS" en bas du fichier.
6. Mets à jour `docs/cas_pratique/07_STATE.json` :
   - last_completed_task
   - next_task + next_task_label
   - completed counter
   - pending counter
   - ajoute une entrée dans session_log
7. Enchaîne avec la tâche suivante tant qu'il reste des tokens (idéalement 3 à 5 tâches par session).
8. Si tu touches au point où tu n'as plus assez de tokens pour finir une tâche proprement :
   - Marque-la `- [~]` (in-progress) avec une note dans PROGRESSION_CODE.md
   - Mets à jour STATE.json (in_progress counter)
   - Arrête-toi proprement
9. Si une tâche te bloque (asset manquant, secret, décision business) :
   - Marque-la `- [!]` (blocked) dans PROGRESSION_CODE.md
   - Ajoute une entrée au tableau "BLOCAGES & NOTES" en bas
   - Ajoute le blocage à `blockers` dans STATE.json
   - Passe à la suivante

CONTRAINTES TECHNIQUES :

- Cible Flutter (existe : Dart, supabase_flutter, google_fonts, hive si dispo). Si Hive pas dispo, fallback shared_preferences.
- Les migrations SQL vont dans `supabase/migrations/AAAAMMJJ_HHMMSS_<description>.sql`. Tu ne les exécutes PAS sur Supabase.
- Aucune référence à un LLM externe (la correction reste 100 % locale + edge function port TS plus tard).
- Pas d'emojis dans le code (sauf si déjà présents dans le style existant).
- Tu peux utiliser des emojis dans tes messages textuels modestement.
- Toujours respecter `MediaQuery.disableAnimations` pour les animations.

OBJECTIF DE LA SESSION : avancer 3 à 5 tâches CODE-XXX si possible.

Commence par afficher rapidement (en 3 lignes max) :
- la tâche que tu vas exécuter,
- les fichiers que tu vas créer/éditer,
- ta première action.

Puis exécute.
```

---

## 🤖 Pour le script Python

```python
import time, pyautogui

PROMPT_PATH = r"C:\Users\kaiso\Desktop\copiqpolice\docs\cas_pratique\08_NEXT_SESSION_PROMPT.md"

def get_prompt():
    text = open(PROMPT_PATH, "r", encoding="utf-8").read()
    start = text.find("```\n", text.find("## ✂️")) + 4
    end = text.find("```", start)
    return text[start:end].strip()

while True:
    pyautogui.press("up")               # rappelle le dernier message
    time.sleep(0.5)
    pyautogui.hotkey("ctrl","a"); pyautogui.press("delete")
    pyautogui.typewrite(get_prompt(), interval=0.005)
    pyautogui.press("enter")
    time.sleep(60 * 60 * 5)              # attendre 5 heures
```

(Adapter à ton setup. Le user-agent du script doit cibler la fenêtre Cowork.)

---

## 📋 Checklist avant fin de session

À faire impérativement avant que la session ne soit coupée :

- [ ] `PROGRESSION_CODE.md` à jour (cases cochées + log session ajoutée)
- [ ] `07_STATE.json` à jour (compteurs + session_log + next_task)
- [ ] Aucune tâche laissée en `[~]` accidentellement (sauf si volontaire car limite tokens)
- [ ] Le code écrit compile (`flutter analyze` mental sur les fichiers touchés)
