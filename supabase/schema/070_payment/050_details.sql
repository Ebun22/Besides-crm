create table public.customer__payment (
  id uuid not null default gen_random_uuid (),
  cust_ref uuid null default gen_random_uuid (),
  pay_type uuid null,
  cc_cognome text null,
  cc_nome text null,
  pag_codfisc text null,
  cc_tit_birth_place text null,
  cc_tit_birth_date bigint null,
  cc_tit_sex character varying null,
  constraint payment_details_pkey primary key (id),
  constraint customer__payment_pay_type_fkey foreign KEY (pay_type) references payment__types (id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;