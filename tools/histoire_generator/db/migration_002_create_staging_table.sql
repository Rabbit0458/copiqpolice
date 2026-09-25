-- DRAFT — reviewed by user, NOT applied yet.
-- Staging table for the "Histoire de France & Institutions" refonte.
-- Mirrors public.quiz_questions + pipeline/tracking columns.
-- Nothing here touches public.quiz_questions or any other table.
-- Only the pipeline's service_role connection reads/writes this table
-- (RLS enabled, zero policies -> unreachable via anon/authenticated keys,
-- reachable only via service_role which bypasses RLS entirely).

create table if not exists public.quiz_questions_staging_histoire (
  id bigint generated always as identity primary key,
  module text not null default 'Culture générale',
  category text not null default 'Histoire',
  question text not null,
  options jsonb not null default '[]'::jsonb
    constraint quiz_questions_staging_histoire_options_array_check
    check (jsonb_typeof(options) = 'array'),
  answer text not null,
  explanation text not null,
  difficulty text not null
    constraint quiz_questions_staging_histoire_difficulty_check
    check (difficulty in ('Facile', 'Moyenne', 'Difficile')),
  sub text,

  -- metadata (mirrors migration_001, so promotion to quiz_questions is a straight column copy)
  source_name text,
  source_url text,
  reference_date date,
  verified_at timestamptz,
  semantic_fingerprint text not null,

  -- pipeline tracking (not present on quiz_questions — stripped on promotion)
  pipeline_status text not null default 'GENERATED'
    constraint quiz_questions_staging_histoire_status_check
    check (pipeline_status in (
      'GENERATED', 'FORMAT_VALIDATED', 'FACT_CHECKED', 'ANSWER_VALIDATED',
      'DISTRACTORS_VALIDATED', 'EXPLANATION_VALIDATED', 'DIFFICULTY_SCORED',
      'DEDUP_TEXT_CHECKED', 'DEDUP_SEMANTIC_CHECKED', 'CATEGORY_VALIDATED',
      'DB_VALIDATED', 'READY_FOR_IMPORT', 'IMPORTED', 'REJECTED', 'QUARANTINED'
    )),
  rejection_reason text,
  similarity_score double precision,
  similar_to_id bigint references public.quiz_questions_staging_histoire(id),
  batch_id text,
  generation_subtopic text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index if not exists uq_staging_histoire_fingerprint
  on public.quiz_questions_staging_histoire (semantic_fingerprint);

create index if not exists staging_histoire_status_idx
  on public.quiz_questions_staging_histoire (pipeline_status);

create index if not exists staging_histoire_difficulty_idx
  on public.quiz_questions_staging_histoire (difficulty, pipeline_status);

create index if not exists staging_histoire_subtopic_idx
  on public.quiz_questions_staging_histoire (generation_subtopic, difficulty);

alter table public.quiz_questions_staging_histoire enable row level security;
-- Intentionally zero policies: only service_role (bypasses RLS) can touch this table.
