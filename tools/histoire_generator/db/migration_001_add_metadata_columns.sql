-- DRAFT — reviewed by user, NOT applied yet.
-- Adds nullable metadata columns to public.quiz_questions.
-- Additive only: no existing rows/columns touched, no other category affected.
-- Reversible: columns can be dropped with no data loss on other categories.

alter table public.quiz_questions
  add column if not exists source_name text,
  add column if not exists source_url text,
  add column if not exists reference_date date,
  add column if not exists verified_at timestamptz,
  add column if not exists semantic_fingerprint text;

-- Fast lookup for structural dedup during import.
create index if not exists quiz_questions_semantic_fingerprint_idx
  on public.quiz_questions (semantic_fingerprint)
  where semantic_fingerprint is not null;

-- DB-level guarantee (defense in depth, on top of app-level dedup):
-- two rows in the same category can never share a semantic fingerprint.
-- NULLs (all pre-existing rows) are excluded from the uniqueness check.
create unique index if not exists uq_quiz_questions_category_fingerprint
  on public.quiz_questions (category, semantic_fingerprint)
  where semantic_fingerprint is not null;
