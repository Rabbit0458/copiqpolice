-- Auto-generated fix for auth_rls_initplan advisor warnings.
-- Wraps auth.uid()/auth.jwt()/auth.role()/current_setting() in (select ...)
-- so Postgres evaluates them ONCE per statement instead of once per row.
-- Semantically identical -- pure performance rewrite. Generated 29/07/2026.

BEGIN;

ALTER POLICY "sel_settings_own" ON public.user_settings USING ((user_id = (select auth.uid())));
ALTER POLICY "upd_settings_own" ON public.user_settings USING ((user_id = (select auth.uid())));
ALTER POLICY "insert_own_results" ON public.placement_results WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "select_own_results" ON public.placement_results USING ((user_id = (select auth.uid())));
ALTER POLICY "insert_own_answers" ON public.placement_answers WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "select_own_answers" ON public.placement_answers USING ((user_id = (select auth.uid())));
ALTER POLICY "contact_messages_insert_auth" ON public.contact_messages WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "insert_from_edge" ON public.app_events WITH CHECK (((select auth.role()) = ANY (ARRAY['anon'::text, 'authenticated'::text])));
ALTER POLICY "quiz_infraction_insert_own" ON public.quiz_infraction WITH CHECK (((uid)::text = ((select auth.uid()))::text));
ALTER POLICY "logs_insert_own" ON public.app_logs WITH CHECK (((user_id IS NULL) OR (user_id = (select auth.uid()))));
ALTER POLICY "Enable read access for authenticated users" ON public.app_meta USING (((select auth.role()) = 'authenticated'::text));
ALTER POLICY "Enable write access for admin users" ON public.app_meta USING ((EXISTS ( SELECT 1
   FROM admin_users
  WHERE (admin_users.email = ((select auth.jwt()) ->> 'email'::text)))));
ALTER POLICY "quiz_history_insert_own" ON public.quiz_history WITH CHECK (((uid)::text = ((select auth.uid()))::text));
ALTER POLICY "quiz_history select own rows" ON public.quiz_history USING (((uid)::text = ((select auth.uid()))::text));
ALTER POLICY "quiz_history insert own rows" ON public.quiz_history WITH CHECK (((uid)::text = ((select auth.uid()))::text));
ALTER POLICY "Users can insert their own complicite answers" ON public.quiz_complicite WITH CHECK (((select auth.uid()) = uid));
ALTER POLICY "insert own result" ON public.placement_results WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "select own results" ON public.placement_results USING ((user_id = (select auth.uid())));
ALTER POLICY "insert own answers" ON public.placement_answers WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "select own answers" ON public.placement_answers USING ((user_id = (select auth.uid())));
ALTER POLICY "admin_users_select_self" ON public.admin_users USING ((lower(email) = lower(((select auth.jwt()) ->> 'email'::text))));
ALTER POLICY "admin_users_update_self" ON public.admin_users USING ((lower(email) = lower(((select auth.jwt()) ->> 'email'::text)))) WITH CHECK ((lower(email) = lower(((select auth.jwt()) ->> 'email'::text))));
ALTER POLICY "app_meta_admin_select" ON public.app_meta USING (is_admin((select auth.uid())));
ALTER POLICY "app_meta_admin_upsert" ON public.app_meta WITH CHECK (is_admin((select auth.uid())));
ALTER POLICY "quiz_tentative_insert_own" ON public.quiz_tentative WITH CHECK (((select auth.uid()) = user_uid));
ALTER POLICY "app_meta_admin_update" ON public.app_meta USING (is_admin((select auth.uid()))) WITH CHECK (is_admin((select auth.uid())));
ALTER POLICY "patch_notes_admin_select" ON public.patch_notes USING (is_admin((select auth.uid())));
ALTER POLICY "patch_notes_admin_insert" ON public.patch_notes WITH CHECK (is_admin((select auth.uid())));
ALTER POLICY "patch_notes_admin_update" ON public.patch_notes USING (is_admin((select auth.uid()))) WITH CHECK (is_admin((select auth.uid())));
ALTER POLICY "patch_notes_admin_delete" ON public.patch_notes USING (is_admin((select auth.uid())));
ALTER POLICY "bug_reports_admin_select" ON public.bug_reports USING (is_admin((select auth.uid())));
ALTER POLICY "bug_reports_admin_delete" ON public.bug_reports USING (is_admin((select auth.uid())));
ALTER POLICY "bug_update_admin" ON public.bug_reports USING (is_elevated((select auth.uid()))) WITH CHECK (is_elevated((select auth.uid())));
ALTER POLICY "bug_delete_admin" ON public.bug_reports USING (is_elevated((select auth.uid())));
ALTER POLICY "Users can view their own complicite answers" ON public.quiz_complicite USING (((select auth.uid()) = uid));
ALTER POLICY "app_logs insert own row" ON public.app_logs WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "corr_select_own" ON public.cas_pratique_corrections USING (((select auth.uid()) = user_id));
ALTER POLICY "app_logs select own" ON public.app_logs USING ((user_id = (select auth.uid())));
ALTER POLICY "quiz_tentative_update_own" ON public.quiz_tentative USING (((select auth.uid()) = user_uid)) WITH CHECK (((select auth.uid()) = user_uid));
ALTER POLICY "quiz_history update own rows" ON public.quiz_history USING (((uid)::text = ((select auth.uid()))::text)) WITH CHECK (((uid)::text = ((select auth.uid()))::text));
ALTER POLICY "corr_upsert_own" ON public.cas_pratique_corrections WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "corr_update_own" ON public.cas_pratique_corrections USING (((select auth.uid()) = user_id)) WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "attempts_select_own" ON public.cas_pratique_attempts USING (((select auth.uid()) = user_id));
ALTER POLICY "attempts_insert_own" ON public.cas_pratique_attempts WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "attempts_update_own" ON public.cas_pratique_attempts USING (((select auth.uid()) = user_id)) WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "answers_select_own" ON public.cas_pratique_answers USING (((select auth.uid()) = user_id));
ALTER POLICY "answers_insert_own" ON public.cas_pratique_answers WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "answers_update_own" ON public.cas_pratique_answers USING (((select auth.uid()) = user_id)) WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "results_select_own" ON public.cas_pratique_results USING (((select auth.uid()) = user_id));
ALTER POLICY "results_insert_own" ON public.cas_pratique_results WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "results_update_own" ON public.cas_pratique_results USING (((select auth.uid()) = user_id)) WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "posts_insert_not_banned" ON public.forum_posts_exam_gpx WITH CHECK ((((select auth.uid()) IS NOT NULL) AND (author_id = (select auth.uid())) AND (NOT (EXISTS ( SELECT 1
   FROM forum_bans
  WHERE ((forum_bans.user_id = (select auth.uid())) AND (forum_bans.is_active = true) AND ((forum_bans.expires_at IS NULL) OR (forum_bans.expires_at > now()))))))));
