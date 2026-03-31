create table public.payment__types (
  id uuid not null default gen_random_uuid (),
  name text not null,
  description text not null,
  constraint payment__types_pkey primary key (id)
) TABLESPACE pg_default;