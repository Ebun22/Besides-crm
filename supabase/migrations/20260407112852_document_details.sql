CREATE TABLE IF NOT EXISTS "public"."document__details" (
  "id"            uuid  NOT NULL DEFAULT gen_random_uuid (),
  "document"      text      NULL,
  "type"          uuid      NULL,
  "doc_issuedate" bigint    NULL,
  "doc_expdate"   bigint    NULL,
  "uploaded_by"   uuid      NULL,
  "owner"         uuid      NULL,
  CONSTRAINT document__details_pkey      PRIMARY KEY ("id"),
  CONSTRAINT document__details_type_fkey FOREIGN KEY ("type")
    REFERENCES "public"."document__types" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT document__details_owner_fkey FOREIGN KEY ("owner")
    REFERENCES "public"."people__details" ("id")
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

ALTER TABLE "public"."document__details" OWNER TO "postgres";

ALTER TABLE "public"."document__details" ENABLE ROW LEVEL SECURITY;

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."document__details"
FROM
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "public"."document__details"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "public"."document__details"
TO
  "service_role";

-- RLS
CREATE POLICY
  "Enable read access for all users"
ON
  "public"."document__details"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

CREATE POLICY
  "Enable insert for authenticated users only"
ON
  "public"."document__details"
FOR INSERT
TO
  "authenticated"
WITH CHECK (
  true
);

ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."document__details";
