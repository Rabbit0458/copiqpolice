-- Remove PostgREST default privileges not required by the Coach client.
revoke all on public.coach_user_preferences from authenticated;
revoke all on public.coach_question_mastery from authenticated;
revoke all on public.coach_answer_reflections from authenticated;
revoke all on public.coach_weekly_summaries from authenticated;

grant select, insert, update on public.coach_user_preferences to authenticated;
grant select on public.coach_question_mastery to authenticated;
grant select, insert, update on public.coach_answer_reflections to authenticated;
grant select, insert, update on public.coach_weekly_summaries to authenticated;
