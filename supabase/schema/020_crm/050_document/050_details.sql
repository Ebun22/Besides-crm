CREATE TABLE IF NOT EXISTS "crm"."document__details" (
  "id"            uuid  NOT NULL DEFAULT gen_random_uuid (),
  "document"      text      NULL,
  "type"          uuid      NULL,
  "doc_issuedate" bigint    NULL,
  "doc_expdate"   bigint    NULL,
  "uploaded_by"   uuid      NULL,
  "owner"         uuid      NULL,
  CONSTRAINT document__details_pkey      PRIMARY KEY ("id"),
  CONSTRAINT document__details_type_fkey FOREIGN KEY ("type")
    REFERENCES "crm"."document__types" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT document__details_owner_fkey FOREIGN KEY ("owner")
    REFERENCES "crm"."people__details" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "crm"."document__details" OWNER TO "postgres";

ALTER TABLE "crm"."document__details" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "crm"."document__details"
FROM
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "crm"."document__details"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "crm"."document__details"
TO
  "service_role";

-- RLS
CREATE POLICY
  "Enable read access for all users"
ON
  "crm"."document__details"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

CREATE POLICY
  "Enable insert for authenticated users only"
ON
  "crm"."document__details"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "crm"."document__details";
