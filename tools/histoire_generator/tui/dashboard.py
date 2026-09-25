"""COP'IQ Générateur Culture Générale — dashboard TUI.

Textual app shell. Rendering math (bars, pct, eta) lives in tui/render.py so
it stays testable without a running App. The App itself only owns layout,
refresh cadence, and key bindings — it renders whatever DashboardState it's
given via `update_state()`; it has no opinion about where that state comes
from (real pipeline in Phase 4+, or the demo generator below for now).

Run standalone demo:  python -m tui.dashboard --demo
"""

from __future__ import annotations

import time
from datetime import datetime

from rich.panel import Panel
from rich.table import Table
from rich.text import Text
from textual.app import App, ComposeResult
from textual.containers import Horizontal, Vertical, VerticalScroll
from textual.widgets import Footer, Header, Static

from tui.render import DEFAULT_PHASES, PHASE_ICONS, DashboardState, PhaseInfo, block_bar, fmt_elapsed, fmt_eta, pct


class HeaderBox(Static):
    def render_state(self, s: DashboardState) -> Panel:
        elapsed = fmt_elapsed(time.time() - s.started_at_epoch) if s.started_at_epoch else "00:00:00"
        total_target = s.objective_total
        total_done = sum(s.by_difficulty.values())
        table = Table.grid(padding=(0, 1))
        table.add_column(justify="left")
        table.add_row(f"Catégorie : {s.category_label}")
        table.add_row(f"Objectif  : {total_target:,} questions".replace(",", " "))
        table.add_row(f"Statut    : [bold]{s.status_label}[/bold]")
        table.add_row(f"Durée     : {elapsed}")
        table.add_row(f"Progression globale : {pct(total_done, total_target)} %")
        return Panel(table, title="COP'IQ — Générateur Culture Générale — V2", border_style="cyan")


class GlobalProgress(Static):
    def render_state(self, s: DashboardState) -> Panel:
        total_done = sum(s.by_difficulty.values())
        bar = block_bar(total_done, s.objective_total, width=40)
        line1 = f"{bar}  {total_done:,} / {s.objective_total:,}  ({pct(total_done, s.objective_total)}%)".replace(",", " ")
        remaining = s.objective_total - total_done
        eta = fmt_eta(remaining, s.items_per_minute / 60.0)
        line2 = f"Vitesse: {s.items_per_minute:.0f} q/min · {s.items_per_minute * 60:.0f} q/h    ETA: {eta}"
        return Panel(Text(line1 + "\n" + line2), title="Progression totale", border_style="blue")


class DifficultyBars(Static):
    def render_state(self, s: DashboardState) -> Panel:
        table = Table.grid(padding=(0, 1))
        table.add_column(width=10)
        table.add_column()
        table.add_column(justify="right")
        for diff in ("Facile", "Moyenne", "Difficile"):
            done = s.by_difficulty.get(diff, 0)
            bar = block_bar(done, s.target_per_difficulty, width=28)
            table.add_row(diff.upper(), bar, f"{done:,} / {s.target_per_difficulty:,}".replace(",", " "))
        return Panel(table, title="Progression par niveau", border_style="magenta")


class PhaseList(Static):
    def render_state(self, s: DashboardState) -> Panel:
        table = Table.grid(padding=(0, 1))
        table.add_column(width=3)
        table.add_column()
        for phase in s.phases:
            icon = PHASE_ICONS.get(phase.status, "○")
            table.add_row(f"[{icon}]", phase.name)
        return Panel(table, title="Suivi des phases", border_style="white")


class StatsPanel(Static):
    def render_state(self, s: DashboardState) -> Panel:
        rows = [
            ("Générées", s.generated),
            ("Validées", s.validated),
            ("Rejetées", s.rejected),
            ("Doublons exacts", s.duplicates_exact),
            ("Doublons sémantiques", s.duplicates_semantic),
            ("Paraphrases détectées", s.paraphrases_detected),
            ("Erreurs factuelles", s.factual_errors),
            ("Distracteurs invalides", s.invalid_distractors),
            ("Difficultés incorrectes", s.invalid_difficulty),
            ("Explications invalides", s.invalid_explanations),
            ("En quarantaine", s.quarantined),
            ("Prêtes à importer", s.ready_for_import),
            ("Importées", s.imported),
            ("Échouées (import)", s.import_failed),
        ]
        table = Table.grid(padding=(0, 2))
        table.add_column()
        table.add_column(justify="right")
        for label, value in rows:
            table.add_row(label, f"{value:,}".replace(",", " "))
        return Panel(table, title="Statistiques temps réel", border_style="green")


