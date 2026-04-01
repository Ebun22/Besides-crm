CREATE TABLE IF NOT EXISTS "public".people__details (
  id uuid not null default gen_random_uuid (),
  cognome text null,
  nome text null,
  cod_fis character varying null,
  ref_cognome text null,
  ref_nome text null,
  cl_celnum character varying null,
  cl_fixnum character varying null,
  email character varying null,
  pec character varying null,
  id_type uuid null,
  id_number character varying null,
  tit_birthplace text null,
  tit_birth_date text null,
  tit_gender character varying null,
  cust_address_1 text null,
  cust_address_2 text null,
  cust_zip bigint null,
  cust_town text null,
  cust_pr character varying null,
  role.  uuid not null,
  status uuid null,
  constraint people__details_pkey primary key (id),
  constraint people__details_status_fkey foreign KEY (status) references customer__status (id) on update CASCADE on delete CASCADE,
  constraint people__details_id_type_fkey foreign KEY (id_type) references id_document__types (id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;

ALTER TABLE "public"."customer__details" OWNER TO "postgres";

REVOKE
  ALL
ON TABLE "public"."customer__details" TO "anon";
GRANT ALL ON TABLE "public"."customer__details" TO "authenticated";
GRANT ALL ON TABLE "public"."customer__details" TO "service_role";

ALTER TABLE "public"."customer__details" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users" ON "public"."customer__details" FOR SELECT TO "authenticated" USING (true);

CREATE POLICY "Enable insert for authenticated users only" ON "public"."customer__details" FOR INSERT TO "authenticated" WITH CHECK (true);

ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."customer__details";