-- Sauvegardes immuables des questions avant modification éditoriale.
-- La première capture distante utilise le lot
-- `2026-08-17-flagrant-medium-before-150` (501 lignes).

create schema if not exists private;

create table if not exists private.quiz_scolarite_questions_backups (
  backup_id bigint generated always as identity primary key,
  backup_batch text not null,
  source_question_id bigint not null,
  snapshot jsonb not null,
  backed_up_at timestamptz not null default now(),
  unique (backup_batch, source_question_id)
);

revoke all on private.quiz_scolarite_questions_backups
  from public, anon, authenticated;
grant select, insert on private.quiz_scolarite_questions_backups
  to service_role;
