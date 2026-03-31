create table public.permission__roles (
  id uuid not null default gen_random_uuid (),
  role text not null,
  description text null,
  constraint pemission_roles_pkey primary key (id)
) TABLESPACE pg_default;