create table public.customer__supply_details (
  id uuid not null default gen_random_uuid (),
  supp_ref uuid not null,
  cust_ref uuid not null,
  constraint customer__supply_details_pkey primary key (id),
  constraint customer__supply_details_supp_ref_fkey foreign KEY (supp_ref) references customer__supply_details (id) on update CASCADE on delete CASCADE,
  constraint customer__supply_details_cust_ref_fkey foreign KEY (cust_ref) references customer__details (id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;