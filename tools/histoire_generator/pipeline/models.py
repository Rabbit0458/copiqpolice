"""Data shapes shared across the pipeline. Mirrors the DB schema exactly —
see db/migration_001_add_metadata_columns.sql and
db/migration_002_create_staging_table.sql. Field names match column names
1:1 so a StagingQuestion round-trips through Supabase without translation.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import date, datetime
from enum import Enum


class Difficulty(str, Enum):
    FACILE = "Facile"
    MOYENNE = "Moyenne"
    DIFFICILE = "Difficile"


class PipelineStatus(str, Enum):
    GENERATED = "GENERATED"
    FORMAT_VALIDATED = "FORMAT_VALIDATED"
    FACT_CHECKED = "FACT_CHECKED"
    ANSWER_VALIDATED = "ANSWER_VALIDATED"
    DISTRACTORS_VALIDATED = "DISTRACTORS_VALIDATED"
    EXPLANATION_VALIDATED = "EXPLANATION_VALIDATED"
    DIFFICULTY_SCORED = "DIFFICULTY_SCORED"
    DEDUP_TEXT_CHECKED = "DEDUP_TEXT_CHECKED"
    DEDUP_SEMANTIC_CHECKED = "DEDUP_SEMANTIC_CHECKED"
    CATEGORY_VALIDATED = "CATEGORY_VALIDATED"
    DB_VALIDATED = "DB_VALIDATED"
    READY_FOR_IMPORT = "READY_FOR_IMPORT"
    IMPORTED = "IMPORTED"
    REJECTED = "REJECTED"
    QUARANTINED = "QUARANTINED"


@dataclass
class SemanticFingerprint:
    """The knowledge-target descriptor the model must output alongside every
    question. Hashed (sha256, sorted keys) into `semantic_fingerprint` for
    exact structural dedup. Two questions with the same hash test the same
    knowledge regardless of wording — the spec's core anti-duplication rule.
    """

    topic: str
    subtopic: str
    entity: str
    relation: str
    correct_answer: str
    time_period: str
    knowledge_target: str

    def canonical_dict(self) -> dict:
        return {
            "topic": self.topic.strip().lower(),
            "subtopic": self.subtopic.strip().lower(),
            "entity": self.entity.strip().lower(),
            "relation": self.relation.strip().lower(),
            "correct_answer": self.correct_answer.strip().lower(),
            "time_period": self.time_period.strip().lower(),
            "knowledge_target": self.knowledge_target.strip().lower(),
        }


@dataclass
class StagingQuestion:
    question: str
    options: list[str]
    answer: str
    explanation: str
    difficulty: Difficulty
    semantic_fingerprint: str  # sha256 hex digest of SemanticFingerprint.canonical_dict()
    generation_subtopic: str
    module: str = "Culture générale"
    category: str = "Histoire"
    sub: str | None = None

    # metadata for facts susceptible to change over time
    source_name: str | None = None
    source_url: str | None = None
    reference_date: date | None = None
    verified_at: datetime | None = None

    # pipeline tracking
    id: int | None = None
    pipeline_status: PipelineStatus = PipelineStatus.GENERATED
    rejection_reason: str | None = None
    similarity_score: float | None = None
    similar_to_id: int | None = None
    batch_id: str | None = None


@dataclass
class ValidationOutcome:
    passed: bool
    stage: PipelineStatus
    reason: str | None = None
