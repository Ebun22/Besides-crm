create table "public"."customer__types" (
  id uuid not null default gen_random_uuid (),
  name text not null,
  description text null,
  constraint contact__status_pkey primary key (id)
)