ALTER POLICY "posts_delete_owner_or_mod" ON public.forum_posts_exam_gpx USING (((author_id = (select auth.uid())) OR is_moderator()));
ALTER POLICY "reports_insert_authenticated" ON public.forum_reports WITH CHECK ((((select auth.uid()) IS NOT NULL) AND (reporter_id = (select auth.uid()))));
ALTER POLICY "blocks_insert_owner" ON public.forum_blocks WITH CHECK ((((select auth.uid()) IS NOT NULL) AND (blocker_id = (select auth.uid()))));
ALTER POLICY "blocks_select_owner" ON public.forum_blocks USING ((blocker_id = (select auth.uid())));
ALTER POLICY "blocks_delete_owner" ON public.forum_blocks USING ((blocker_id = (select auth.uid())));
ALTER POLICY "author can update own comment" ON public.forum_post_comments_exam_gpx USING ((author_id = (select auth.uid()))) WITH CHECK ((author_id = (select auth.uid())));
ALTER POLICY "mod can soft delete comments" ON public.forum_post_comments_exam_gpx USING ((EXISTS ( SELECT 1
   FROM user_profiles up
  WHERE ((up.user_id = (select auth.uid())) AND (up.role = ANY (ARRAY['admin'::user_role, 'moderator'::user_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM user_profiles up
  WHERE ((up.user_id = (select auth.uid())) AND (up.role = ANY (ARRAY['admin'::user_role, 'moderator'::user_role]))))));
ALTER POLICY "mod can soft delete posts" ON public.forum_posts_exam_gpx USING ((EXISTS ( SELECT 1
   FROM user_profiles up
  WHERE ((up.user_id = (select auth.uid())) AND (up.role = ANY (ARRAY['admin'::user_role, 'moderator'::user_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM user_profiles up
  WHERE ((up.user_id = (select auth.uid())) AND (up.role = ANY (ARRAY['admin'::user_role, 'moderator'::user_role]))))));
ALTER POLICY "billing_profiles_select_own" ON public.billing_profiles USING (((select auth.uid()) = user_id));
ALTER POLICY "billing_profiles_upsert_own" ON public.billing_profiles WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "billing_profiles_update_own" ON public.billing_profiles USING (((select auth.uid()) = user_id)) WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "billing_pm_select_own" ON public.billing_payment_methods USING (((select auth.uid()) = user_id));
ALTER POLICY "billing_pm_insert_own" ON public.billing_payment_methods WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "billing_pm_update_own" ON public.billing_payment_methods USING (((select auth.uid()) = user_id)) WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "billing_sub_select_own" ON public.billing_subscriptions USING (((select auth.uid()) = user_id));
ALTER POLICY "billing_sub_update_own" ON public.billing_subscriptions USING (((select auth.uid()) = user_id)) WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "billing_invoices_select_own" ON public.billing_invoices USING (((select auth.uid()) = user_id));
ALTER POLICY "billing_events_select_own" ON public.billing_events USING (((select auth.uid()) = user_id));
ALTER POLICY "billing_events_insert_own" ON public.billing_events WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "billing_subscriptions_select_own" ON public.billing_subscriptions USING (((select auth.uid()) = user_id));
ALTER POLICY "billing_subscriptions_insert_own" ON public.billing_subscriptions WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "billing_subscriptions_update_own" ON public.billing_subscriptions USING (((select auth.uid()) = user_id)) WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "billing_events_read_own" ON public.billing_events USING (((select auth.uid()) = user_id));
ALTER POLICY "free_weekly_usage_read_own" ON public.free_weekly_usage USING (((select auth.uid()) = user_id));
ALTER POLICY "subscription_read_own" ON public.subscription_payement USING (((select auth.uid()) = user_id));
ALTER POLICY "stripe_customers_read_own" ON public.stripe_customers USING (((select auth.uid()) = user_id));
ALTER POLICY "read_own_usage" ON public.free_weekly_usage USING (((select auth.uid()) = user_id));
ALTER POLICY "Admins can manage subscription_payement" ON public.subscription_payement USING ((EXISTS ( SELECT 1
   FROM admin_users a
  WHERE ((a.id = (select auth.uid())) AND (lower(a.role) = ANY (ARRAY['owner'::text, 'admin'::text, 'superadmin'::text, 'developer'::text, 'moderator'::text])) AND (a.disabled = false))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM admin_users a
  WHERE ((a.id = (select auth.uid())) AND (lower(a.role) = ANY (ARRAY['owner'::text, 'admin'::text, 'superadmin'::text, 'developer'::text, 'moderator'::text])) AND (a.disabled = false)))));
ALTER POLICY "Admins manage subscription_payement" ON public.subscription_payement USING ((EXISTS ( SELECT 1
   FROM admin_users a
  WHERE ((a.disabled = false) AND (lower(a.role) = ANY (ARRAY['owner'::text, 'admin'::text, 'superadmin'::text, 'developer'::text, 'moderator'::text])) AND (((a.id)::text = ((select auth.uid()))::text) OR (lower(a.email) = lower((select auth.email())))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM admin_users a
  WHERE ((a.disabled = false) AND (lower(a.role) = ANY (ARRAY['owner'::text, 'admin'::text, 'superadmin'::text, 'developer'::text, 'moderator'::text])) AND (((a.id)::text = ((select auth.uid()))::text) OR (lower(a.email) = lower((select auth.email()))))))));
ALTER POLICY "User can read own subscription" ON public.subscription_payement USING (((select auth.uid()) = user_id));
ALTER POLICY "read_own_admin_user" ON public.admin_users USING ((id = (select auth.uid())));
ALTER POLICY "read_own_admin_user_by_email" ON public.admin_users USING ((lower(email) = lower((select auth.email()))));
ALTER POLICY "admin_users_self_select" ON public.admin_users USING ((((select auth.uid()) = auth_uid) OR (lower(email) = lower(((select auth.jwt()) ->> 'email'::text)))));
ALTER POLICY "report_cg_select_admin" ON public.report_culture_generale USING ((EXISTS ( SELECT 1
   FROM admin_users a
  WHERE ((a.auth_uid = (select auth.uid())) AND (COALESCE(a.disabled, false) = false)))));
ALTER POLICY "report_cg_update_admin" ON public.report_culture_generale USING ((EXISTS ( SELECT 1
   FROM admin_users a
  WHERE ((a.auth_uid = (select auth.uid())) AND (COALESCE(a.disabled, false) = false))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM admin_users a
  WHERE ((a.auth_uid = (select auth.uid())) AND (COALESCE(a.disabled, false) = false)))));
ALTER POLICY "report_cg_delete_admin" ON public.report_culture_generale USING ((EXISTS ( SELECT 1
   FROM admin_users a
  WHERE ((a.auth_uid = (select auth.uid())) AND (COALESCE(a.disabled, false) = false)))));
ALTER POLICY "select_own_profile" ON public.user_profiles USING (((select auth.uid()) = user_id));
ALTER POLICY "insert_own_profile" ON public.user_profiles WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "update_own_profile" ON public.user_profiles USING (((select auth.uid()) = user_id)) WITH CHECK (((select auth.uid()) = user_id));
ALTER POLICY "admin read all suite logique questions" ON public.tests_psyco_suite_logique USING ((EXISTS ( SELECT 1
   FROM admin_users au
  WHERE ((au.auth_uid = (select auth.uid())) AND (COALESCE(au.disabled, false) = false)))));
ALTER POLICY "admin insert suite logique questions" ON public.tests_psyco_suite_logique WITH CHECK ((EXISTS ( SELECT 1
   FROM admin_users au
  WHERE ((au.auth_uid = (select auth.uid())) AND (COALESCE(au.disabled, false) = false)))));
ALTER POLICY "admin update suite logique questions" ON public.tests_psyco_suite_logique USING ((EXISTS ( SELECT 1
   FROM admin_users au
  WHERE ((au.auth_uid = (select auth.uid())) AND (COALESCE(au.disabled, false) = false))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM admin_users au
  WHERE ((au.auth_uid = (select auth.uid())) AND (COALESCE(au.disabled, false) = false)))));
ALTER POLICY "admin delete suite logique questions" ON public.tests_psyco_suite_logique USING ((EXISTS ( SELECT 1
   FROM admin_users au
  WHERE ((au.auth_uid = (select auth.uid())) AND (COALESCE(au.disabled, false) = false)))));
ALTER POLICY "sp_select_self" ON public.subscription_payement USING (((user_id = (select auth.uid())) OR (EXISTS ( SELECT 1
   FROM user_profiles up
  WHERE ((up.user_id = (select auth.uid())) AND (up.role = ANY (ARRAY['owner'::user_role, 'admin'::user_role])))))));
ALTER POLICY "se_select_self" ON public.subscription_events USING (((user_id = (select auth.uid())) OR (EXISTS ( SELECT 1
   FROM user_profiles up
  WHERE ((up.user_id = (select auth.uid())) AND (up.role = ANY (ARRAY['owner'::user_role, 'admin'::user_role])))))));
ALTER POLICY "sc_select_self" ON public.stripe_customers USING (((user_id = (select auth.uid())) OR (EXISTS ( SELECT 1
   FROM user_profiles up
  WHERE ((up.user_id = (select auth.uid())) AND (up.role = ANY (ARRAY['owner'::user_role, 'admin'::user_role])))))));
ALTER POLICY "bi_select_self" ON public.billing_invoices USING (((user_id = (select auth.uid())) OR (EXISTS ( SELECT 1
   FROM user_profiles up
  WHERE ((up.user_id = (select auth.uid())) AND (up.role = ANY (ARRAY['owner'::user_role, 'admin'::user_role])))))));
ALTER POLICY "bp_all_self" ON public.billing_profiles USING ((user_id = (select auth.uid()))) WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "bpm_all_self" ON public.billing_payment_methods USING ((user_id = (select auth.uid()))) WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "be_select_self" ON public.billing_events USING (((user_id = (select auth.uid())) OR (EXISTS ( SELECT 1
   FROM user_profiles up
  WHERE ((up.user_id = (select auth.uid())) AND (up.role = ANY (ARRAY['owner'::user_role, 'admin'::user_role])))))));
ALTER POLICY "be_insert_self" ON public.billing_events WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "fwu_select_self" ON public.free_weekly_usage USING (((user_id = (select auth.uid())) OR (EXISTS ( SELECT 1
   FROM user_profiles up
  WHERE ((up.user_id = (select auth.uid())) AND (up.role = ANY (ARRAY['owner'::user_role, 'admin'::user_role])))))));
ALTER POLICY "rag_select_self" ON public.rewarded_ad_grants USING ((user_id = (select auth.uid())));
ALTER POLICY "audit_select_admin" ON public.admin_audit_logs USING ((EXISTS ( SELECT 1
   FROM admin_users a
  WHERE ((a.auth_uid = (select auth.uid())) AND (a.disabled = false) AND (lower(a.role) = ANY (ARRAY['owner'::text, 'admin'::text]))))));
ALTER POLICY "p_attempts_select" ON archive.practical_case_attempts USING (((user_id = (select auth.uid())) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text, 'helper'::text])));
ALTER POLICY "p_attempts_insert" ON archive.practical_case_attempts WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "p_attempts_update" ON archive.practical_case_attempts USING (((user_id = (select auth.uid())) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text]))) WITH CHECK (((user_id = (select auth.uid())) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text])));
ALTER POLICY "p_attempts_delete" ON archive.practical_case_attempts USING (((user_id = (select auth.uid())) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text])));
ALTER POLICY "p_answers_select" ON archive.practical_case_answers USING (((EXISTS ( SELECT 1
   FROM archive.practical_case_attempts a
  WHERE ((a.id = practical_case_answers.attempt_id) AND (a.user_id = (select auth.uid()))))) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text, 'helper'::text])));
