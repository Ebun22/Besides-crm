CREATE TABLE IF NOT EXISTS "bms"."document__details" (
  "id"             uuid  NOT NULL DEFAULT gen_random_uuid (),
  "file_path"      text      NULL,
  "type"           uuid      NULL,
  "doc_issuedate"  bigint    NULL,
  "doc_expdate"    bigint    NULL,
  "uploaded_by"    uuid      NULL,
  "uploaded_at"    uuid      NULL DEFAULT (EXTRACT(EPOCH FROM now() * 1000))::BIGINT,
  "supply_details" uuid      NULL,
  CONSTRAINT document__details_pkey      PRIMARY KEY ("id"),
  CONSTRAINT document__details_type_fkey FOREIGN KEY ("type")
    REFERENCES "bms"."document__types" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT document__details_owner_fkey FOREIGN KEY ("uploaded_by")
    REFERENCES "bms"."people__details" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
  CONSTRAINT document__details_supply_fkey FOREIGN KEY ("supply_details")
    REFERENCES "bms"."supply__details" ("id")
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
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
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
