"""Pure rendering helpers — no Textual/Rich dependency on pipeline internals.
Kept separate from dashboard.py so the bar/table shapes can be unit-tested
without spinning up a Textual App.
"""

from __future__ import annotations

from dataclasses import dataclass, field


def block_bar(current: int, total: int, width: int = 30) -> str:
    if total <= 0:
        filled = 0
    else:
        filled = min(width, round(width * current / total))
    return "█" * filled + "░" * (width - filled)


def pct(current: int, total: int) -> float:
    return 0.0 if total <= 0 else round(100 * current / total, 1)


def fmt_elapsed(seconds: float) -> str:
    seconds = int(seconds)
    h, rem = divmod(seconds, 3600)
    m, s = divmod(rem, 60)
    return f"{h:02d}:{m:02d}:{s:02d}"


def fmt_eta(remaining_items: int, items_per_second: float) -> str:
    if items_per_second <= 0:
        return "—"
    return fmt_elapsed(remaining_items / items_per_second)


@dataclass
class PhaseInfo:
    name: str
    status: str  # "done" | "active" | "pending" | "error" | "retry"


PHASE_ICONS = {
    "done": "[green]✓[/green]",
    "active": "[cyan]>[/cyan]",
    "pending": "[grey50]○[/grey50]",
    "error": "[red]✗[/red]",
    "retry": "[yellow]↻[/yellow]",
    "warning": "[yellow]![/yellow]",
}

DEFAULT_PHASES = [
    "Phase 1 — Audit du projet",
    "Phase 2 — Architecture du générateur",
    "Phase 3 — Système de validation",
    "Phase 4 — Génération pilote",
    "Phase 5 — Tests",
    "Phase 6 — Génération massive",
    "Phase 7 — Import progressif Supabase",
    "Phase 8 — Vérification Flutter",
    "Phase 9 — Rapport final",
]


@dataclass
class DashboardState:
    category_label: str = "Histoire de France & Institutions"
    objective_total: int = 150_000
    status_label: str = "GÉNÉRATION EN COURS"
    started_at_epoch: float = 0.0

    phases: list[PhaseInfo] = field(default_factory=list)

    generated: int = 0
    validated: int = 0
    rejected: int = 0
    duplicates_exact: int = 0
    duplicates_semantic: int = 0
    paraphrases_detected: int = 0
    factual_errors: int = 0
    invalid_distractors: int = 0
    invalid_difficulty: int = 0
    invalid_explanations: int = 0
    quarantined: int = 0
    ready_for_import: int = 0
    imported: int = 0
    import_failed: int = 0

    by_difficulty: dict[str, int] = field(
        default_factory=lambda: {"Facile": 0, "Moyenne": 0, "Difficile": 0}
    )
    target_per_difficulty: int = 50_000

    subtopic_counts: dict[str, int] = field(default_factory=dict)

    current_item_id: str | None = None
    current_item_difficulty: str | None = None
    current_item_subtopic: str | None = None
    current_item_subject: str | None = None
    current_item_action: str | None = None
    current_item_source: str | None = None

    import_batch_current: int = 0
    import_batch_total: int = 0
    import_batch_size: int = 1000
    import_last_result: str = ""
    import_avg_latency_ms: float = 0.0

    services: dict[str, str] = field(
        default_factory=lambda: {
            "Supabase": "ONLINE",
            "Internet": "ONLINE",
            "Générateur": "RUNNING",
            "Validator": "RUNNING",
            "Database Writer": "IDLE",
        }
    )

    recent_events: list[tuple[str, str, str]] = field(default_factory=list)
    # (timestamp, level, message) — level in {"ok","warn","error","info"}

    items_per_minute: float = 0.0
