CREATE TABLE IF NOT EXISTS "public"."people__details" (
  "id"             uuid              NOT NULL DEFAULT gen_random_uuid (),
  "cognome"        text                  NULL,
  "nome"           text                  NULL,
  "cod_fis"        varchar(60)           NULL,
  "ref_cognome"    text                  NULL,
  "ref_nome"       text                  NULL,
  "cl_celnum"      varchar(60)           NULL,
  "cl_fixnum"      varchar(60)           NULL,
  "email"          varchar(60)           NULL,
  "pec"            varchar(60)           NULL,
  "id_type"        uuid                  NULL,
  "id_number"      varchar(60)           NULL,
  "tit_birthplace" text                  NULL,
  "tit_birth_date" text                  NULL,
  "tit_gender"     varchar(60)           NULL,
  "cust_address_1" text                  NULL,
  "cust_address_2" text                  NULL,
  "cust_zip"       bigint                NULL,
  "cust_town"      text                  NULL,
  "cust_pr"        varchar(60)           NULL,
  "role"           uuid              NOT NULL,
  "status"         uuid                  NULL,
  CONSTRAINT people__details_pkey         PRIMARY KEY ("id"),
  CONSTRAINT people__details_status_fkey  FOREIGN KEY ("status")
    REFERENCES "public"."customer__status" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT people__details_id_type_fkey FOREIGN KEY ("id_type")
    REFERENCES "public"."id_document__types" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "public"."people__details" OWNER TO "postgres";

ALTER TABLE "public"."people__details" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."people__details"
FROM
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "public"."people__details"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "public"."people__details"
TO
  "service_role";

-- RLS
CREATE POLICY
  "Enable read access for all users"
ON
  "public"."people__details"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

CREATE POLICY
  "Enable insert for authenticated users only"
ON
  "public"."people__details"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."people__details";
