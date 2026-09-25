-- Least-privilege and query indexes for the premium administration layer.

create index if not exists admin_external_metrics_source_idx on public.admin_external_metrics(source_key,metric_date desc);
create index if not exists admin_store_reviews_source_idx on public.admin_store_reviews(source_key,public_created_at desc);
create index if not exists admin_report_schedules_active_idx on public.admin_report_schedules(active,next_run_at) where active=true;
create index if not exists admin_restore_exercises_status_idx on public.admin_restore_exercises(status,created_at desc);
create index if not exists admin_bulk_jobs_created_idx on public.admin_bulk_jobs(created_at desc);
create index if not exists admin_saved_views_page_idx on public.admin_saved_views(owner_id,page_key,is_default,updated_at desc);

-- Anonymous clients may still INSERT logs or contact records through their
-- existing RLS policies, but must not discover private operational rows.
revoke select on table public.admin_users from anon;
revoke select on table public.admin_audit_logs from anon;
revoke select on table public.app_logs from anon;
revoke select on table public.billing_profiles from anon;
revoke select on table public.billing_payment_methods from anon;
revoke select on table public.billing_subscriptions from anon;
revoke select on table public.billing_invoices from anon;
revoke select on table public.billing_events from anon;
revoke select on table public.stripe_customers from anon;
revoke select on table public.subscription_events from anon;
revoke select on table public.cp_stripe_webhook_events from anon;
revoke select on table public.cp_revenuecat_webhook_events from anon;
revoke select on table public.admin_email_campaigns from anon;
revoke select on table public.admin_email_deliveries from anon;
revoke select on table public.admin_email_batches from anon;

