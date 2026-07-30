-- COP'IQ — Ferme l'exposition anon/authenticated sur les 14 tables de
-- sauvegarde issues du dédoublonnage de quiz_questions (C.2, 29/07/2026).
--
-- Signalé par l'auditeur de sécurité Supabase (rls_disabled, priority
-- critical) le 30/07/2026 lors du travail sur le système de badges :
-- ces tables étaient lisibles/modifiables par n'importe qui possédant la
-- clé publique de l'app.
--
-- Aucune policy ajoutée volontairement : ces tables ne sont consultées que
-- via le dashboard Supabase / migrations (clé service_role, qui contourne
-- toujours RLS) — jamais par le client. RLS activé sans policy = accès
-- client totalement bloqué, accès admin/service_role inchangé.
--
-- À supprimer (pas juste verrouiller) une fois le dédoublonnage validé
-- quelques jours en prod, comme prévu dans RESTE_A_FAIRE.md § C.2.

ALTER TABLE public.quiz_questions_backup_police ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions_backup_sport ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions_backup_droit ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions_backup_securite ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions_backup_institutions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions_backup_france ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions_backup_musique ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions_backup_sciences ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions_backup_sante ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions_backup_mythologie ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions_backup_actualite ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions_backup_cinema ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions_backup_histoire ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions_backup_geographie ENABLE ROW LEVEL SECURITY;
