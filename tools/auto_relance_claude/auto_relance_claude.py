# ═══════════════════════════════════════════════════════════════════════════
#  AUTO-RELANCE CLAUDE — version AUTONOME STRICTE
#  ─────────────────────────────────────────────────────────────────────────
#  Le PC tourne 24/7 sans intervention humaine pendant des semaines.
#  Le user lance lui-même la conversation. Le script :
#
#    1. SURVEILLE en continu (screenshot + OCR toutes les 20s)
#    2. DÉTECTE le message officiel de blocage :
#         "You've hit your session limit · resets X:XX(am|pm) (Europe/Paris)"
#    3. DOUBLE-VÉRIFIE : 2 screenshots à 10s d'intervalle, MÊME heure parsée
#    4. ATTEND jusqu'à l'heure de déblocage + 180s de cooldown
#    5. RE-VÉRIFIE que le message de blocage a disparu (sinon attend encore)
#    6. ENVOIE le message de relance pointant vers docs/cas_pratique
#    7. RECOMMENCE
#
#  Stratégies fallback SUPPRIMÉES (B et C de l'ancienne version) :
#    ❌ Pas de "blind heartbeat toutes les 12h" → causait des envois à tort
#    ❌ Pas de "lockout sans heure → attendre 5h30" → causait des attentes
#       fantômes quand l'OCR ratait un caractère
#    ✅ Le script reste 100% passif tant qu'il n'a pas DEUX confirmations
#       OCR avec heure parsée IDENTIQUE
#
#  Sécurités automatiques :
#    - Auto-restart en cas de crash (wrapper .bat)
#    - Focus de la fenêtre Claude avant chaque envoi
#    - Clipboard (Ctrl+V) pour gérer les accents AZERTY
#    - Log persistant horodaté dans auto_relance.log
# ═══════════════════════════════════════════════════════════════════════════

import datetime
import os
import re
import sys
import time
import traceback
from pathlib import Path

# ──────────────────────────────────────────────────────────────────────────
#  CONFIG
# ──────────────────────────────────────────────────────────────────────────

# Message envoyé à chaque relance (pointe vers la roadmap des cas pratiques)
RELANCE_MESSAGE = (
    "Continue le développement de la partie Cas Pratique de l'application. "
    "Lis docs/cas_pratique/PROGRESSION_CODE.md et docs/cas_pratique/07_STATE.json "
    "pour identifier la prochaine tâche CODE-XXX à coder. "
    "Respecte STRICTEMENT les règles anti-cassage : "
    "Read avant Edit, jamais de Write sur un fichier existant sans Read complet, "
    "préfère créer des fichiers nouveaux plutôt que modifier les existants. "
    "Enchaîne les tâches CODE-XXX dans l'ordre jusqu'à 100/100."
)

# Fréquence des screenshots quand on cherche un blocage (secondes)
POLL_INTERVAL_SECONDS = 20

# Intervalle entre les 2 screenshots de double vérification (secondes)
DOUBLE_CHECK_DELAY_SECONDS = 10

# Cooldown après l'heure de déblocage avant d'envoyer (secondes)
POST_UNLOCK_COOLDOWN_SECONDS = 180

# Pause entre 2 vérifications "blocage encore présent ?" après cooldown (s)
POST_UNLOCK_RETRY_DELAY_SECONDS = 60
MAX_POST_UNLOCK_RETRIES = 15  # 15 * 60s = 15min max d'attente supplémentaire

# Cooldown après un envoi réussi avant de reprendre la surveillance
COOLDOWN_AFTER_SEND_SECONDS = 90

# Frappe / focus
TYPE_INTERVAL = 0.025
PAUSE_AFTER_FOCUS_SECONDS = 1.2
PAUSE_AFTER_CLICK_SECONDS = 0.4

# Tesseract Windows
TESSERACT_CMD = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

# Multi-écran
CAPTURE_ALL_SCREENS = True

# Mode debug : affiche un extrait de l'OCR à chaque poll
DEBUG_OCR = False

