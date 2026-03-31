create table public.customer__company (
  id uuid not null default gen_random_uuid (),
  cust_ref uuid not null,
  comp_ref uuid not null,
  constraint customer__company_pkey primary key (id),
  constraint customer__company_cust_ref_fkey foreign KEY (cust_ref) references customer__details (id) on update CASCADE on delete CASCADE,
  constraint customer__company_comp_ref_fkey foreign KEY (comp_ref) references company__details (id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;