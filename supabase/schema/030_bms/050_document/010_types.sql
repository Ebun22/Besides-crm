CREATE TABLE IF NOT EXISTS "bms"."document__types" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "name"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT document__types_pkey PRIMARY KEY ("id")
);

ALTER TABLE "bms"."document__types" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "bms"."document__types"
FROM
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "bms"."permission__actions"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "bms"."document__types"
TO
  "service_role";

-- RLS
ALTER TABLE "bms"."document__types" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "bms"."document__types"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "bms"."document__types"
(
  "name",
  "description"
)
VALUES
  ('virtual_bill',       NULL),
  ('prev_virtual_bill',  NULL),
  ('GDPR',               NULL),
  ('IDENTIFICATION_DOC', NULL);
