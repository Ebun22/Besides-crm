create table public.permission__role_actions (
  id uuid not null default gen_random_uuid (),
  role_id uuid not null,
  action_id uuid not null,
  constraint permission__role_actions_pkey primary key (id)
) TABLESPACE pg_default;