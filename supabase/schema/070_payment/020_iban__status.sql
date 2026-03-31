create table public.iban__status (
  id uuid not null default gen_random_uuid (),
  name text not null,
  constraint iban__status_pkey primary key (id)
) TABLESPACE pg_default;