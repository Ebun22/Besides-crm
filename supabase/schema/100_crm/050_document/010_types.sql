CREATE TABLE IF NOT EXISTS "crm"."document__types" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT document__types_pkey PRIMARY KEY ("id")
);

ALTER TABLE "crm"."document__types" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "crm"."document__types"
FROM
  "anon",
  "authenticated";

GRANT
  SELECT
ON TABLE
  "crm"."document__types"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "crm"."document__types"
TO
  "service_role";

-- RLS
ALTER TABLE "crm"."document__types" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "crm"."document__types"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "crm"."document__types"
(
  "name",
  "description"
)
VALUES
  ('virtual_bill',       NULL),
  ('prev_virtual_bill',  NULL),
  ('GDPR',               NULL),
  ('IDENTIFICATION_DOC', NULL);
