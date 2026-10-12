-- Read-only school RPCs must obey the caller's Premium/admin RLS policies.
alter function public.quiz_scolarite_session(text,text,integer) security invoker;
alter function public.quiz_scolarite_counts(text) security invoker;
alter function public.organisation_quiz_session(text,text,integer) security invoker;
