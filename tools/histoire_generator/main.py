"""Entrypoint — COP'IQ Histoire de France & Institutions generator.

Phase 2 scope: process wiring (checkpoint resume, logging, dashboard,
safe-quit) only. The actual generation/validation/import stages
(pipeline/generator.py, validators.py, dedup.py, importer.py, scheduler.py)
are Phase 3 (validation system) and Phase 4 (pilot generation) — not
implemented yet, so --afk currently has nothing to drive besides the UI
shell. Do not point this at production data until those phases are signed
off.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from state.checkpoint import Checkpoint, find_latest_session, load, new_session_id, save
from state.logging_setup import RunLogger

RUN_LOGS_ROOT = Path(__file__).parent / "logs"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="COP'IQ — générateur Histoire de France & Institutions")
    parser.add_argument("--afk", action="store_true", help="Mode autonome : pas de prompts bloquants, sauvegardes fréquentes.")
    parser.add_argument("--resume", action="store_true", help="Reprendre automatiquement la dernière session interrompue, sans demander.")
    parser.add_argument("--new-session", action="store_true", help="Forcer une nouvelle session même si une session interrompue existe.")
    parser.add_argument("--dry-run", action="store_true", help="Ne génère ni n'importe rien réellement — vérifie seulement la configuration.")
    parser.add_argument("--demo-ui", action="store_true", help="Lance uniquement le dashboard avec des données factices (aucun appel API, aucune écriture DB).")
    return parser.parse_args()


def resolve_session(args: argparse.Namespace) -> tuple[Path, Checkpoint]:
    if not args.new_session:
        existing = find_latest_session(RUN_LOGS_ROOT)
        if existing is not None:
            checkpoint = load(existing)
            if checkpoint is not None:
                total_done = sum(checkpoint.by_difficulty.values())
                if args.resume:
                    should_resume = True
                elif args.afk:
                    # Never block in AFK mode — default to resuming the most
                    # recent interrupted session rather than asking.
                    should_resume = True
                else:
                    print(f"Session interrompue détectée : {existing.name}")
                    print(f"Progression : {total_done:,} questions (tous niveaux confondus)".replace(",", " "))
                    answer = input("Reprendre ? [Y] Oui  [N] Nouvelle session : ").strip().lower()
                    should_resume = answer in ("y", "yes", "o", "oui", "")
                if should_resume:
                    return existing, checkpoint

    session_id = new_session_id()
    run_dir = RUN_LOGS_ROOT / session_id
    checkpoint = Checkpoint(session_id=session_id, started_at=_now_iso(), updated_at=_now_iso())
    return run_dir, checkpoint


def _now_iso() -> str:
    from datetime import datetime, timezone

    return datetime.now(timezone.utc).isoformat()


def main() -> int:
    args = parse_args()

    if args.demo_ui:
        from tui.dashboard import GeneratorDashboard

        GeneratorDashboard(demo=True).run()
        return 0

    run_dir, checkpoint = resolve_session(args)
    logger = RunLogger(run_dir)
    logger.info(f"Session {checkpoint.session_id} — phase={checkpoint.phase} afk={args.afk} dry_run={args.dry_run}")

    if args.dry_run:
        from config.settings import load_settings

        try:
            load_settings()
            print("Configuration OK (clés API présentes, variables d'environnement chargées).")
        except RuntimeError as exc:
            print(f"Configuration invalide : {exc}")
            return 1
        return 0

    save(checkpoint, run_dir)
    print(
        "Phase 3 (validation) et Phase 4 (génération pilote) ne sont pas encore implémentées — "
        "rien à exécuter au-delà de la vérification de session/config pour l'instant."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
