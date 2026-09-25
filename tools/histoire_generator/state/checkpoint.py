"""Checkpoint persistence — the "never restart from zero" contract.

Written atomically (tmp file + os.replace) so a crash mid-write never leaves
a corrupt checkpoint.json behind. Saved on an interval (see
Settings.checkpoint_save_interval_seconds) and on every safe-stop (Q key,
SIGTERM, critical error).
"""

from __future__ import annotations

import json
import os
import tempfile
from dataclasses import asdict, dataclass, field
from datetime import datetime, timezone
from pathlib import Path


@dataclass
class PendingBatch:
    batch_id: str
    stage: str  # "generation" | "factcheck"
    submitted_at: str
    custom_ids: list[str] = field(default_factory=list)


@dataclass
class Checkpoint:
    session_id: str
    started_at: str
    updated_at: str
    phase: str = "PHASE_6_GENERATION_MASSIVE"

    generated: int = 0
    validated: int = 0
    rejected: int = 0
    quarantined: int = 0
    imported: int = 0
    import_failed: int = 0

    by_difficulty: dict[str, int] = field(
        default_factory=lambda: {"Facile": 0, "Moyenne": 0, "Difficile": 0}
    )

    # subtopic -> difficulty -> count, drives the scheduler's balancing
    subtopic_progress: dict[str, dict[str, int]] = field(default_factory=dict)

    pending_batches: list[PendingBatch] = field(default_factory=list)

    # resume cursor for the staging->prod import phase (Phase 7)
    last_imported_staging_id: int = 0

    # snapshot of prod row ids captured BEFORE any new import — this is
    # exactly the set the final cutover step is allowed to delete. Captured
    # once, never recomputed, so a later re-run can't accidentally delete
    # rows the new pipeline itself inserted.
    legacy_row_ids_snapshot_file: str | None = None

    rng_seed: int = 0

    def touch(self) -> None:
        self.updated_at = datetime.now(timezone.utc).isoformat()


def new_session_id() -> str:
    return "run_" + datetime.now().strftime("%Y-%m-%d_%H%M")


def checkpoint_path(run_dir: Path) -> Path:
    return run_dir / "checkpoint.json"


def save(checkpoint: Checkpoint, run_dir: Path) -> None:
    checkpoint.touch()
    run_dir.mkdir(parents=True, exist_ok=True)
    payload = json.dumps(asdict(checkpoint), indent=2, ensure_ascii=False)

    fd, tmp_path = tempfile.mkstemp(dir=run_dir, prefix=".checkpoint.", suffix=".tmp")
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            f.write(payload)
            f.flush()
            os.fsync(f.fileno())
        os.replace(tmp_path, checkpoint_path(run_dir))
    except BaseException:
        if os.path.exists(tmp_path):
            os.remove(tmp_path)
        raise


def load(run_dir: Path) -> Checkpoint | None:
    path = checkpoint_path(run_dir)
    if not path.exists():
        return None
    data = json.loads(path.read_text(encoding="utf-8"))
    data["pending_batches"] = [PendingBatch(**b) for b in data.get("pending_batches", [])]
    return Checkpoint(**data)


def find_latest_session(logs_root: Path) -> Path | None:
    """Used at startup to detect an interrupted session and offer resume."""
    if not logs_root.exists():
        return None
    candidates = [
        d for d in logs_root.iterdir() if d.is_dir() and checkpoint_path(d).exists()
    ]
    if not candidates:
        return None
    return max(candidates, key=lambda d: d.stat().st_mtime)
