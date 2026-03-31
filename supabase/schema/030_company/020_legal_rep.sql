create table public.company__leg_ref (
  id uuid not null default gen_random_uuid (),
  legal_rep uuid not null,
  comp_ref uuid not null,
  constraint company__leg_ref_pkey primary key (id),
  constraint company__leg_ref_legal_rep_fkey foreign KEY (legal_rep) references legal_rep__details (id) on update CASCADE on delete CASCADE,
  constraint company__leg_ref_comp_ref_fkey foreign KEY (comp_ref) references company__details (id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;