# Titres de fenêtre à chercher pour Claude
CLAUDE_WINDOW_TITLES = ["Claude", "claude.ai", "Anthropic", "Cowork"]

# Position relative de la zone de saisie dans la fenêtre Claude
INPUT_FIELD_RELATIVE_X = 0.50
INPUT_FIELD_RELATIVE_Y = 0.92

# Heartbeat info dans le terminal (rassurant, pas d'action)
HEARTBEAT_INTERVAL_MINUTES = 5

# Log file (à côté du script)
LOG_FILE = Path(__file__).parent / "auto_relance.log"

# ──────────────────────────────────────────────────────────────────────────
#  IMPORTS
# ──────────────────────────────────────────────────────────────────────────

try:
    import pyautogui
    pyautogui.FAILSAFE = False
except ImportError:
    print("❌ pyautogui manquant — pip install pyautogui")
    sys.exit(1)

# Clipboard pour AZERTY
HAS_PYPERCLIP = False
try:
    import pyperclip
    HAS_PYPERCLIP = True
except ImportError:
    pass

import tkinter as _tk

HAS_OCR = False
try:
    import pytesseract
    from PIL import ImageGrab
    if Path(TESSERACT_CMD).exists():
        pytesseract.pytesseract.tesseract_cmd = TESSERACT_CMD
        pytesseract.get_tesseract_version()
        HAS_OCR = True
except Exception:
    HAS_OCR = False

HAS_WIN = False
try:
    import pygetwindow as gw
    HAS_WIN = True
except ImportError:
    HAS_WIN = False


# ──────────────────────────────────────────────────────────────────────────
#  LOGGING
# ──────────────────────────────────────────────────────────────────────────

def log(msg):
    ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{ts}] {msg}"
    print(line, flush=True)
    try:
        with LOG_FILE.open("a", encoding="utf-8") as f:
            f.write(line + "\n")
    except Exception:
        pass


# ──────────────────────────────────────────────────────────────────────────
#  PATTERNS DE DÉTECTION — STRICTS
# ──────────────────────────────────────────────────────────────────────────

# On exige une preuve forte : message de blocage + heure parsée explicitement.
# Ces triggers seuls ne déclenchent RIEN ; il faut COUPLER trigger + heure.

LOCKOUT_TRIGGERS = [
    "session limit",
    "hit your",
    "limite atteinte",
    "essayez un autre",
    "essayez plus tard",
    "another model",
    "weekly limit",
    "5-hour limit",
    "available again",
    "réinitialise", "reinitialise",
]

# Patterns reconnus pour parser l'heure de reset
RESET_PATTERNS = [
    # "resets 4:40am (Europe/Paris)" — format Claude officiel
    r"reset[s]?\s+(\d{1,2})\s*[:h]\s*(\d{2})\s*(am|pm)\b",
    # "available again at 4:40am"
    r"available\s+again\s+at\s+(\d{1,2})\s*[:h]\s*(\d{2})\s*(am|pm)?\b",
    # "se réinitialise à 22h50"
    r"r[ée]initialise[^0-9]{0,15}(\d{1,2})\s*[h:]\s*(\d{2})",
    # "réinitialisation à 22:50"
    r"r[ée]initialisation[^0-9]{0,15}(\d{1,2})\s*[h:]\s*(\d{2})",
    # "reprise à 22h50"
    r"reprise[^0-9]{0,15}(\d{1,2})\s*[h:]\s*(\d{2})",
]


# ──────────────────────────────────────────────────────────────────────────
#  CLIPBOARD HELPER (pyperclip OU tkinter en fallback stdlib)
# ──────────────────────────────────────────────────────────────────────────

def copy_to_clipboard(text):
    if HAS_PYPERCLIP:
        try:
            pyperclip.copy(text)
            return True
        except Exception as e:
            log(f"⚠️ pyperclip failed ({e}), fallback tkinter")
    try:
        root = _tk.Tk()
        root.withdraw()
        root.clipboard_clear()
        root.clipboard_append(text)
        root.update()
        time.sleep(0.1)
        root.destroy()
        return True
    except Exception as e:
        log(f"⚠️ tkinter clipboard failed: {e}")
        return False


