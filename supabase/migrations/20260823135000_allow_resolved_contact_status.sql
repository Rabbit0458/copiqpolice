-- Le centre de correction utilise un vocabulaire de statut uniforme.
-- Les contacts acceptent donc désormais "resolved" comme les autres signalements.
alter table public.contact_messages
  drop constraint if exists contact_messages_status_check;

alter table public.contact_messages
  add constraint contact_messages_status_check
  check (status = any (array['new'::text, 'read'::text, 'resolved'::text, 'archived'::text]));