ALTER POLICY "p_answers_insert" ON archive.practical_case_answers WITH CHECK ((EXISTS ( SELECT 1
   FROM archive.practical_case_attempts a
  WHERE ((a.id = practical_case_answers.attempt_id) AND (a.user_id = (select auth.uid()))))));
ALTER POLICY "p_answers_update" ON archive.practical_case_answers USING (((EXISTS ( SELECT 1
   FROM archive.practical_case_attempts a
  WHERE ((a.id = practical_case_answers.attempt_id) AND (a.user_id = (select auth.uid()))))) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text]))) WITH CHECK (((EXISTS ( SELECT 1
   FROM archive.practical_case_attempts a
  WHERE ((a.id = practical_case_answers.attempt_id) AND (a.user_id = (select auth.uid()))))) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text])));
ALTER POLICY "p_answers_delete" ON archive.practical_case_answers USING (((EXISTS ( SELECT 1
   FROM archive.practical_case_attempts a
  WHERE ((a.id = practical_case_answers.attempt_id) AND (a.user_id = (select auth.uid()))))) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text])));
ALTER POLICY "p_reviews_select" ON archive.practical_case_ai_reviews USING (((EXISTS ( SELECT 1
   FROM archive.practical_case_attempts a
  WHERE ((a.id = practical_case_ai_reviews.attempt_id) AND (a.user_id = (select auth.uid()))))) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text, 'helper'::text])));