# ──────────────────────────────────────────────────────────────────────────
#  OCR
# ──────────────────────────────────────────────────────────────────────────

def ocr_screen():
    """Capture tous les écrans, OCR, retourne le texte. '' si erreur."""
    if not HAS_OCR:
        return ""
    try:
        try:
            img = ImageGrab.grab(all_screens=CAPTURE_ALL_SCREENS)
        except TypeError:
            img = ImageGrab.grab()
        text = pytesseract.image_to_string(img, lang="eng+fra")
        if DEBUG_OCR:
            preview = " | ".join(
                line.strip() for line in text.splitlines() if line.strip()
            )[:300]
            log(f"🔍 OCR: {preview}")
        return text
    except Exception as e:
        log(f"⚠️ OCR error: {e}")
        return ""


def has_lockout_trigger(text):
    """True si un mot-clé de blocage est présent."""
    text_low = text.lower()
    return any(trigger in text_low for trigger in LOCKOUT_TRIGGERS)


def _parse_hm(text):
    """Parse hour & minute depuis le texte. Retourne (h, m) ou None.
    Helper interne — pas de rollover, pas de bascule jour."""
    text_low = text.lower()
    for pattern in RESET_PATTERNS:
        for m in re.finditer(pattern, text_low):
            try:
                hour = int(m.group(1))
                minute = int(m.group(2))
            except (ValueError, IndexError):
                continue
            groups = m.groups()
            am_pm = groups[2] if len(groups) > 2 else None
            if am_pm == "pm" and hour < 12:
                hour += 12
            elif am_pm == "am" and hour == 12:
                hour = 0
            if not (0 <= hour <= 23 and 0 <= minute <= 59):
                continue
            return (hour, minute)
    return None


def parse_reset_time(text):
    """Cherche une heure de déblocage dans `text`.
    Retourne un datetime FUTUR (aujourd'hui ou demain si l'heure est passée).
    → Utilisé pour calculer combien de temps attendre avant la reprise."""
    hm = _parse_hm(text)
    if hm is None:
        return None
    hour, minute = hm
    now = datetime.datetime.now()
    target = now.replace(hour=hour, minute=minute, second=0, microsecond=0)
    if target <= now:
        target += datetime.timedelta(days=1)
    return target


def parse_reset_time_today_raw(text):
    """Comme parse_reset_time mais SANS rollover : retourne le datetime
    du jour même si l'heure est déjà passée.
    → Utilisé pour distinguer un ANCIEN message visible dans le scroll
    (heure passée) d'un NOUVEAU blocage actif (heure future)."""
    hm = _parse_hm(text)
    if hm is None:
        return None
    hour, minute = hm
    now = datetime.datetime.now()
    return now.replace(hour=hour, minute=minute, second=0, microsecond=0)


def detect_lockout_once():
    """
    UNE détection : retourne datetime cible si le message complet est trouvé,
    sinon None. Exige : (trigger présent) ET (heure parsable).
    """
    text = ocr_screen()
    if not text:
        return None
    if not has_lockout_trigger(text):
        return None
    target = parse_reset_time(text)
    return target


def detect_lockout_with_double_check():
    """
    DOUBLE détection — c'est le cœur de la robustesse.
    1. Premier screenshot : on doit voir le trigger + parser une heure
    2. On attend DOUBLE_CHECK_DELAY_SECONDS
    3. Second screenshot : MÊME heure parsée
    Si oui → datetime cible. Sinon → None.
    """
    target_1 = detect_lockout_once()
    if target_1 is None:
        return None
    log(f"🔎 1ère détection : reprise potentielle à {target_1.strftime('%H:%M')}")
    log(f"   Double-check dans {DOUBLE_CHECK_DELAY_SECONDS}s…")
    time.sleep(DOUBLE_CHECK_DELAY_SECONDS)
    target_2 = detect_lockout_once()
    if target_2 is None:
        log("   ❌ Pas confirmé au 2e check — on continue à surveiller (pas d'action).")
        return None
    if abs((target_1 - target_2).total_seconds()) > 60:
        log(
            f"   ❌ Heure inconsistante (1: {target_1.strftime('%H:%M')} vs "
            f"2: {target_2.strftime('%H:%M')}) — on ignore."
        )
        return None
    log(f"   ✅ Confirmé : reprise à {target_2.strftime('%H:%M')}")
    return target_2


