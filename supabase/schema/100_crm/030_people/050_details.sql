CREATE TABLE IF NOT EXISTS "crm"."people__details" (
  "id"             uuid        NOT NULL DEFAULT gen_random_uuid (),
  "cognome"        varchar(60)     NULL,
  "nome"           varchar(60)     NULL,
  "legal_name"     text            NULL,
  "cod_fis"        varchar(16)     NULL,
  "p_iva"          varchar(11)     NULL,
  "ref_cognome"    text            NULL,
  "ref_nome"       text            NULL,
  "cl_celnum"      varchar(10)     NULL,
  "cl_fixnum"      varchar(10)     NULL,
  "email"          varchar(60)     NULL,
  "pec"            varchar(60)     NULL,
  "id_type"        uuid            NULL,
  "id_number"      varchar(40)     NULL,
  "tit_birthplace" text            NULL,
  "tit_birth_date" text            NULL,
  "tit_gender"     varchar(1)      NULL,
  "cust_address"   text            NULL,
  "type"           uuid        NOT NULL,
  "status"         uuid            NULL,
  CONSTRAINT people__details_pkey         PRIMARY KEY ("id"),
  CONSTRAINT people__details_status_fkey  FOREIGN KEY ("status")
    REFERENCES "crm"."people__status" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT people__details_type_fkey  FOREIGN KEY ("type")
    REFERENCES "crm"."people__types" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT people__details_id_type_fkey FOREIGN KEY ("id_type")
    REFERENCES "crm"."people__ID_types" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "crm"."people__details" OWNER TO "postgres";

ALTER TABLE "crm"."people__details" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "crm"."people__details"
FROM
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "crm"."people__details"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "crm"."people__details"
TO
  "service_role";

-- RLS
CREATE POLICY
  "Enable read access for all users"
ON
  "crm"."people__details"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- Insert RLS policy
CREATE POLICY
  "Enable insert for authenticated users only"
ON
  "crm"."people__details"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

-- Update RLS Policy
CREATE POLICY
  "Enable update for authenticated users only"
ON
  "crm"."people__details"
FOR UPDATE
TO
  "authenticated"
USING (
  true
);

-- Delete RLS Policy
CREATE POLICY
  "Enable Delete for authenticated users only"
ON
  "crm"."people__details"
FOR DELETE
TO
  "authenticated"
USING (
  true
);

ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "crm"."people__details";

-- TRIGGER
CREATE OR REPLACE FUNCTION "public"."set_default_people_status"()
RETURNS TRIGGER
AS
$$
BEGIN
    SELECT "id"
    INTO NEW."status"
    FROM "crm"."people__status"
    WHERE "name" = 'DRAFT'
    LIMIT 1;

    -- Safety: if DRAFT does not exist in people__status, block the insert
    IF NEW."status" IS NULL THEN
        RAISE EXCEPTION 'Setup Error: No DRAFT entry found in people__status table.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS
  "tr_set_default_people_status"
ON
  "crm"."people__details";

CREATE TRIGGER "tr_set_default_people_status"
BEFORE INSERT ON "crm"."people__details"
FOR EACH ROW
EXECUTE FUNCTION "public"."set_default_people_status"();