ALTER POLICY "p_psy_hist_select" ON public.tests_psychotechnique_history USING (((user_id = (select auth.uid())) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text, 'helper'::text])));
ALTER POLICY "p_psy_hist_insert" ON public.tests_psychotechnique_history WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "p_psy_hist_update" ON public.tests_psychotechnique_history USING (((user_id = (select auth.uid())) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text]))) WITH CHECK (((user_id = (select auth.uid())) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text])));
ALTER POLICY "p_psy_hist_delete" ON public.tests_psychotechnique_history USING (((user_id = (select auth.uid())) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text])));
ALTER POLICY "p_likes_insert" ON public.forum_post_likes WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "p_likes_delete" ON public.forum_post_likes USING (((user_id = (select auth.uid())) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text])));
ALTER POLICY "p_rooms_select" ON public.forum_rooms USING (((created_by = (select auth.uid())) OR (EXISTS ( SELECT 1
   FROM forum_room_members m
  WHERE ((m.room_id = m.id) AND (m.user_id = (select auth.uid()))))) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text, 'helper'::text])));
ALTER POLICY "p_rooms_insert" ON public.forum_rooms WITH CHECK ((created_by = (select auth.uid())));
ALTER POLICY "p_rooms_update" ON public.forum_rooms USING (((created_by = (select auth.uid())) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text]))) WITH CHECK (((created_by = (select auth.uid())) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text])));
ALTER POLICY "p_rooms_delete" ON public.forum_rooms USING (((created_by = (select auth.uid())) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text])));
ALTER POLICY "p_members_select" ON public.forum_room_members USING (((user_id = (select auth.uid())) OR (EXISTS ( SELECT 1
   FROM forum_room_members m2
  WHERE ((m2.room_id = m2.room_id) AND (m2.user_id = (select auth.uid()))))) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text, 'helper'::text])));
