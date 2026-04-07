CREATE TABLE IF NOT EXISTS "public"."document__types" (
  "id"          uuid NOT NULL DEFAULT gen_random_uuid (),
  "type"        text NOT NULL,
  "description" text     NULL,
  CONSTRAINT document__types_pkey PRIMARY KEY ("id")
);

ALTER TABLE "public"."document__types" OWNER TO "postgres";

-- CLS
REVOKE
  ALL
ON TABLE
  "public"."document__types"
FROM
  "anon";

GRANT
  SELECT,
  REFERENCES,
  TRIGGER,
  TRUNCATE,
  MAINTAIN
ON TABLE
  "public"."permission__actions"
TO
  "authenticated";

GRANT
  ALL
ON TABLE
  "public"."document__types"
TO
  "service_role";

-- RLS
ALTER TABLE "public"."document__types" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users"
ON
  "public"."document__types"
FOR SELECT
TO
  "authenticated"
USING (
  true
);

-- SEED
INSERT INTO "public"."document__types"
(
  "name",
  "description"
)
VALUES
  ('virtual_bill',       NULL),
  ('prev_virtual_bill',  NULL),
  ('GDPR',               NULL),
  ('IDENTIFICATION_DOC', NULL);
