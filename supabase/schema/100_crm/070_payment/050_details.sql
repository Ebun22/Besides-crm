CREATE TABLE IF NOT EXISTS "crm"."payment__details" (
  "id"                 uuid NOT NULL DEFAULT gen_random_uuid (),
  "type"               uuid     NULL,
  "customer"           uuid     NULL,
  "cc_cognome"         text     NULL,
  "cc_nome"            text     NULL,
  "pag_codfisc"        text     NULL,
  "cc_tit_birth_place" text     NULL,
  "cc_tit_birth_date"  bigint   NULL,
  "cc_tit_sex"         varchar  NULL,
  CONSTRAINT payment__details_pkey          PRIMARY KEY ("id"),
  CONSTRAINT payment__details_customer_fkey FOREIGN KEY ("customer")
    REFERENCES "crm"."people__details" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT payment__details_type_fkey     FOREIGN KEY ("type")
    REFERENCES "crm"."payment__types" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "crm"."payment__details" OWNER TO "postgres";

ALTER TABLE "crm"."payment__details" ENABLE ROW LEVEL SECURITY;
