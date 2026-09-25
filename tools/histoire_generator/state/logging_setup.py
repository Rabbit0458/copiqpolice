"""Persistent, per-run log files — independent of what the TUI shows.

Spec requirement: errors/warnings must survive even if the terminal is
closed or scrolled past. Every event goes to disk; only the last ~12 also
reach the dashboard's on-screen event log (tui/render.py DashboardState).

Layout under a run directory (e.g. logs/run_2026-09-06_1830/):
    main.log               everything, chronological
    errors.log              ERROR only
    warnings.log            WARNING only
    duplicates.log          exact + semantic dedup rejections
    rejected_questions.log  full payload of every rejected/quarantined question
    import.log              Supabase batch import outcomes
    statistics.json         snapshot written alongside each checkpoint save
    checkpoint.json          (see state/checkpoint.py)
"""

from __future__ import annotations

import json
import logging
from datetime import datetime
from pathlib import Path


class RunLogger:
    def __init__(self, run_dir: Path) -> None:
        self.run_dir = run_dir
        run_dir.mkdir(parents=True, exist_ok=True)

        self._logger = logging.getLogger(f"histoire_generator.{run_dir.name}")
        self._logger.setLevel(logging.DEBUG)
        self._logger.propagate = False
        if self._logger.handlers:
            return  # already configured (e.g. re-entrant setup on resume)

        fmt = logging.Formatter("%(asctime)s %(levelname)s %(message)s", "%Y-%m-%d %H:%M:%S")

        def add_handler(filename: str, level: int, only_level: bool = False) -> None:
            handler = logging.FileHandler(run_dir / filename, encoding="utf-8")
            handler.setLevel(level)
            handler.setFormatter(fmt)
            if only_level:
                handler.addFilter(lambda record, lvl=level: record.levelno == lvl)
            self._logger.addHandler(handler)

        add_handler("main.log", logging.DEBUG)
        add_handler("errors.log", logging.ERROR, only_level=True)
        add_handler("warnings.log", logging.WARNING, only_level=True)

        self._duplicates_logger = self._make_sublogger("duplicates.log")
        self._rejected_logger = self._make_sublogger("rejected_questions.log")
        self._import_logger = self._make_sublogger("import.log")

    def _make_sublogger(self, filename: str) -> logging.Logger:
        logger = logging.getLogger(f"histoire_generator.{self.run_dir.name}.{filename}")
        logger.setLevel(logging.DEBUG)
        logger.propagate = False
        if not logger.handlers:
            handler = logging.FileHandler(self.run_dir / filename, encoding="utf-8")
            handler.setFormatter(logging.Formatter("%(asctime)s %(message)s", "%Y-%m-%d %H:%M:%S"))
            logger.addHandler(handler)
        return logger

    # --- generic ---
    def info(self, msg: str) -> None:
        self._logger.info(msg)

    def warning(self, msg: str) -> None:
        self._logger.warning(msg)

    def error(self, msg: str) -> None:
        self._logger.error(msg)

    # --- domain-specific ---
    def duplicate(self, fingerprint: str, question_a_id, question_b_id, kind: str) -> None:
        self._duplicates_logger.info(
            json.dumps({"fingerprint": fingerprint, "a": question_a_id, "b": question_b_id, "kind": kind}, ensure_ascii=False)
        )

    def rejected(self, question_payload: dict, reason: str) -> None:
        self._rejected_logger.info(json.dumps({"reason": reason, "question": question_payload}, ensure_ascii=False))

    def import_result(self, batch_index: int, inserted: int, retried: int, failed: int, latency_ms: float) -> None:
        self._import_logger.info(
            json.dumps(
                {"batch": batch_index, "inserted": inserted, "retried": retried, "failed": failed, "latency_ms": latency_ms},
                ensure_ascii=False,
            )
        )

    def write_statistics_snapshot(self, stats: dict) -> None:
        (self.run_dir / "statistics.json").write_text(
            json.dumps({**stats, "snapshot_at": datetime.now().isoformat()}, indent=2, ensure_ascii=False),
            encoding="utf-8",
        )
