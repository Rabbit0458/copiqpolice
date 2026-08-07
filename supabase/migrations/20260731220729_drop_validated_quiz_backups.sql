-- The deduplicated category counts were revalidated on 2026-07-31 and the
-- unique (module, category, question) index is active. These temporary backup
-- tables are no longer needed.

drop table if exists
  public.quiz_questions_backup_sport,
  public.quiz_questions_backup_police,
  public.quiz_questions_backup_droit,
  public.quiz_questions_backup_securite,
  public.quiz_questions_backup_institutions,
  public.quiz_questions_backup_france,
  public.quiz_questions_backup_musique,
  public.quiz_questions_backup_sciences,
  public.quiz_questions_backup_sante,
  public.quiz_questions_backup_mythologie,
  public.quiz_questions_backup_actualite,
  public.quiz_questions_backup_cinema,
  public.quiz_questions_backup_histoire,
  public.quiz_questions_backup_geographie;