ALTER POLICY "p_members_insert" ON public.forum_room_members WITH CHECK (((user_id = (select auth.uid())) OR (EXISTS ( SELECT 1
   FROM forum_rooms r
  WHERE ((r.id = forum_room_members.room_id) AND (r.created_by = (select auth.uid()))))) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text])));
ALTER POLICY "p_members_delete" ON public.forum_room_members USING (((user_id = (select auth.uid())) OR (EXISTS ( SELECT 1
   FROM forum_rooms r
  WHERE ((r.id = forum_room_members.room_id) AND (r.created_by = (select auth.uid()))))) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text])));
ALTER POLICY "p_msgs_select" ON public.forum_messages_exam_gpx USING (((EXISTS ( SELECT 1
   FROM forum_room_members m
  WHERE ((m.room_id = forum_messages_exam_gpx.room_id) AND (m.user_id = (select auth.uid()))))) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text])));
ALTER POLICY "p_msgs_insert" ON public.forum_messages_exam_gpx WITH CHECK (((sender_id = (select auth.uid())) AND (EXISTS ( SELECT 1
   FROM forum_room_members m
  WHERE ((m.room_id = forum_messages_exam_gpx.room_id) AND (m.user_id = (select auth.uid())))))));
ALTER POLICY "p_msgs_update" ON public.forum_messages_exam_gpx USING (((sender_id = (select auth.uid())) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text]))) WITH CHECK (((sender_id = (select auth.uid())) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text])));
ALTER POLICY "p_msgs_delete" ON public.forum_messages_exam_gpx USING (((sender_id = (select auth.uid())) OR has_admin_role(VARIADIC ARRAY['owner'::text, 'admin'::text, 'moderator'::text])));
ALTER POLICY "user_devices_select_own" ON public.user_devices USING ((user_id = (select auth.uid())));
ALTER POLICY "user_devices_insert_own" ON public.user_devices WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "user_devices_update_own" ON public.user_devices USING ((user_id = (select auth.uid()))) WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "user_devices_delete_own" ON public.user_devices USING ((user_id = (select auth.uid())));
ALTER POLICY "appeals_select_own" ON public.cas_pratique_appeals USING ((user_id = (select auth.uid())));
ALTER POLICY "appeals_insert_own" ON public.cas_pratique_appeals WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "p_attempts_select" ON public.photolangage_attempts USING ((user_id = (select auth.uid())));
ALTER POLICY "p_attempts_insert" ON public.photolangage_attempts WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "quiz_scol_answers_select_own" ON public.quiz_scolarite_answers USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "p_drafts_all" ON public.photolangage_drafts USING ((user_id = (select auth.uid()))) WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "corr_insert_own" ON public.cas_pratique_corrections WITH CHECK (((attempt_id IS NULL) OR (EXISTS ( SELECT 1
   FROM cas_pratique_attempts a
  WHERE ((a.id = cas_pratique_corrections.attempt_id) AND (a.user_id = (select auth.uid())))))));
