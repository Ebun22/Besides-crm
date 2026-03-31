create table public.company__type (
  id uuid not null default gen_random_uuid (),
  name text not null,
  description text null,
  constraint company__type_pkey primary key (id)
) TABLESPACE pg_default;