"""Runtime settings, loaded from environment / .env. No secrets hardcoded here."""

from __future__ import annotations

import os
from dataclasses import dataclass, field

from dotenv import load_dotenv

load_dotenv()


def _require(name: str) -> str:
    value = os.environ.get(name)
    if not value:
        raise RuntimeError(
            f"Missing required environment variable: {name}. "
            f"Set it in a local .env file (never committed)."
        )
    return value


@dataclass(frozen=True)
class Settings:
    # --- Anthropic ---
    anthropic_api_key: str = field(default_factory=lambda: _require("ANTHROPIC_API_KEY"))
    generation_model: str = "claude-sonnet-5"

    # --- Voyage AI (semantic dedup embeddings) ---
    voyage_api_key: str = field(default_factory=lambda: _require("VOYAGE_API_KEY"))
    embedding_model: str = "voyage-3.5"
    similarity_quarantine_threshold: float = 0.90

    # --- Supabase ---
    supabase_url: str = field(default_factory=lambda: _require("SUPABASE_URL"))
    supabase_service_role_key: str = field(
        default_factory=lambda: _require("SUPABASE_SERVICE_ROLE_KEY")
    )

    # --- Targets ---
    category_db_value: str = "Histoire"
    module_db_value: str = "Culture générale"
    target_per_difficulty: int = 50_000
    difficulties: tuple[str, ...] = ("Facile", "Moyenne", "Difficile")

    # --- Batching ---
    questions_per_generation_call: int = 25
    import_batch_size: int = 1000
    delete_batch_size: int = 5000

    # --- Retry / backoff (network operations only) ---
    retry_delays_seconds: tuple[int, ...] = (2, 5, 15, 30)
    max_retries: int = len(retry_delays_seconds)

    # --- Watchdog ---
    watchdog_stall_minutes: int = 15

    # --- TUI refresh ---
    tui_refresh_per_second: int = 4

    # --- Checkpoint ---
    checkpoint_save_interval_seconds: int = 30


def load_settings() -> Settings:
    return Settings()
