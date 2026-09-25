"""Deterministic structural fingerprint — the free, no-LLM-cost first line of
dedup defense. Computed from the model's own SemanticFingerprint output, not
from the question text, so paraphrasing the question never changes the hash.
"""

from __future__ import annotations

import hashlib
import json

from pipeline.models import SemanticFingerprint


def compute_semantic_fingerprint(fp: SemanticFingerprint) -> str:
    canonical = json.dumps(fp.canonical_dict(), sort_keys=True, ensure_ascii=False)
    return hashlib.sha256(canonical.encode("utf-8")).hexdigest()