def confirm_unlocked():
    """
    Vérifie que le chat est réellement débloqué.

    ⚠️ Le texte du blocage RESTE souvent visible dans l'historique du chat
       même après déblocage (le message Claude reste affiché dans le scroll).
       Donc on ne peut pas simplement chercher la présence du trigger.

    Logique :
      • Pas de trigger        → débloqué ✅
      • Trigger sans heure    → on doute, on autorise (pas pénal)
      • Trigger + heure PASSÉE → ancien message visible, débloqué ✅
      • Trigger + heure FUTURE → nouveau blocage actif, encore bloqué ❌

    Marge de tolérance : on considère "passée" toute heure ≤ now + 2 min
    (au cas où Claude affiche un blocage qui démarre quelques secondes plus
    tard).
    """
    text = ocr_screen()
    if not text:
        return True  # OCR vide = présumé débloqué

    if not has_lockout_trigger(text):
        return True  # Pas de trigger = clean

    # Trigger présent → on analyse l'heure
    parsed_today = parse_reset_time_today_raw(text)
    if parsed_today is None:
        # Trigger sans heure parsable → on laisse passer (faux positif probable)
        log("   ℹ️ Trigger détecté mais heure non parsable → envoi autorisé.")
        return True

    now = datetime.datetime.now()
    delta_seconds = (parsed_today - now).total_seconds()

    if delta_seconds <= 120:
        # Heure dans le passé (ou très proche) → ancien message visible
        log(
            f"   ✅ Trigger visible mais heure parsée ({parsed_today.strftime('%H:%M')}) "
            f"est dans le passé → ancien message, chat débloqué."
        )
        return True

    # Heure dans le futur → nouveau blocage actif
    log(
        f"   ❌ Nouveau blocage détecté : reset prévu à "
        f"{parsed_today.strftime('%H:%M')} (dans {int(delta_seconds // 60)}min)."
    )
    return False


# ──────────────────────────────────────────────────────────────────────────
#  FOCUS FENÊTRE
# ──────────────────────────────────────────────────────────────────────────

def find_claude_window():
    if not HAS_WIN:
        return None
    try:
        for w in gw.getAllWindows():
            if not w.title:
                continue
            for keyword in CLAUDE_WINDOW_TITLES:
                if keyword.lower() in w.title.lower():
                    return w
    except Exception as e:
        log(f"⚠️ find window: {e}")
    return None


def focus_claude_window():
    w = find_claude_window()
    if w is None:
        log("⚠️ Fenêtre Claude introuvable.")
        return False
    try:
        if w.isMinimized:
            w.restore()
        w.activate()
        time.sleep(PAUSE_AFTER_FOCUS_SECONDS)
        log(f"🎯 Fenêtre activée : « {w.title} »")
        return True
    except Exception as e:
        log(f"⚠️ Activation échouée : {e}")
        return False


def click_input_field():
    w = find_claude_window()
    if w is None:
        screen_w, screen_h = pyautogui.size()
        x = int(screen_w * INPUT_FIELD_RELATIVE_X)
        y = int(screen_h * INPUT_FIELD_RELATIVE_Y)
    else:
        x = w.left + int(w.width * INPUT_FIELD_RELATIVE_X)
        y = w.top + int(w.height * INPUT_FIELD_RELATIVE_Y)
    try:
        pyautogui.click(x, y)
        time.sleep(PAUSE_AFTER_CLICK_SECONDS)
        log(f"🖱  Click sur zone saisie ({x}, {y})")
    except Exception as e:
        log(f"⚠️ Click failed: {e}")


