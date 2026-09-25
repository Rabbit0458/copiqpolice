begin;

do $$
declare
  v_count integer;
  v_rls_count integer;
begin
  select count(*) into v_count
  from public.active_verification_questions
  where is_active;

  if v_count <> 4 then
    raise exception 'Le questionnaire actif doit contenir exactement 4 questions actives, trouvé: %', v_count;
  end if;

  if exists (
    select 1
    from public.active_verification_questions
    where position not between 1 and 4
       or expected_normalized not in ('lrppn', 'storm', 'tr', 'cheops')
  ) then
    raise exception 'Positions ou réponses normalisées invalides dans le questionnaire actif';
  end if;

  select count(*) into v_rls_count
  from pg_class
  where oid in (
    'public.active_verification_questions'::regclass,
    'public.active_access_verifications'::regclass,
    'public.active_verification_attempts'::regclass,
    'public.active_verification_answers'::regclass
  ) and relrowsecurity;

  if v_rls_count <> 4 then
    raise exception 'RLS doit être actif sur les 4 tables du module actif';
  end if;

  if has_table_privilege('anon', 'public.active_verification_questions', 'select')
     or has_table_privilege('authenticated', 'public.active_verification_questions', 'select') then
    raise exception 'Les réponses attendues ne doivent jamais être lisibles par le client';
  end if;

  if has_function_privilege('authenticated', 'public.active_admin_guard()', 'execute') then
    raise exception 'La garde administrateur interne ne doit pas être exécutable par le client';
  end if;

  if not has_function_privilege('authenticated', 'public.active_verification_submit(jsonb)', 'execute') then
    raise exception 'La soumission sécurisée doit rester disponible aux utilisateurs authentifiés';
  end if;
end
$$;

rollback;
