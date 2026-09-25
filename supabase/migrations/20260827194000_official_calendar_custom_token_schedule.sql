-- The function validates a private server-side token itself. Keeping the
-- gateway JWT check disabled avoids coupling this internal cron job to the
-- legacy public anon JWT while preserving an unguessable invocation secret.
select cron.unschedule(jobid)
from cron.job
where jobname = 'copiq-official-police-calendar-daily';

select cron.schedule(
  'copiq-official-police-calendar-daily',
  '17 4 * * *',
  $job$
  select net.http_post(
    url := 'https://nuoonagnkhbeeymtvrcn.supabase.co/functions/v1/sync_official_police_calendar',
    headers := jsonb_build_object('Content-Type', 'application/json'),
    body := jsonb_build_object(
      'token', (select invocation_token from public.official_calendar_sync_config where singleton)
    ),
    timeout_milliseconds := 20000
  );
  $job$
);