# ──────────────────────────────────────────────────────────────────────────
#  ENVOI DU MESSAGE
# ──────────────────────────────────────────────────────────────────────────

def send_relance():
    """Focus → click input → clipboard → Ctrl+A delete → Ctrl+V → enter."""
    log("📤 Envoi du message de relance…")
    focus_claude_window()
    click_input_field()

    ok = copy_to_clipboard(RELANCE_MESSAGE)
    if not ok:
        log("❌ Clipboard KO. Envoi avorté.")
        return False

    method = "pyperclip" if HAS_PYPERCLIP else "tkinter"
    log(f"📋 Copié dans clipboard ({method})")
    time.sleep(0.4)

    # Efface ce qui pourrait être dans la zone de saisie
    pyautogui.hotkey("ctrl", "a")
    time.sleep(0.15)
    pyautogui.press("delete")
    time.sleep(0.15)

    pyautogui.hotkey("ctrl", "v")
    log("📥 Collé (Ctrl+V)")
    time.sleep(0.6)

    pyautogui.press("enter")
    log("✅ Message envoyé.")
    return True


# ──────────────────────────────────────────────────────────────────────────
#  ATTENTE
# ──────────────────────────────────────────────────────────────────────────

def wait_until(target, label="reprise"):
    """Sleep jusqu'à `target` avec compteur live."""
    last_log = time.time()
    while True:
        now = datetime.datetime.now()
        remaining = (target - now).total_seconds()
        if remaining <= 0:
            print(" " * 80, end="\r")
            return
        h, rem = divmod(int(remaining), 3600)
        m, s = divmod(rem, 60)
        print(
            f"⏳ {label} dans {h:02d}h{m:02d}m{s:02d}s  "
            f"(target {target.strftime('%d/%m %H:%M:%S')})    ",
            end="\r",
            flush=True,
        )
        if time.time() - last_log > 900:  # log persistant toutes les 15min
            log(f"⏳ Attente {label} — reste {h:02d}h{m:02d}m{s:02d}s")
            last_log = time.time()
        time.sleep(1)


# ──────────────────────────────────────────────────────────────────────────
#  BANNER
# ──────────────────────────────────────────────────────────────────────────

def banner():
    log("═" * 70)
    log("  AUTO-RELANCE CLAUDE — version AUTONOME STRICTE")
    log("═" * 70)
    log(f"  OCR (Tesseract)     : {'OUI' if HAS_OCR else 'NON'}")
    log(f"  Window focus (pygw) : {'OUI' if HAS_WIN else 'NON (pip install pygetwindow)'}")
    log(f"  Clipboard           : {'pyperclip' if HAS_PYPERCLIP else 'tkinter (stdlib)'}")
    log(f"  Poll                : toutes les {POLL_INTERVAL_SECONDS}s")
    log(f"  Double-check delay  : {DOUBLE_CHECK_DELAY_SECONDS}s")
    log(f"  Cooldown post-unlock: {POST_UNLOCK_COOLDOWN_SECONDS}s")
    log(f"  Log file            : {LOG_FILE}")
    log("═" * 70)
    log("  LOGIQUE STRICTE :")
    log("   • PAS d'envoi au démarrage (tu lances la conv toi-même)")
    log("   • Détection OCR du message 'session limit · resets X:XXam'")
    log("   • DOUBLE-CHECK obligatoire (2 OCR à 10s, même heure parsée)")
    log("   • Attente jusqu'à l'heure de reset + 180s cooldown")
    log("   • Vérification que le blocage a disparu AVANT d'envoyer")
    log("   • Si encore bloqué → re-attend 60s et re-check")
    log("   • Pas de fallback aveugle (zéro envoi 'au cas où')")
    log("═" * 70)


# ──────────────────────────────────────────────────────────────────────────
#  BOUCLE PRINCIPALE
# ──────────────────────────────────────────────────────────────────────────