class CurrentItemPanel(Static):
    def render_state(self, s: DashboardState) -> Panel:
        table = Table.grid(padding=(0, 1))
        table.add_column(width=14)
        table.add_column()
        table.add_row("ID interne", s.current_item_id or "—")
        table.add_row("Niveau", s.current_item_difficulty or "—")
        table.add_row("Sous-thème", s.current_item_subtopic or "—")
        table.add_row("Sujet", s.current_item_subject or "—")
        table.add_row("Action", s.current_item_action or "—")
        table.add_row("Source", s.current_item_source or "—")
        return Panel(table, title="Traitement actuel", border_style="cyan")


class SubthemeCoverage(Static):
    def render_state(self, s: DashboardState) -> Panel:
        table = Table.grid(padding=(0, 2))
        table.add_column()
        table.add_column(justify="right")
        for subtopic, count in sorted(s.subtopic_counts.items(), key=lambda kv: -kv[1])[:12]:
            table.add_row(subtopic, f"{count:,}".replace(",", " "))
        return Panel(table, title="Couverture du corpus (top 12)", border_style="white")


class ImportPanel(Static):
    def render_state(self, s: DashboardState) -> Panel:
        bar = block_bar(s.import_batch_current, s.import_batch_total, width=30)
        table = Table.grid(padding=(0, 1))
        table.add_column()
        table.add_row(f"Batch {s.import_batch_current} / {s.import_batch_total}  (taille {s.import_batch_size})")
        table.add_row(bar + f"  {pct(s.import_batch_current, s.import_batch_total)}%")
        table.add_row(s.import_last_result or "—")
        table.add_row(f"Latence moyenne : {s.import_avg_latency_ms:.0f} ms")
        return Panel(table, title="Import Supabase", border_style="blue")


class ServicesPanel(Static):
    def render_state(self, s: DashboardState) -> Panel:
        table = Table.grid(padding=(0, 2))
        table.add_column()
        table.add_column()
        for name, status in s.services.items():
            color = {"ONLINE": "green", "RUNNING": "green", "IDLE": "grey50", "OFFLINE": "red", "PAUSED": "yellow"}.get(status, "white")
            table.add_row(name, f"[{color}]● {status}[/{color}]")
        return Panel(table, title="Services", border_style="white")


class EventLog(Static):
    def render_state(self, s: DashboardState) -> Panel:
        colors = {"ok": "green", "warn": "yellow", "error": "red", "info": "cyan"}
        icons = {"ok": "✓", "warn": "!", "error": "✗", "info": "↻"}
        lines = []
        for ts, level, msg in s.recent_events[-12:]:
            color = colors.get(level, "white")
            icon = icons.get(level, "•")
            lines.append(f"[{color}][{ts}] {icon} {msg}[/{color}]")
        return Panel(Text.from_markup("\n".join(lines) or "—"), title="Derniers événements", border_style="white")


