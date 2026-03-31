create table public.company__details (
  id uuid not null default gen_random_uuid (),
  ragione_sociale text null,
  tipo_azienda uuid null,
  p_iva character varying null,
  cf_azienda character varying null,
  constraint company__details_pkey primary key (id),
  constraint company__details_tipo_azienda_fkey foreign KEY (tipo_azienda) references company__type (id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;