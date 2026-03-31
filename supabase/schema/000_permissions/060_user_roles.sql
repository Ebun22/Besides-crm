create table public.permission__user_roles (
  id uuid not null default gen_random_uuid (),
  "user" uuid not null,
  role uuid not null,
  constraint permission__user_roles_pkey primary key (id)
) TABLESPACE pg_default;