class GeneratorDashboard(App):
    """Live TUI dashboard for the Histoire generator/validator/importer.

    This App only renders. Whoever drives the pipeline calls
    `app.update_state(new_state)` on its own cadence (checkpoint save
    interval or faster); the App itself just refreshes the screen at
    Settings.tui_refresh_per_second, never faster, so the UI can never
    become the bottleneck.
    """

    CSS = """
    Screen {
        layout: vertical;
    }
    #top_row {
        height: 9;
    }
    #main_row {
        height: 1fr;
    }
    #left_col, #right_col {
        width: 1fr;
    }
    #bottom_row {
        height: 10;
    }
    """

    BINDINGS = [
        ("p", "pause", "Pause"),
        ("r", "resume", "Reprendre"),
        ("s", "save_checkpoint", "Sauvegarder"),
        ("l", "show_logs", "Logs"),
        ("q", "safe_quit", "Arrêt sécurisé"),
    ]

    def __init__(self, refresh_per_second: int = 4, demo: bool = False) -> None:
        super().__init__()
        self.state = DashboardState(
            started_at_epoch=time.time(),
            phases=[PhaseInfo(name, "pending") for name in DEFAULT_PHASES],
        )
        self._refresh_per_second = refresh_per_second
        self._demo = demo
        self.on_safe_quit = None  # set by the driver to hook real shutdown

    def compose(self) -> ComposeResult:
        yield Header(show_clock=True)
        with Vertical():
            with Horizontal(id="top_row"):
                yield HeaderBox(id="header_box")
                yield GlobalProgress(id="global_progress")
            with Horizontal(id="main_row"):
                with VerticalScroll(id="left_col"):
                    yield PhaseList(id="phase_list")
                    yield DifficultyBars(id="difficulty_bars")
                    yield StatsPanel(id="stats_panel")
                with VerticalScroll(id="right_col"):
                    yield CurrentItemPanel(id="current_item")
                    yield SubthemeCoverage(id="subtheme_coverage")
                    yield ImportPanel(id="import_panel")
                    yield ServicesPanel(id="services_panel")
            with Horizontal(id="bottom_row"):
                yield EventLog(id="event_log")
        yield Footer()

    def on_mount(self) -> None:
        self.set_interval(1 / self._refresh_per_second, self._refresh)
        if self._demo:
            self.set_interval(0.5, self._demo_tick)

    def update_state(self, state: DashboardState) -> None:
        self.state = state

    def _refresh(self) -> None:
        s = self.state
        self.query_one("#header_box", HeaderBox).update(HeaderBox().render_state(s))
        self.query_one("#global_progress", GlobalProgress).update(GlobalProgress().render_state(s))
        self.query_one("#phase_list", PhaseList).update(PhaseList().render_state(s))
        self.query_one("#difficulty_bars", DifficultyBars).update(DifficultyBars().render_state(s))
        self.query_one("#stats_panel", StatsPanel).update(StatsPanel().render_state(s))
        self.query_one("#current_item", CurrentItemPanel).update(CurrentItemPanel().render_state(s))
        self.query_one("#subtheme_coverage", SubthemeCoverage).update(SubthemeCoverage().render_state(s))
        self.query_one("#import_panel", ImportPanel).update(ImportPanel().render_state(s))
        self.query_one("#services_panel", ServicesPanel).update(ServicesPanel().render_state(s))
        self.query_one("#event_log", EventLog).update(EventLog().render_state(s))

    # --- key actions -----------------------------------------------------
    def action_pause(self) -> None:
        self.state.status_label = "PAUSE (utilisateur)"

    def action_resume(self) -> None:
        self.state.status_label = "GÉNÉRATION EN COURS"

    def action_save_checkpoint(self) -> None:
        self.state.recent_events.append(
            (datetime.now().strftime("%H:%M:%S"), "info", "Checkpoint sauvegardé manuellement (S)")
        )

    def action_show_logs(self) -> None:
        pass  # wired to a log viewer screen in Phase 3

    def action_safe_quit(self) -> None:
        if self.on_safe_quit:
            self.on_safe_quit()
        self.exit()

    # --- demo mode (no pipeline attached) ---------------------------------
    def _demo_tick(self) -> None:
        import random

        s = self.state
        diff = random.choice(["Facile", "Moyenne", "Difficile"])
        s.by_difficulty[diff] += random.randint(5, 15)
        s.generated += 1
        s.validated += 1
        s.items_per_minute = 42.0
        s.current_item_id = f"{random.randint(1000000, 9999999):08d}"
        s.current_item_difficulty = diff
        s.current_item_subtopic = "Ve République"
        s.current_item_subject = "Révision constitutionnelle"
        s.current_item_action = "Vérification factuelle"
        s.current_item_source = "Conseil constitutionnel"
        for i in range(5):
            s.phases[i].status = "done"
        s.phases[5].status = "active"
        if random.random() < 0.1:
            s.recent_events.append(
                (datetime.now().strftime("%H:%M:%S"), "warn", "Similarité élevée détectée")
            )
            s.quarantined += 1


if __name__ == "__main__":
    import sys

    demo = "--demo" in sys.argv
    app = GeneratorDashboard(demo=demo)
    app.run()
