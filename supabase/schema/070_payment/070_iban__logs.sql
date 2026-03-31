create table public.iban__logs (
  id uuid not null default gen_random_uuid (),
  iban_api_status uuid null,
  iban_bank_name text null,
  iban_bic bigint null,
  iban_country text null,
  constraint iban_logs_pkey primary key (id),
  constraint iban__logs_iban_api_status_fkey foreign KEY (iban_api_status) references iban__status (id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;