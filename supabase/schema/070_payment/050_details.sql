CREATE TABLE IF NOT EXISTS "public"."payment__details" (
  "id"                 uuid NOT NULL DEFAULT gen_random_uuid (),
  "cust_ref"           uuid     NULL DEFAULT gen_random_uuid (),
  "pay_type"           uuid     NULL,
  "cc_cognome"         text     NULL,
  "cc_nome"            text     NULL,
  "pag_codfisc"        text     NULL,
  "cc_tit_birth_place" text     NULL,
  "cc_tit_birth_date"  bigint   NULL,
  "cc_tit_sex"         varchar  NULL,
  CONSTRAINT payment_details_pkey            PRIMARY KEY ("id"),
  CONSTRAINT payment__details_customer_fkey  FOREIGN KEY ("cust_ref")
    REFERENCES people__details ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT payment__details_pay_type_fkey FOREIGN KEY ("pay_type")
    REFERENCES payment__types ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "public"."payment__details" OWNER TO "postgres";

ALTER TABLE "public"."payment__details" ENABLE ROW LEVEL SECURITY;
