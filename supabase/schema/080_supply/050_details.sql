create table public.supply__details (
  id uuid not null default gen_random_uuid (),
  supp_address_1 text null,
  supp_address_2 text null,
  supp_zip bigint null,
  supp_town text null,
  supp_pr character varying null,
  constraint supply__details_pkey primary key (id)
) TABLESPACE pg_default;