def autonomous_loop():
    """
    Boucle infinie en mode strict :
      1. Poll OCR
      2. Si détection + double-check OK → attente précise → envoi
      3. Sinon → continue à surveiller (jamais d'action sans preuve)
    """
    log("👁  Surveillance autonome démarrée.")
    log("   (tu peux utiliser la conversation normalement, je n'agis QUE")
    log("    quand je détecte un blocage explicite)")
    consecutive_polls = 0
    last_heartbeat_log = time.time()
    heartbeat_interval_sec = HEARTBEAT_INTERVAL_MINUTES * 60

    while True:
        # ── DÉTECTION + DOUBLE-CHECK ─────────────────────────────────────
        target = detect_lockout_with_double_check()

        if target is not None:
            # On a un blocage confirmé avec heure de reprise.
            log(
                f"🔒 BLOCAGE CONFIRMÉ — reprise à {target.strftime('%H:%M')} "
                f"+ cooldown {POST_UNLOCK_COOLDOWN_SECONDS}s"
            )
            cooldown_end = target + datetime.timedelta(
                seconds=POST_UNLOCK_COOLDOWN_SECONDS
            )
            wait_until(cooldown_end, label="reprise+cooldown")
            print()

            # ── VÉRIFICATION POST-COOLDOWN ─────────────────────────────
            # On s'assure que le blocage a vraiment disparu avant d'envoyer.
            log("🔍 Vérification que le chat est bien débloqué…")
            sent = False
            for attempt in range(MAX_POST_UNLOCK_RETRIES):
                if confirm_unlocked():
                    log("✅ Chat débloqué confirmé. Envoi du message.")
                    if send_relance():
                        sent = True
                    break
                else:
                    log(
                        f"⚠️ Le message de blocage est encore présent "
                        f"(retry {attempt + 1}/{MAX_POST_UNLOCK_RETRIES}). "
                        f"Re-vérif dans {POST_UNLOCK_RETRY_DELAY_SECONDS}s…"
                    )
                    time.sleep(POST_UNLOCK_RETRY_DELAY_SECONDS)

            if not sent:
                log(
                    "⚠️ Toujours bloqué après les retries. "
                    "On reprend la surveillance — on retombera sur le blocage."
                )

            log(
                f"😴 Cooldown {COOLDOWN_AFTER_SEND_SECONDS}s avant de "
                f"reprendre la surveillance…"
            )
            time.sleep(COOLDOWN_AFTER_SEND_SECONDS)
            log("👁  Surveillance reprise.")
            consecutive_polls = 0
            last_heartbeat_log = time.time()
            continue

        # ── Pas de blocage détecté : on attend ───────────────────────────
        consecutive_polls += 1
        if time.time() - last_heartbeat_log >= heartbeat_interval_sec:
            log(
                f"💓 Toujours actif — {consecutive_polls} polls. "
                f"Aucun blocage détecté. J'attends."
            )
            last_heartbeat_log = time.time()

        time.sleep(POLL_INTERVAL_SECONDS)


# ──────────────────────────────────────────────────────────────────────────
#  ENTRY POINT — avec auto-restart interne
# ──────────────────────────────────────────────────────────────────────────

def main():
    global DEBUG_OCR
    for arg in sys.argv[1:]:
        if arg in ("--debug", "-d"):
            DEBUG_OCR = True

    banner()

    if not HAS_OCR:
        log("❌ Tesseract introuvable — le script ne peut PAS fonctionner.")
        log("   Installer : https://github.com/UB-Mannheim/tesseract/wiki")
        log("   Puis : pip install pytesseract pillow")
        sys.exit(1)

    if not HAS_WIN:
        log("⚠️  pygetwindow absent — pas de focus auto.")
        log("   Installer : pip install pygetwindow")

    while True:
        try:
            autonomous_loop()
        except KeyboardInterrupt:
            log("👋 Stop demandé (Ctrl+C).")
            return
        except Exception as e:
            log(f"💥 CRASH : {e}")
            log(traceback.format_exc())
            log("🔄 Restart dans 30s…")
            time.sleep(30)


if __name__ == "__main__":
    main()
