-- These uniqueness constraints duplicate the primary keys on the same
-- columns. Removing them preserves exactly the same uniqueness guarantee.

drop index if exists public.app_meta_key_unique;

alter table public.free_weekly_usage
  drop constraint if exists free_weekly_usage_user_id_key;

alter table public.subscription_payement
  drop constraint if exists subscription_payement_user_id_key;

alter table public.subscription_payement
  drop constraint if exists subscription_payement_user_id_unique;
