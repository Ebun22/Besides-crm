CREATE TABLE IF NOT EXISTS "bms"."document__details" (
  "id"                    uuid NOT NULL DEFAULT gen_random_uuid (),
  "file_path"             text     NULL,
  "type"                  uuid     NULL,
  "periodo_fatturazione"  bigint   NULL,
  "negotiation"           uuid     NULL,
  "uploaded_at"           bigint   NULL DEFAULT (EXTRACT(EPOCH FROM now()) * 1000)::BIGINT,
  CONSTRAINT document__details_pkey      PRIMARY KEY ("id"),
  CONSTRAINT document__details_type_fkey FOREIGN KEY ("type")
    REFERENCES "bms"."document__types" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT document__details_owner_fkey FOREIGN KEY ("negotiation")
    REFERENCES "crm"."negotiation__details" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "bms"."document__details" OWNER TO "postgres";

ALTER TABLE "bms"."document__details" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."document__details"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT,
  INSERT,
  UPDATE,
  DELETE
ON TABLE
  "bms"."document__details"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "bms"."document__details"
TO
  "service_role";

-- RLS
CREATE POLICY
  "Enable read access for all users"
ON
  "bms"."document__details"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

CREATE POLICY
  "Enable insert for authenticated users only"
ON
  "bms"."document__details"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "bms"."document__details";