ALTER POLICY "correction_details_insert_own" ON public.cas_pratique_correction_details WITH CHECK ((EXISTS ( SELECT 1
   FROM (cas_pratique_corrections c
     JOIN cas_pratique_attempts a ON ((a.id = c.attempt_id)))
  WHERE ((c.id = cas_pratique_correction_details.correction_id) AND (a.user_id = (select auth.uid()))))));
ALTER POLICY "correction_details_read_own" ON public.cas_pratique_correction_details USING (((EXISTS ( SELECT 1
   FROM cas_pratique_attempts a
  WHERE ((a.id = cas_pratique_correction_details.attempt_id) AND (a.user_id = (select auth.uid()))))) OR (EXISTS ( SELECT 1
   FROM (cas_pratique_corrections c
     JOIN cas_pratique_attempts a2 ON ((a2.id = c.attempt_id)))
  WHERE ((c.id = cas_pratique_correction_details.correction_id) AND (a2.user_id = (select auth.uid())))))));
ALTER POLICY "appeals_update_own" ON public.cas_pratique_appeals USING (((user_id = (select auth.uid())) AND (status = 'pending'::text))) WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "quiz_scol_answers_insert_own" ON public.quiz_scolarite_answers WITH CHECK ((user_uid = (select auth.uid())));
ALTER POLICY "app_events_select_own" ON public.app_events USING (((user_id = (select auth.uid())) OR has_admin_permission('admin_security'::text)));
ALTER POLICY "bug_reports_select_own" ON public.bug_reports USING ((user_id = (select auth.uid())));
ALTER POLICY "contact_messages_select_own" ON public.contact_messages USING (((user_id = (select auth.uid())) OR has_admin_permission('messages'::text)));
ALTER POLICY "quiz_controle_identite_select_own" ON public.quiz_controle_identite USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_libertes_intro_select_own" ON public.quiz_libertes_intro USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_mandats_justice_select_own" ON public.quiz_mandats_justice USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_mineurs_famille_select_own" ON public.quiz_mineurs_famille USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_culture_generale_pages_select_own" ON public.quiz_culture_generale_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_culture_generale_grammaire_pages_select_own" ON public.quiz_culture_generale_grammaire_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_culture_generale_institutions_europeennes_pages_select_own" ON public.quiz_culture_generale_institutions_europeennes_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_culture_generale_musique_pages_select_own" ON public.quiz_culture_generale_musique_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_culture_generale_mythologie_pages_select_own" ON public.quiz_culture_generale_mythologie_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_psycotechniques_calcul_pages_select_own" ON public.quiz_psycotechniques_calcul_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_psycotechniques_concentration_pages_select_own" ON public.quiz_psycotechniques_concentration_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_psycotechniques_raisonnement_pages_select_own" ON public.quiz_psycotechniques_raisonnement_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_psycotechniques_suite_logiques_pages_select_own" ON public.quiz_psycotechniques_suite_logiques_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_garanties_libertes_select_own" ON public.quiz_garanties_libertes USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_sanction_pluralite_select_own" ON public.quiz_sanction_pluralite USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_scolarite_answers_select_own" ON public.quiz_scolarite_answers USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "p_user_badges_select" ON public.cas_pratique_user_badges USING ((user_id = (select auth.uid())));
ALTER POLICY "quiz_langue_etrangere_allemand_select_own" ON public.quiz_langue_etrangere_allemand USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_culture_generale_securite_routiere_pages_select_own" ON public.quiz_culture_generale_securite_routiere_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_langue_etrangere_anglais_select_own" ON public.quiz_langue_etrangere_anglais USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_langue_etrangere_espagnol_select_own" ON public.quiz_langue_etrangere_espagnol USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_abandon_famille_select_own" ON public.quiz_abandon_famille USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_abus_autorite_particuliers_select_own" ON public.quiz_abus_autorite_particuliers USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_tentative_select_own" ON public.quiz_tentative USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_accueil_public_select_own" ON public.quiz_accueil_public USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_action_publique_select_own" ON public.quiz_action_publique USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_culture_generale_cinema_pages_select_own" ON public.quiz_culture_generale_cinema_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_atteinte_personnalite_select_own" ON public.quiz_atteinte_personnalite USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_armes_munitions_pages_select_own" ON public.quiz_armes_munitions_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_culture_generale_histoire_france_pages_select_own" ON public.quiz_culture_generale_histoire_france_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_culture_generale_actualite_pages_select_own" ON public.quiz_culture_generale_actualite_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_culture_generale_droit_pages_select_own" ON public.quiz_culture_generale_droit_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_culture_generale_geographie_pages_select_own" ON public.quiz_culture_generale_geographie_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "p_cp_question_reports_select_own" ON public.cas_pratique_question_reports USING ((user_id = (select auth.uid())));
ALTER POLICY "quiz_atteintes_action_justice_select_own" ON public.quiz_atteintes_action_justice USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_psycotechniques_verbal_pages_select_own" ON public.quiz_psycotechniques_verbal_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_atteintes_integrite_select_own" ON public.quiz_atteintes_integrite USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_deontologie_select_own" ON public.quiz_deontologie USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_organisation_pn_select_own" ON public.quiz_organisation_pn USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_instruction_preparatoire_select_own" ON public.quiz_instruction_preparatoire USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_nullite_select_own" ON public.quiz_nullite USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_mise_en_danger_select_own" ON public.quiz_mise_en_danger USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "p_cp_question_reports_insert_own" ON public.cas_pratique_question_reports WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "quiz_mise_peril_mineurs_select_own" ON public.quiz_mise_peril_mineurs USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_mort_inconnue_select_own" ON public.quiz_mort_inconnue USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_personnes_fuite_select_own" ON public.quiz_personnes_fuite USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_probite_select_own" ON public.quiz_probite USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_recel_non_justification_select_own" ON public.quiz_recel_non_justification USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_sanction_page_select_own" ON public.quiz_sanction_page USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_responsabilite_penale_select_own" ON public.quiz_responsabilite_penale USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_retention_locaux_police_select_own" ON public.quiz_retention_locaux_police USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_sanction_aggravation_peine_select_own" ON public.quiz_sanction_aggravation_peine USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_sanction_classification_peine_select_own" ON public.quiz_sanction_classification_peine USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_stad_select_own" ON public.quiz_stad USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_stupéfiants_select_own" ON public.quiz_stupéfiants USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_usagearmes_select_own" ON public.quiz_usagearmes USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_viol_inceste_agressions_select_own" ON public.quiz_viol_inceste_agressions USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_violation_ordonnances_jaf_select_own" ON public.quiz_violation_ordonnances_jaf USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_voisines_du_vol_select_own" ON public.quiz_voisines_du_vol USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_atteintes_volontaires_vie_select_own" ON public.quiz_atteintes_volontaires_vie USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_atteintes_administration_select_own" ON public.quiz_atteintes_administration USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_atteintes_involontaires_select_own" ON public.quiz_atteintes_involontaires USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_autorite_parentale_select_own" ON public.quiz_autorite_parentale USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_bracelet_electronique_select_own" ON public.quiz_bracelet_electronique USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_cadres_juridiques_principales_select_own" ON public.quiz_cadres_juridiques_principales USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_circulation_routiere_select_own" ON public.quiz_circulation_routiere USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_commission_rogatoire_select_own" ON public.quiz_commission_rogatoire USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_controle_judiciaire_select_own" ON public.quiz_controle_judiciaire USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_crimes_delits_bien_select_own" ON public.quiz_crimes_delits_bien USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_culture_generale_police_pages_select_own" ON public.quiz_culture_generale_police_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_culture_generale_sante_pages_select_own" ON public.quiz_culture_generale_sante_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_crimes_delits_personne_select_own" ON public.quiz_crimes_delits_personne USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_crimes_delits_nation_select_own" ON public.quiz_crimes_delits_nation USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_culture_generale_sciences_pages_select_own" ON public.quiz_culture_generale_sciences_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_criminalite_organisee_select_own" ON public.quiz_criminalite_organisee USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_ddd_select_own" ON public.quiz_ddd USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_detention_provisoire_select_own" ON public.quiz_detention_provisoire USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_dignite_personne_select_own" ON public.quiz_dignite_personne USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_disparitions_inquietantes_select_own" ON public.quiz_disparitions_inquietantes USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_dispositions_applicables_mineurs_select_own" ON public.quiz_dispositions_applicables_mineurs USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_culture_generale_sport_pages_select_own" ON public.quiz_culture_generale_sport_pages USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_droit_penale_select_own" ON public.quiz_droit_penale USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_enquete_preliminaire_select_own" ON public.quiz_enquete_preliminaire USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_enregistrement_diffusion_select_own" ON public.quiz_enregistrement_diffusion USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_faux_usage_faux_select_own" ON public.quiz_faux_usage_faux USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_flagrant_delit_select_own" ON public.quiz_flagrant_delit USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_generalite_principales_select_own" ON public.quiz_generalite_principales USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_hierarchie_select_own" ON public.quiz_hierarchie USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_introduction_select_own" ON public.quiz_introduction USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_juridictions_penales_select_own" ON public.quiz_juridictions_penales USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_legitimedefense_select_own" ON public.quiz_legitimedefense USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_libertes_collectives_select_own" ON public.quiz_libertes_collectives USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_libertes_individuelles_select_own" ON public.quiz_libertes_individuelles USING (((user_uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_complicite_select_own" ON public.quiz_complicite USING (((uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_infraction_select_own" ON public.quiz_infraction USING (((uid = (select auth.uid())) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_classification_infractions_select_own" ON public.quiz_classification_infractions USING ((((uid)::text = ((select auth.uid()))::text) OR has_admin_permission('results'::text)));
ALTER POLICY "quiz_history_select_own" ON public.quiz_history USING ((((uid)::text = ((select auth.uid()))::text) OR has_admin_permission('results'::text)));
ALTER POLICY "forum_posts_read" ON public.forum_posts_exam_gpx USING (((COALESCE(is_deleted, false) = false) OR (author_id = (select auth.uid())) OR has_admin_permission('flags'::text)));
ALTER POLICY "forum_comments_read" ON public.forum_post_comments_exam_gpx USING (((COALESCE(is_deleted, false) = false) OR (author_id = (select auth.uid())) OR has_admin_permission('flags'::text)));
ALTER POLICY "p_user_progress_select_own" ON public.cas_pratique_user_progress USING ((user_id = (select auth.uid())));
ALTER POLICY "cp_memo_reads_select_own" ON public.cas_pratique_memo_reads USING ((user_id = (select auth.uid())));
ALTER POLICY "cp_notes_select_own" ON public.cas_pratique_user_notes USING ((user_id = (select auth.uid())));
ALTER POLICY "cp_notes_insert_own" ON public.cas_pratique_user_notes WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "cp_notes_update_own" ON public.cas_pratique_user_notes USING ((user_id = (select auth.uid()))) WITH CHECK ((user_id = (select auth.uid())));
ALTER POLICY "cp_notes_delete_own" ON public.cas_pratique_user_notes USING ((user_id = (select auth.uid())));
ALTER POLICY "p_mock_attempts_select_self" ON public.cas_pratique_mock_exam_attempts USING ((user_id = (select auth.uid())));
ALTER POLICY "p_mock_answers_select_self" ON public.cas_pratique_mock_exam_answers USING ((EXISTS ( SELECT 1
   FROM cas_pratique_mock_exam_attempts a
  WHERE ((a.id = cas_pratique_mock_exam_answers.mock_attempt_id) AND (a.user_id = (select auth.uid()))))));
ALTER POLICY "p_mock_answers_write_self" ON public.cas_pratique_mock_exam_answers USING ((EXISTS ( SELECT 1
   FROM cas_pratique_mock_exam_attempts a
  WHERE ((a.id = cas_pratique_mock_exam_answers.mock_attempt_id) AND (a.user_id = (select auth.uid())) AND (a.status = 'in_progress'::text) AND (a.deadline_at > now()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM cas_pratique_mock_exam_attempts a
  WHERE ((a.id = cas_pratique_mock_exam_answers.mock_attempt_id) AND (a.user_id = (select auth.uid())) AND (a.status = 'in_progress'::text) AND (a.deadline_at > now())))));
ALTER POLICY "p_streak_freezes_user_select" ON public.cas_pratique_streak_freezes USING ((user_id = (select auth.uid())));
ALTER POLICY "p_xp_ledger_select" ON public.cas_pratique_xp_ledger USING ((user_id = (select auth.uid())));

COMMIT;
